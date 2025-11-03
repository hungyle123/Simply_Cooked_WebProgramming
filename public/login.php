<?php
require_once __DIR__ . '/../config/db.php';
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

if (!empty($_SESSION['user'])) {
    // nếu đã đăng nhập rồi thì đưa về home
    header('Location: /index.php');
    exit;
}

$error = '';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $email = trim($_POST['email'] ?? '');
    $pass  = trim($_POST['password'] ?? '');

    if ($email === '' || $pass === '') {
        $error = 'Please enter email and password.';
    } else {
        $stmt = $conn->prepare("SELECT user_id, username, email, password_hash FROM users WHERE email = ? LIMIT 1");
        $stmt->bind_param("s", $email);
        $stmt->execute();
        $stmt->bind_result($uid, $uname, $umail, $hash);
        if ($stmt->fetch()) {
            if (password_verify($pass, $hash)) {
                $_SESSION['user'] = [
                    'user_id'  => $uid,
                    'username' => $uname,
                    'email'    => $umail,
                ];
                $stmt->close();
                header('Location: /index.php');
                exit;
            } else {
                $error = 'Incorrect password.';
            }
        } else {
            $error = 'Account not found.';
        }
        $stmt->close();
    }
}

$page_title = "Log In - Cooks Delight";
$active = '';
include __DIR__ . '/../app/views/header.php';
?>

<main class="site-main">
  <section class="contact-section" style="max-width: 100%; margin: 0 auto;">
    <div class="contact-header">
      <h1>Welcome back</h1>
      <p>Log in to continue exploring delicious ideas.</p>
    </div>

    <?php if ($error): ?>
      <div class="alert error"><?= htmlspecialchars($error) ?></div>
    <?php endif; ?>

    <form method="POST" class="contact-form login-form" style="grid-template-columns:1fr;">
        <div class="form-group">
          <label>Email *</label>
          <input type="email" name="email" required value="<?= htmlspecialchars($_POST['email'] ?? '') ?>">
        </div>

        <div class="form-group">
          <label>Password *</label>
          <input type="password" name="password" required>
        </div>

        <div class="form-actions" style="text-align:right;">
          <button class="btn-primary" type="submit">Log In</button>
        </div>

        <!-- TẤT CẢ phần dưới gom vào 1 khối duy nhất -->
        <div class="auth-block">

          <!-- hàng forgot / signup -->
          <div class="auth-row-split">
            <div class="auth-inline-text">
              <span>Forgot your password?
                <a href="forgot_password.php" class="auth-link-accent">Reset here</a>
              </span>
            </div>

            <div class="auth-inline-text">
              <span>Don't have an account?
                <a href="register.php" class="auth-link-accent">Sign up</a>
              </span>
            </div>
          </div>

          <!-- divider -->
          <div class="auth-divider">
            <span>or continue with</span>
          </div>

          <!-- social buttons -->
          <div class="auth-social-row">
            <a class="social-btn social-google" href="oauth_google.php">
              Google
            </a>

            <a class="social-btn social-facebook" href="oauth_facebook.php">
              Facebook
            </a>
          </div>

        </div><!-- /auth-block -->
      </form>
  </section>
</main>

<?php include __DIR__ . '/../app/views/footer.php'; ?>
