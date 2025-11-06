<?php
require_once __DIR__ . '/../config/db.php';
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

if (!empty($_SESSION['user'])) {
    header('Location: index.php');
    exit;
}

$error = '';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $email = trim($_POST['email'] ?? '');
    $pass  = trim($_POST['password'] ?? '');

    if ($email === '' || $pass === '') {
        $error = 'Please enter email and password.';
    } else {
        $stmt = $conn->prepare("SELECT user_id, username, email, password_hash, role FROM users WHERE email = ? LIMIT 1");
        $stmt->bind_param("s", $email);
        $stmt->execute();
        $stmt->bind_result($uid, $uname, $umail, $hash, $role);
        if ($stmt->fetch()) {
            if (password_verify($pass, $hash)) {
                $_SESSION['user_id'] = (int)$uid; // QUAN TRỌNG: top-level
                $_SESSION['user'] = [
                    'user_id'  => (int)$uid,
                    'username' => $uname,
                    'email'    => $umail,
                    'role'     => $role ?: 'user',
                ];
                $stmt->close();
                header('Location: index.php');
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
  <section class="login-wrapper">
    <form method="POST" class="login-card">

      <!-- HEADER TRONG CARD -->
      <div class="login-head">
        <h1>WELCOME BACK</h1>
        <p>Log in to continue exploring delicious ideas.</p>

        <?php if ($error): ?>
          <div class="alert error" style="margin-top:12px;">
            <?= htmlspecialchars($error) ?>
          </div>
        <?php endif; ?>
      </div>

      <!-- HÀNG 2 CỘT: EMAIL + PASSWORD -->
      <div class="login-row-2col">
        <div class="form-group">
          <label>Email *</label>
          <input type="email" name="email" required value="<?= htmlspecialchars($_POST['email'] ?? '') ?>">
        </div>

        <div class="form-group">
          <label>Password *</label>
          <input type="password" name="password" required>
        </div>
      </div>

      <!-- NÚT LOGIN -->
      <div class="form-actions">
        <button class="btn-primary" type="submit">LOG IN</button>
      </div>

      <!-- PHẦN FORGOT / SIGNUP / SOCIAL -->
      <div class="auth-block">
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

        <div class="auth-divider">
          <span>or continue with</span>
        </div>

        <a href="auth/google_start.php" class="social-btn social-google">
          <img src="assets/google.svg" alt="Google icon">
          Continue with Google
        </a>
      </div><!-- /auth-block -->

    </form>
  </section>
</main>

<?php include __DIR__ . '/../app/views/footer.php'; ?>
