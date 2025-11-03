<?php
// footer.php
?>
  </main> <!-- /.site-main -->

  <footer class="site-footer">
    <div class="container footer-inner">
      <div class="footer-left">
        <img src="assets/cooking_logo.png" alt="Simply Cooked" class="logo">
        <span class="brand-name">Simply Cooked</span>
      </div>

      <nav class="footer-nav">
        <a href="index.php">Home</a>
        <a href="/recipes.php">Recipes</a>
        <a href="contact.php">Contact</a>
        <a href="aboutus.php">About Us</a>
      </nav>

      <div class="footer-socials">
        <a href="https://www.tiktok.com/@hungyle123" aria-label="Tiktok"><img src="assets/tiktok.png" alt="Tiktok"></a>
        <a href="https://www.facebook.com/nguyen.tien.hung.29023/" aria-label="Facebook"><img src="assets/facebook.png" alt="Facebook"></a>
        <a href="https://www.instagram.com/_hungyle123/" aria-label="Instagram"><img src="assets/instagram.png" alt="Instagram"></a>
        <a href="https://www.youtube.com/@NguyenTienHung-pn8bx" aria-label="YouTube"><img src="assets/youtube.png" alt="Youtube"></a>
      </div>

      <div class="footer-bottom">
        <p>© <?php echo date('Y'); ?> SIMPLY COOKED.</p>
      </div>
    </div>
  </footer>

  <!-- Scripts -->
  <script src="js/main.js"></script>

<?php
// Attempt safe DB close if you use a Database class or $conn object.
// Modify this to match your db.php implementation.
if (class_exists('Database')) {
    try {
        if (method_exists('Database','close')) {
            Database::close();
        }
    } catch (Exception $e) {
        // ignore
    }
} elseif (isset($conn) && is_object($conn) && method_exists($conn,'close')) {
    $conn->close();
}
?>
</body>
</html>
