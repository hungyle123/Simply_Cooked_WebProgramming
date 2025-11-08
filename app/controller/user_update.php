<?php
// project/app/controller/user_update.php
if (session_status() === PHP_SESSION_NONE) session_start();
require_once __DIR__ . '/../../config/db.php';
mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

/* ---- Only admin ---- */
function require_admin_or_block(mysqli $conn) {
  if (empty($_SESSION['user_id'])) {
    header('Location: /Individual_website/project/public/login.php');
    exit;
  }
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

/* ---- Helpers ---- */
function posted(string $k): bool { return array_key_exists($k, $_POST); }
function trim_or_null(?string $v): ?string {
  if ($v === null) return null;
  $t = trim($v);
  return $t === '' ? null : $t;
}

/* ---- Inputs ---- */
$user_id = (int)($_POST['user_id'] ?? 0);
if ($user_id <= 0) { http_response_code(400); exit('Missing user_id'); }

/* ---- Transaction ---- */
$conn->begin_transaction();
try {
  // 1) Load current row (để giữ nguyên field không post)
  $stmt = $conn->prepare("SELECT user_id, username, email, full_name, role FROM users WHERE user_id = ? LIMIT 1");
  $stmt->bind_param('i', $user_id);
  $stmt->execute();
  $cur = $stmt->get_result()->fetch_assoc();
  $stmt->close();
  if (!$cur) { throw new RuntimeException('User not found'); }

  // 2) Resolve values: nếu field không post -> giữ nguyên
  // username & email bắt buộc phải có giá trị cuối cùng (sau khi giữ nguyên)
  $username  = posted('username')  ? trim($_POST['username']) : (string)$cur['username'];
  $email     = posted('email')     ? trim($_POST['email'])    : (string)$cur['email'];

  // full_name cho phép null (nếu admin xóa trắng -> set NULL), nếu không post -> giữ nguyên
  $full_name = posted('full_name') ? trim_or_null($_POST['full_name']) : ($cur['full_name'] === null ? null : (string)$cur['full_name']);

  // role: nếu không post -> giữ nguyên
  $role_new_raw = posted('role') ? (string)$_POST['role'] : (string)$cur['role'];
  $role_new = in_array($role_new_raw, ['user','admin'], true) ? $role_new_raw : 'user';

  // new password: chỉ update khi có nhập (không ép buộc)
  $new_pass = (string)($_POST['new_password'] ?? '');

  // 3) Validate requireds
  if ($username === '' || $email === '') {
    throw new RuntimeException('Username and email are required');
  }

  // 4) Uniqueness (except current)
  $stmt = $conn->prepare("SELECT user_id FROM users WHERE (username = ? OR email = ?) AND user_id <> ? LIMIT 1");
  $stmt->bind_param('ssi', $username, $email, $user_id);
  $stmt->execute();
  if ($stmt->get_result()->fetch_assoc()) {
    $stmt->close();
    throw new RuntimeException('Username or email already taken');
  }
  $stmt->close();

  // 5) Build & run UPDATE
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

  // 6) Commit
  $conn->commit();
  header('Location: /Individual_website/project/public/index.php?page=admin_edit_users&ok=1');
  exit;

} catch (Throwable $e) {
  $conn->rollback();
  http_response_code(500);
  echo 'Update failed: ' . htmlspecialchars($e->getMessage());
  exit;
}
