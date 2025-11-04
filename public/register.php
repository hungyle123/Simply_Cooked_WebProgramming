<?php
require_once __DIR__ . '/../config/db.php';
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

// Nếu đã đăng nhập thì đá về home
if (!empty($_SESSION['user'])) {
    header('Location: index.php');
    exit;
}

$error = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = trim($_POST['username'] ?? '');
    $email    = trim($_POST['email'] ?? '');
    $pass     = trim($_POST['password'] ?? '');
    $pass2    = trim($_POST['password_confirm'] ?? '');

    if ($username === '' || $email === '' || $pass === '' || $pass2 === '') {
        $error = 'Please fill in all fields.';
    } elseif (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        $error = 'Invalid email format.';
    } elseif ($pass !== $pass2) {
        $error = 'Password confirmation does not match.';
    } else {
        // check username/email trùng chưa
        $stmt = $conn->prepare("SELECT user_id FROM users WHERE username = ? OR email = ? LIMIT 1");
        $stmt->bind_param("ss", $username, $email);
        $stmt->execute();
        $stmt->store_result();

        if ($stmt->num_rows > 0) {
            $error = 'Username or email already exists.';
            $stmt->close();
        } else {
            $stmt->close();

            $hash = password_hash($pass, PASSWORD_DEFAULT);

            $stmt2 = $conn->prepare("
                INSERT INTO users (username, email, password_hash, full_name, bio, profile_image_url)
                VALUES (?, ?, ?, '', '', '')
            ");
            $stmt2->bind_param("sss", $username, $email, $hash);

            if ($stmt2->execute()) {
                $new_id = $stmt2->insert_id;
                $_SESSION['user'] = [
                    'user_id'  => $new_id,
                    'username' => $username,
                    'email'    => $email,
                ];
                $stmt2->close();

                header('Location: index.php');
                exit;
            } else {
                $error = 'Registration failed. Please try again.';
                $stmt2->close();
            }
        }
    }
}

$page_title = "Sign Up - Cooks Delight";
$active = '';
include __DIR__ . '/../app/views/header.php';
?>

<main class="site-main">
  <section class="login-wrapper">
    <form method="POST" class="login-card">

      <!-- HEADER TRONG CARD -->
      <div class="login-head">
        <h1>CREATE ACCOUNT</h1>
        <p>Join our kitchen community — save recipes, leave comments, and more.</p>

        <?php if ($error): ?>
          <div class="alert error" style="margin-top:12px;">
            <?= htmlspecialchars($error) ?>
          </div>
        <?php endif; ?>
      </div>

      <!-- HÀNG 2 CỘT TRÊN: USERNAME + EMAIL -->
      <div class="login-row-2col">
        <div class="form-group">
          <label>Username *</label>
          <input
            type="text"
            name="username"
            required
            value="<?= htmlspecialchars($_POST['username'] ?? '') ?>">
        </div>

        <div class="form-group">
          <label>Email *</label>
          <input
            type="email"
            name="email"
            required
            value="<?= htmlspecialchars($_POST['email'] ?? '') ?>">
        </div>
      </div>

      <!-- HÀNG 2 CỘT DƯỚI: PASSWORD + CONFIRM -->
      <div class="login-row-2col">
        <div class="form-group">
          <label>Password *</label>
          <input type="password" name="password" required>
        </div>

        <div class="form-group">
          <label>Confirm Password *</label>
          <input type="password" name="password_confirm" required>
        </div>
      </div>

      <!-- NÚT SIGN UP -->
      <div class="form-actions">
        <button class="btn-primary" type="submit">SIGN UP</button>
      </div>

      <!-- BELOW: LOGIN LINK + SOCIAL -->
      <div class="auth-block">

        <div class="auth-row-split" style="flex-wrap:wrap; row-gap:16px;">
          <div class="auth-inline-text" style="width:100%; text-align:center; color:var(--muted,#6f6a63); font-weight:500;">
            <span>Already have an account?
              <a href="login.php" class="auth-link-accent">Log in</a>
            </span>
          </div>
        </div>

        <div class="auth-divider">
          <span>or continue with</span>
        </div>

        <!-- SOCIAL LOGIN (dùng popup) -->
        <a href="auth/google_start.php" class="social-btn social-google">
          <img src="assets/google.svg" alt="Google icon">
          Continue with Google
        </a>
      </div><!-- /auth-block -->

    </form>
  </section>
</main>

<!-- SCRIPT POPUP OAUTH -->
<script>
function openOAuthPopup(url){
  const w = 480;
  const h = 600;
  const left = (window.screen.width  - w)/2;
  const top  = (window.screen.height - h)/2;
  window.open(
    url,
    "oauthPopup",
    `width=${w},height=${h},left=${left},top=${top},resizable=yes,scrollbars=yes`
  );
}

document.getElementById('google-login-btn').addEventListener('click', function(){
  openOAuthPopup(this.getAttribute('data-oauth-url'));
});

</script>

<?php include __DIR__ . '/../app/views/footer.php'; ?>
