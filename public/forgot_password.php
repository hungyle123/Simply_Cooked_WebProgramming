<?php
// forgot_password.php
// STEP 1: user nhập email để lấy link reset

require_once __DIR__ . '/../config/db.php';

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

$message = '';
$error = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $email = trim($_POST['email'] ?? '');

    if ($email === '') {
        $error = 'Please enter your email.';
    } else {
        // 1. tìm user theo email
        $stmt = $conn->prepare("SELECT user_id FROM users WHERE email = ? LIMIT 1");
        $stmt->bind_param("s", $email);
        $stmt->execute();
        $stmt->bind_result($uid);

        if ($stmt->fetch()) {
            // Có user
            $stmt->close();

            // 2. tạo token reset ngẫu nhiên
            $token = bin2hex(random_bytes(32)); // 64 ký tự hex

            // 3. lưu token vào password_resets
            $stmt2 = $conn->prepare("INSERT INTO password_resets (user_id, token) VALUES (?, ?)");
            $stmt2->bind_param("is", $uid, $token);
            $stmt2->execute();
            $stmt2->close();

            // 4. tạo link reset.
            // Trong bài lab không cần gửi email thật, chỉ cần show link để giảng viên nhìn thấy là đủ.
            $reset_link = "reset_password.php?token=" . urlencode($token);

            $message = "A reset link has been generated. Please use this link to set a new password: " . $reset_link;
        } else {
            // Không tìm thấy email
            $error = 'No account found with that email.';
            $stmt->close();
        }
    }
}

$page_title = "Forgot Password - Cooks Delight";
$active = '';
include __DIR__ . '/../app/views/header.php';
?>

<main class="site-main">
  <section class="contact-section" style="max-width:500px;">
    <div class="contact-header">
      <h1>Reset your password</h1>
      <p>Enter your email and we’ll help you get back in.</p>
    </div>

    <?php if ($error): ?>
      <div class="alert error"><?= htmlspecialchars($error) ?></div>
    <?php endif; ?>

    <?php if ($message): ?>
      <div class="alert success"><?= htmlspecialchars($message) ?></div>
    <?php endif; ?>

    <form method="POST" class="contact-form" style="grid-template-columns:1fr;">
      <div class="form-group">
        <label>Email *</label>
        <input type="email" name="email" required value="<?= htmlspecialchars($_POST['email'] ?? '') ?>">
      </div>

      <div class="form-actions" style="text-align:right;">
        <button class="btn-primary" type="submit">Send Reset Link</button>
      </div>
    </form>
  </section>
</main>

<?php include __DIR__ . '/../app/views/footer.php'; ?>
