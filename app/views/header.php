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
  <link rel="icon" type="image/png" sizes="32x32" href="assets/cooking_logo.png">

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
        <a href=""><img src="assets/cooking_logo.png" alt="Simply Cooked" class="logo"><span class="brand-text">Simply Cooked</span></a>
      </div>

      <nav class="main-nav" aria-label="Primary Navigation">
        <ul class="nav-list">
          <li><a href="index.php" class="<?php if(!isset($active) || $active==='home') echo 'active'; ?>">Home</a></li>
          <li><a href="recipes.php" class="<?php if(isset($active) && $active==='recipes') echo 'active'; ?>">Recipes</a></li>
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
              <?php if (!empty($_SESSION['user_id'])): ?>
                <div class="header-actions">
                  <!-- ... các nút khác ... -->
                  <div class="user-menu">
                    <button class="header-auth-btn light">Hi, <?= htmlspecialchars($_SESSION['user']['username']?? 'User') ?></button>
                    <div class="user-dropdown" style="position:relative">
                      <ul class="user-dropdown-menu" style="position:absolute;right:0;top:100%;background:#fff;border:1px solid #e2dfdb;border-radius:12px;box-shadow:var(--shadow);padding:8px;list-style:none;margin:8px 0;min-width:220px;display:none">
                        <li><a class="btn" href="/Individual_website/project/public/recipe_new.php" style="display:block">Add a new recipe</a></li>
                      </ul>
                    </div>
                  </div>
                </div>
                <script>
                  // mở/đóng dropdown đơn giản
                  (function(){
                    const btn = document.querySelector('.user-menu .header-auth-btn');
                    const menu = document.querySelector('.user-dropdown-menu');
                    if(btn && menu){
                      btn.addEventListener('click',()=>menu.style.display = (menu.style.display==='block'?'none':'block'));
                      document.addEventListener('click',(e)=>{ if(!btn.contains(e.target) && !menu.contains(e.target)) menu.style.display='none';});
                    }
                  })();
                </script>
              <?php endif; ?>
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
