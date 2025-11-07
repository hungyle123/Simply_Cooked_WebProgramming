<?php
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}
?>
<!doctype html>
<html lang="en">
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />

  <?php
    // ===== SEO: dynamic title & description (with fallbacks) =====
    $site_name     = 'Cooks Delight';
    $default_title = 'Cooks Delight — Discover and cook delightful recipes';
    $default_desc  = 'Explore curated recipes with clear instructions, time estimates, and tips.';

    // Ưu tiên: $meta_title -> $page_title -> $default_title
    $__title = isset($meta_title) && $meta_title !== ''
        ? $meta_title
        : (isset($page_title) && $page_title !== '' ? $page_title : $default_title);

    // Ưu tiên: $meta_description -> $page_desc -> $default_desc
    $__desc = isset($meta_description) && $meta_description !== ''
        ? $meta_description
        : (isset($page_desc) && $page_desc !== '' ? $page_desc : $default_desc);
  ?>

  <title><?= htmlspecialchars($__title) ?></title>
  <meta name="description" content="<?= htmlspecialchars($__desc) ?>">

  <?php if (!empty($canonical_url)): ?>
    <link rel="canonical" href="<?= htmlspecialchars($canonical_url) ?>">
  <?php endif; ?>

  <link rel="icon" type="image/png" sizes="32x32" href="assets/cooking_logo.png">

  <!-- Google fonts -->
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@700;800&family=Inter:wght@300;400;600&display=swap" rel="stylesheet">

  <!-- Main styles -->
  <link rel="stylesheet" href="css/style.css">
  <link rel="stylesheet" href="css/responsive.css">

  <meta name="theme-color" content="#f7efe8">
</head>

<body>
  <header class="site-header">
    <div class="container header-inner">
      <div class="brand">
        <a href="index.php">
          <img src="assets/cooking_logo.png" alt="Simply Cooked" class="logo">
          <span class="brand-text">Simply Cooked</span>
        </a>
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
        <button id="mobileMenuToggle" class="icon-btn mobile-only" aria-label="Open menu">
          <img src="assets/icons8-menu-25.png" alt="" class="icon">
        </button>
        <!-- Search button -->
        <button class="icon-btn" id="searchToggle" aria-label="Search">
          <img src="assets/Search.png" alt="Search">
        </button>

        <!-- ========== Auth / User menu (fixed) ========== -->
        <?php if (!empty($_SESSION['user_id'])): ?>
          <?php
          // Lấy role + username (ưu tiên từ session, thiếu thì hỏi DB và cache lại)
          $role = $_SESSION['user']['role'] ?? null;
          if (!$role) {
            require_once __DIR__ . '/../../config/db.php'; // từ /app/views/ -> /config/db.php
            $uid = (int)$_SESSION['user_id'];
            if ($res = $conn->query("SELECT role, username FROM users WHERE user_id = {$uid} LIMIT 1")) {
              $row  = $res->fetch_assoc();
              $role = $row['role'] ?? 'user';
              $_SESSION['user']['role'] = $role;
              if (empty($_SESSION['user']['username']) && !empty($row['username'])) {
                $_SESSION['user']['username'] = $row['username'];
              }
            } else {
              $role = 'user';
            }
          }
          $is_admin = ($role === 'admin');
          ?>
          <div class="user-menu">
            <button class="header-auth-btn light">Hi, <?= htmlspecialchars($_SESSION['user']['username'] ?? 'User') ?></button>
            <div class="user-dropdown" style="position:relative">
              <ul class="user-dropdown-menu" style="position:absolute;right:0;top:100%;background:#fff;border:1px solid #e2dfdb;border-radius:12px;box-shadow:var(--shadow);padding:8px;list-style:none;margin:8px 0;min-width:220px;display:none">
                <li><a class="btn" href="/Individual_website/project/public/recipe_new.php" style="display:block">Add a new recipe</a></li>

                <?php if ($is_admin): ?>
                  <li><hr style="border:none;border-top:1px solid #eee;margin:6px 0;"></li>
                  <li><a class="btn" href="/Individual_website/project/public/index.php?page=admin_edit_recipes" style="display:block">Edit recipes</a></li>
                  <li><a class="btn" href="/Individual_website/project/public/index.php?page=admin_edit_users" style="display:block">Edit users</a></li>
                <?php endif; ?>
              </ul>
            </div>
          </div>

          <script>
            (function(){
              const btn = document.querySelector('.user-menu .header-auth-btn');
              const menu = document.querySelector('.user-dropdown-menu');
              if(btn && menu){
                btn.addEventListener('click', (e)=>{
                  e.stopPropagation();
                  menu.style.display = (menu.style.display==='block' ? 'none' : 'block');
                });
                document.addEventListener('click', (e)=>{
                  if(!btn.contains(e.target) && !menu.contains(e.target)) menu.style.display='none';
                });
              }
            })();
          </script>

          <a class="header-auth-btn light" href="logout.php">Logout</a>
        <?php else: ?>
          <a class="header-auth-btn light" href="login.php">Log in</a>
          <a class="header-auth-btn dark" href="register.php">Sign up</a>
        <?php endif; ?>
        <!-- ========== /Auth / User menu ========== -->

      </div>
    </div>
  </header>

  <?php include_once __DIR__ . '/mobile_menu.php'; // mobile menu partial (overlay) ?>
  <?php include_once __DIR__ . '/search_modal.php'; // search modal partial ?>

  <main id="site-main" class="site-main">
