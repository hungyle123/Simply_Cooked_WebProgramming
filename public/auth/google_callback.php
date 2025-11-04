<?php
// /auth/google_callback.php
session_start();

// DB
require_once __DIR__ . '/../../config/db.php'; // $conn = new mysqli(...)
$oauth = require __DIR__ . '/../../config/oauth.php';
$cfg = $oauth['google'] ?? null;

function fail($msg, $code = 400) {
  http_response_code($code);
  echo htmlspecialchars($msg);
  exit;
}

if (!$cfg || empty($cfg['client_id']) || empty($cfg['client_secret']) || empty($cfg['redirect_uri'])) {
  fail('Google OAuth not configured', 500);
}

if (empty($_GET['state']) || empty($_SESSION['oauth_state']) || !hash_equals($_SESSION['oauth_state'], $_GET['state'])) {
  fail('Invalid OAuth state');
}
unset($_SESSION['oauth_state']); // one-time

if (isset($_GET['error'])) {
  fail('Google OAuth error: ' . $_GET['error']);
}

$code = $_GET['code'] ?? null;
if (!$code) fail('Missing authorization code');

// 1) Exchange code -> tokens
$tokenEndpoint = 'https://oauth2.googleapis.com/token';
$postBody = [
  'code'          => $code,
  'client_id'     => $cfg['client_id'],
  'client_secret' => $cfg['client_secret'],
  'redirect_uri'  => $cfg['redirect_uri'],
  'grant_type'    => 'authorization_code'
];

$ch = curl_init($tokenEndpoint);
curl_setopt_array($ch, [
  CURLOPT_POST => true,
  CURLOPT_POSTFIELDS => http_build_query($postBody),
  CURLOPT_RETURNTRANSFER => true,
  CURLOPT_TIMEOUT => 15,
]);
$tokenResp = curl_exec($ch);
$httpCode  = curl_getinfo($ch, CURLINFO_HTTP_CODE);
$err       = curl_error($ch);
curl_close($ch);

if ($httpCode !== 200 || !$tokenResp) {
  fail('Failed to exchange code: ' . $err, 502);
}
$tokenJson = json_decode($tokenResp, true);
$access_token = $tokenJson['access_token'] ?? null;
// $id_token = $tokenJson['id_token'] ?? null; // nếu cần decode JWT

if (!$access_token) fail('No access_token from Google', 502);

// 2) Get userinfo
$uiCh = curl_init('https://openidconnect.googleapis.com/v1/userinfo');
curl_setopt_array($uiCh, [
  CURLOPT_HTTPHEADER => ['Authorization: Bearer ' . $access_token],
  CURLOPT_RETURNTRANSFER => true,
  CURLOPT_TIMEOUT => 15,
]);
$userinfoResp = curl_exec($uiCh);
$uiCode       = curl_getinfo($uiCh, CURLINFO_HTTP_CODE);
$uiErr        = curl_error($uiCh);
curl_close($uiCh);

if ($uiCode !== 200 || !$userinfoResp) {
  fail('Failed to fetch userinfo: ' . $uiErr, 502);
}
$u = json_decode($userinfoResp, true);

// Expect fields: sub (google_id), email, name, picture
$google_id = $u['sub'] ?? null;
$email     = $u['email'] ?? null;
$name      = $u['name'] ?? null;
$picture   = $u['picture'] ?? null;

if (!$google_id || !$email) {
  fail('Insufficient userinfo from Google', 502);
}

// 3) Upsert user -> users table (google_id, email, full_name, profile_image_url)
$conn->set_charset('utf8mb4');

// Try find by google_id
$uid = null;
$stmt = $conn->prepare('SELECT user_id FROM users WHERE google_id = ?');
$stmt->bind_param('s', $google_id);
$stmt->execute();
$stmt->bind_result($found_id);
if ($stmt->fetch()) {
  $uid = (int)$found_id;
}
$stmt->close();

if (!$uid) {
  // If not found by google_id, try email
  $stmt = $conn->prepare('SELECT user_id FROM users WHERE email = ?');
  $stmt->bind_param('s', $email);
  $stmt->execute();
  $stmt->bind_result($found_by_email);
  if ($stmt->fetch()) {
    $uid = (int)$found_by_email;
  }
  $stmt->close();

  if ($uid) {
    // Link existing account with google_id
    $stmt = $conn->prepare('UPDATE users SET google_id = ? WHERE user_id = ?');
    $stmt->bind_param('si', $google_id, $uid);
    $stmt->execute();
    $stmt->close();
  } else {
    // Create new account
    $stmt = $conn->prepare('INSERT INTO users (username, email, password_hash, full_name, profile_image_url, google_id) VALUES (?, ?, ?, ?, ?, ?)');
    // password_hash: đặt chuỗi ngẫu nhiên/placeholder vì login qua Google (không dùng)
    $username = explode('@', $email)[0];
    $pwd = password_hash(bin2hex(random_bytes(8)), PASSWORD_DEFAULT);
    $stmt->bind_param('ssssss', $username, $email, $pwd, $name, $picture, $google_id);
    if (!$stmt->execute()) {
      $stmt->close();
      fail('Cannot create user');
    }
    $uid = $stmt->insert_id;
    $stmt->close();
  }
}

// 4) Start session
$_SESSION['user_id'] = $uid;
$_SESSION['user_email'] = $email;
$_SESSION['user_name']  = $name ?: $email;
$_SESSION['username']   = $_SESSION['user_name'];  // <-- thêm dòng này để tương thích với header cũ
$_SESSION['auth_provider'] = 'google';

$_SESSION['user'] = [
  'user_id'  => $_SESSION['user_id'],
  'username' => $_SESSION['user_name'],
  'email'    => $_SESSION['user_email']
];

// 5) Redirect to homepage (hoặc dashboard)
header('Location: ../index.php?login=google_success');
exit;
