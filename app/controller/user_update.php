<?php
// project/app/controller/user_update.php
if (session_status() === PHP_SESSION_NONE) session_start();
require_once __DIR__ . '/../../config/db.php';
mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

/* ---- Only admin ---- */
function require_admin_or_block(mysqli $conn) {
  if (empty($_SESSION['user_id'])) { header('Location: /Individual_website/project/public/login.php'); exit; }
  $role = $_SESSION['user']['role'] ?? null;
  if (!$role) {
    $uid = (int)$_SESSION['user_id'];
    $res = $conn->query("SELECT role FROM users WHERE user_id = {$uid} LIMIT 1");
    $row = $res->fetch_assoc();
    $role = $row['role'] ?? 'user';
    $_SESSION['user']['role'] = $role;
  }
  if ($role !== 'admin') { http_response_code(403); exit('Forbidden'); }
}
require_admin_or_block($conn);

/* ---- Only POST + CSRF ---- */
if ($_SERVER['REQUEST_METHOD'] !== 'POST') { http_response_code(405); exit('Method Not Allowed'); }
if (empty($_POST['csrf']) || ($_SESSION['csrf'] ?? '') !== $_POST['csrf']) { http_response_code(400); exit('Bad CSRF'); }

/* ---- Inputs ---- */
$user_id   = (int)($_POST['user_id'] ?? 0);
$username  = trim($_POST['username'] ?? '');
$email     = trim($_POST['email'] ?? '');
$full_name = trim($_POST['full_name'] ?? '');
$role_new  = in_array($_POST['role'] ?? 'user', ['user','admin'], true) ? $_POST['role'] : 'user';
$new_pass  = (string)($_POST['new_password'] ?? '');

if ($user_id <= 0 || $username === '' || $email === '') {
  http_response_code(400); exit('Missing required fields');
}

/* ---- Update in a transaction ---- */
$conn->begin_transaction();
try {
  // 1) user must exist
  $stmt = $conn->prepare("SELECT user_id FROM users WHERE user_id = ? LIMIT 1");
  $stmt->bind_param('i', $user_id);
  $stmt->execute();
  if (!$stmt->get_result()->fetch_assoc()) { $stmt->close(); throw new RuntimeException('User not found'); }
  $stmt->close();

  // 2) username/email must be unique (except current)
  $stmt = $conn->prepare("SELECT user_id FROM users WHERE (username = ? OR email = ?) AND user_id <> ? LIMIT 1");
  $stmt->bind_param('ssi', $username, $email, $user_id);
  $stmt->execute();
  if ($stmt->get_result()->fetch_assoc()) { $stmt->close(); throw new RuntimeException('Username or email already taken'); }
  $stmt->close();

  // 3) build update
  if ($new_pass !== '') {
    $hash = password_hash($new_pass, PASSWORD_DEFAULT);
    $stmt = $conn->prepare("
        UPDATE users
            SET username = ?, email = ?, full_name = ?, role = ?, password_hash = ?
        WHERE user_id = ? LIMIT 1
        ");
    $stmt->bind_param('sssssi', $username, $email, $full_name, $role_new, $hash, $user_id);
  } else {
    $stmt = $conn->prepare("
        UPDATE users
            SET username = ?, email = ?, full_name = ?, role = ?
        WHERE user_id = ? LIMIT 1
        ");
    $stmt->bind_param('ssssi', $username, $email, $full_name, $role_new, $user_id);
  }
  $stmt->execute();
  $stmt->close();

  $conn->commit();
  header('Location: /Individual_website/project/public/index.php?page=admin_edit_users&ok=1');
  exit;

} catch (Throwable $e) {
  $conn->rollback();
  http_response_code(500);
  echo 'Update failed: ' . htmlspecialchars($e->getMessage());
  exit;
}
