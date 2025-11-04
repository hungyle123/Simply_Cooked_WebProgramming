<?php
// mobile_menu.php
?>
<div id="mobileMenu" class="mobile-drawer" aria-hidden="true">
  <div class="mobile-drawer-inner">
    <header class="mobile-drawer-header">
      <div class="mobile-brand">
        <img src="assets/cooking_logo.png" alt="Simply Cooked" class="logo">
        <span class="brand-text">Simply Cooked</span>
      </div>
      <button id="mobileMenuClose" class="icon-btn close-btn" aria-label="Close menu">✕</button>
    </header>

    <nav class="mobile-nav">
      <ul>
        <li><a href="index.php">Home</a></li>
        <li><a href="recipes.php">Recipes</a></li>
        <li><a href="contact.php">Contact</a></li>
        <li><a href="aboutus.php">About Us</a></li>
        <li><a href="login.php">Login</a></li>
      </ul>

      <div class="mobile-actions">
        <button id="mobileSearchOpen" class="icon-btn" aria-label="Search">
          <img src="assets/search_mobile.png" alt="Search" class="icon">
        </button>
        <a href="/subscribe.php" class="subscribe-btn-mobile">Subscribe</a>
      </div>

      <div class="mobile-socials">
        <a href="https://www.tiktok.com/@hungyle123" aria-label="Tiktok"><img src="assets/tiktok.png" alt="Tiktok"></a>
        <a href="https://www.facebook.com/nguyen.tien.hung.29023/" aria-label="Facebook"><img src="assets/facebook.png" alt="Facebook"></a>
        <a href="https://www.instagram.com/_hungyle123/" aria-label="Instagram"><img src="assets/instagram.png" alt="Instagram"></a>
        <a href="https://www.youtube.com/@NguyenTienHung-pn8bx" aria-label="YouTube"><img src="assets/youtube.png" alt="Youtube"></a>
      </div>
    </nav>
  </div>
</div>
