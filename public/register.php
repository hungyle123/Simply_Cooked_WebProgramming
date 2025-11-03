<?php
require_once __DIR__ . '/../config/db.php';
if (session_status() === PHP_SESSION_NONE) {
    session_start();
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
        // check unique username / email
        $stmt = $conn->prepare("SELECT user_id FROM users WHERE username = ? OR email = ?");
        $stmt->bind_param("ss", $username, $email);
        $stmt->execute();
        $stmt->store_result();
        if ($stmt->num_rows > 0) {
            $error = 'Username or email already exists.';
        } else {
            $hash = password_hash($pass, PASSWORD_DEFAULT);

            $stmt2 = $conn->prepare("INSERT INTO users (username, email, password_hash, full_name, bio, profile_image_url) VALUES (?, ?, ?, '', '', '')");
            $stmt2->bind_param("sss", $username, $email, $hash);
            if ($stmt2->execute()) {
                $new_id = $stmt2->insert_id;
                $_SESSION['user'] = [
                    'user_id'  => $new_id,
                    'username' => $username,
                    'email'    => $email,
                ];
                header('Location: /index.php');
                exit;
            } else {
                $error = 'Registration failed. Please try again.';
            }
            $stmt2->close();
        }
        $stmt->close();
    }
}

$page_title = "Sign Up - Cooks Delight";
$active = ''; // no nav active
include __DIR__ . '/../app/views/header.php';
?>

<main class="site-main">
  <section class="contact-section" style="max-width:500px;">
    <div class="contact-header">
      <h1>Create Account</h1>
      <p>Join our kitchen community — save recipes, leave comments, and more.</p>
    </div>

    <?php if ($error): ?>
      <div class="alert error"><?= htmlspecialchars($error) ?></div>
    <?php endif; ?>

    <form method="POST" class="contact-form" style="grid-template-columns:1fr;">
      <div class="form-group">
        <label>Username *</label>
        <input type="text" name="username" required value="<?= htmlspecialchars($_POST['username'] ?? '') ?>">
      </div>

      <div class="form-group">
        <label>Email *</label>
        <input type="email" name="email" required value="<?= htmlspecialchars($_POST['email'] ?? '') ?>">
      </div>

      <div class="form-group">
        <label>Password *</label>
        <input type="password" name="password" required>
      </div>

      <div class="form-group">
        <label>Confirm Password *</label>
        <input type="password" name="password_confirm" required>
      </div>

      <div class="form-actions" style="text-align:right;">
        <button class="btn-primary" type="submit">Sign Up</button>
      </div>

      <div style="font-size:13px;color:var(--muted);text-align:center;">
        Already have an account?
        <a href="login.php" style="color:var(--accent);font-weight:600;text-decoration:none;">Log in</a>
      </div>

      <div style="font-size:13px;color:#111;text-align:center;font-weight:600;margin-top:16px;">
        or continue with
      </div>

      <div style="display:flex;gap:12px;justify-content:center;flex-wrap:wrap;">
        <a class="btn small" style="background:#fff;border:1px solid #ccc;text-decoration:none;"
           href="/oauth_google.php">Google</a>
        <a class="btn small" style="background:#1877f2;color:#fff;text-decoration:none;border:0;"
           href="/oauth_facebook.php">Facebook</a>
      </div>
    </form>
  </section>
</main>

<?php include __DIR__ . '/../app/views/footer.php'; ?>
