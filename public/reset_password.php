<?php
require_once __DIR__ . '/config/db.php';
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

$token = $_GET['token'] ?? '';
$error = '';
$success = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $token   = trim($_POST['token'] ?? '');
    $pass    = trim($_POST['password'] ?? '');
    $pass2   = trim($_POST['password_confirm'] ?? '');

    if ($token === '' || $pass === '' || $pass2 === '') {
        $error = 'Please fill in all fields.';
    } elseif ($pass !== $pass2) {
        $error = 'Password confirmation does not match.';
    } else {
        // tìm token
        $stmt = $conn->prepare("
            SELECT pr.user_id
            FROM password_resets pr
            WHERE pr.token = ?
            LIMIT 1
        ");
        $stmt->bind_param("s", $token);
        $stmt->execute();
        $stmt->bind_result($uid);
        if ($stmt->fetch()) {
            $stmt->close();

            // cập nhật mật khẩu mới
            $hash = password_hash($pass, PASSWORD_DEFAULT);
            $stmt2 = $conn->prepare("UPDATE users SET password_hash = ? WHERE user_id = ?");
            $stmt2->bind_param("si", $hash, $uid);
            $stmt2->execute();
            $stmt2->close();

            // xóa token đã dùng
            $stmt3 = $conn->prepare("DELETE FROM password_resets WHERE token = ?");
            $stmt3->bind_param("s", $token);
            $stmt3->execute();
            $stmt3->close();

            $success = "Your password has been updated. You can now log in.";
        } else {
            $error = 'Invalid or expired reset token.';
            $stmt->close();
        }
    }
}

$page_title = "Choose New Password - Cooks Delight";
$active = '';
include __DIR__ . '/app/views/header.php';
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
        <input type="password" name="password" required>
      </div>

      <div class="form-group">
        <label>Confirm New Password *</label>
        <input type="password" name="password_confirm" required>
      </div>

      <div class="form-actions" style="text-align:right;">
        <button class="btn-primary" type="submit">Update Password</button>
      </div>
    </form>
  </section>
</main>

<?php include __DIR__ . '/app/views/footer.php'; ?>
