<?php
// reset_password.php
// Bước 2: người dùng truy cập link có ?token=..., đặt mật khẩu mới
// Sửa: Không truy vấn bảng password_resets. Dùng token lưu tạm trong $_SESSION['password_reset']
//      (đã được tạo ở forgot_password.php) với hạn 60 phút.

require_once __DIR__ . '/../config/db.php';
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

$token = $_GET['token'] ?? '';
$error = '';
$success = '';

// Helper: kiểm tra token trong session và còn hạn
function get_reset_entry_from_session(string $token): ?array {
    if (!isset($_SESSION['password_reset'][$token])) return null;
    $entry = $_SESSION['password_reset'][$token];
    // Validate cấu trúc và hạn dùng
    if (!isset($entry['user_id'], $entry['expires'])) return null;
    if (time() > (int)$entry['expires']) {
        // Hết hạn: xóa luôn
        unset($_SESSION['password_reset'][$token]);
        return null;
    }
    return $entry;
}

// Nếu có token trên URL, kiểm tra sơ bộ để báo lỗi sớm
if ($token !== '') {
    if (!get_reset_entry_from_session($token)) {
        $error = 'Invalid or expired reset token.';
    }
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $token = trim($_POST['token'] ?? '');
    $pass  = trim($_POST['password'] ?? '');
    $pass2 = trim($_POST['password_confirm'] ?? '');

    if ($token === '' || $pass === '' || $pass2 === '') {
        $error = 'Please fill in all fields.';
    } elseif ($pass !== $pass2) {
        $error = 'Password confirmation does not match.';
    } elseif (strlen($pass) < 8) {
        $error = 'Password must be at least 8 characters.';
    } else {
        // Lấy token từ session
        $entry = get_reset_entry_from_session($token);
        if (!$entry) {
            $error = 'Invalid or expired reset token.';
        } else {
            $uid = (int)$entry['user_id'];

            // Cập nhật mật khẩu mới
            $hash = password_hash($pass, PASSWORD_DEFAULT);
            $stmt = $conn->prepare("UPDATE users SET password_hash = ? WHERE user_id = ?");
            $stmt->bind_param("si", $hash, $uid);
            $stmt->execute();
            $stmt->close();

            // Xóa token đã dùng
            unset($_SESSION['password_reset'][$token]);

            // (Tùy chọn) đổi session id sau khi cập nhật những dữ liệu nhạy cảm
            session_regenerate_id(true);

            $success = "Your password has been updated. You can now log in.";
            $error = '';
        }
    }
}

$page_title = "Choose New Password - Cooks Delight";
$active = '';
include __DIR__ . '/../app/views/header.php';
?>

<main class="site-main">
  <section class="contact-section" style="max-width:500px;">
    <div class="contact-header">
      <h1>Choose a new password</h1>
      <p>Make it strong. Make it yours.</p>
    </div>

    <?php if ($error): ?>
      <div class="alert error"><?= htmlspecialchars($error) ?></div>
    <?php endif; ?>

    <?php if ($success): ?>
      <div class="alert success"><?= htmlspecialchars($success) ?></div>
    <?php endif; ?>

    <form method="POST" class="contact-form" style="grid-template-columns:1fr;">
      <input type="hidden" name="token" value="<?= htmlspecialchars($token) ?>">

      <div class="form-group">
        <label>New Password *</label>
        <input type="password" name="password" required minlength="8">
      </div>

      <div class="form-group">
        <label>Confirm New Password *</label>
        <input type="password" name="password_confirm" required minlength="8">
      </div>

      <div class="form-actions" style="text-align:right;">
        <button class="btn-primary" type="submit">Update Password</button>
      </div>
    </form>
  </section>
</main>

<?php include __DIR__ . '/../app/views/footer.php'; ?>
