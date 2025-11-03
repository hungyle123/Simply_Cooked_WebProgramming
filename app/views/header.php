<?php
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}
?>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title><?php echo isset($page_title) ? htmlspecialchars($page_title) : 'Simply Cooked'; ?></title>

  <!-- Google fonts -->
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@700;800&family=Inter:wght@300;400;600&display=swap" rel="stylesheet">

  <!-- Main styles -->
  <link rel="stylesheet" href="css\style.css">
  <link rel="stylesheet" href="css\responsive.css">

  <meta name="theme-color" content="#f7efe8">
</head>
<body>
  <header class="site-header">
    <div class="container header-inner">
      <div class="brand">
        <a href="/"><img src="assets/cooking_logo.png" alt="Simply Cooked" class="logo"><span class="brand-text">Simply Cooked</span></a>
      </div>

      <nav class="main-nav" aria-label="Primary Navigation">
        <ul class="nav-list">
          <li><a href="index.php" class="<?php if(!isset($active) || $active==='home') echo 'active'; ?>">Home</a></li>
          <li><a href="/recipes.php" class="<?php if(isset($active) && $active==='recipes') echo 'active'; ?>">Recipes</a></li>
          <li><a href="contact.php" class="<?php if(isset($active) && $active==='contact') echo 'active'; ?>">Contact</a></li>
          <li><a href="aboutus.php" class="<?php if(isset($active) && $active==='about') echo 'active'; ?>">About Us</a></li>
        </ul>
      </nav>

      <div class="header-actions">
          <!-- Search button -->
          <button class="icon-btn" id="searchToggle" aria-label="Search">
              <img src="assets/Search.png" alt="Search">
          </button>

          <?php if (!empty($_SESSION['user'])): ?>
              <span style="font-size:14px;font-weight:600;color:#111; padding:10px 0;">
                  Hi, <?= htmlspecialchars($_SESSION['user']['username']) ?>
              </span>
              <a class="header-auth-btn light" href="logout.php">Logout</a>
          <?php else: ?>
              <a class="header-auth-btn light" href="login.php">Log in</a>
              <a class="header-auth-btn dark" href="register.php">Sign up</a>
          <?php endif; ?>
      </div>

    </div>
  </header>

  <?php include_once __DIR__ . '/mobile_menu.php'; // mobile menu partial (overlay) ?>

  <?php include_once __DIR__ . '/search_modal.php'; // search modal partial ?>

  <main id="site-main" class="site-main">
