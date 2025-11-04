<?php
// /auth/google_start.php
session_start();

// Load config
$oauth = require __DIR__ . '/../../config/oauth.php';
$cfg = $oauth['google'] ?? null;
if (!$cfg || empty($cfg['client_id']) || empty($cfg['redirect_uri'])) {
  http_response_code(500);
  echo 'Google OAuth is not configured.';
  exit;
}

$client_id    = $cfg['client_id'];
$redirect_uri = $cfg['redirect_uri']; // <-- CALLBACK (google_callback.php)
$scope        = 'openid email profile';

// CSRF state
if (empty($_SESSION['oauth_state'])) {
  $_SESSION['oauth_state'] = bin2hex(random_bytes(16));
}
$state = $_SESSION['oauth_state'];

$params = [
  'response_type' => 'code',
  'client_id'     => $client_id,
  'redirect_uri'  => $redirect_uri,
  'scope'         => $scope,
  'access_type'   => 'offline',
  'include_granted_scopes' => 'true',
  'state'         => $state,
  'prompt'        => 'consent', // hoặc bỏ nếu không muốn ép consent mỗi lần
];

$auth_url = 'https://accounts.google.com/o/oauth2/v2/auth?' . http_build_query($params);
header('Location: ' . $auth_url);
exit;
