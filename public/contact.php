<?php
  $active = 'contact';
  include '../app/views/header.php';
?>

<main class="site-main">
  <section class="contact-section container">
    <div class="contact-header">
      <h1>Contact Us</h1>
      <p>Have questions or feedback? Send us a message below.</p>
    </div>

    <?php if (isset($_GET['success'])): ?>
      <p class="alert success">Your message has been sent!</p>
    <?php elseif (isset($_GET['error'])): ?>
      <p class="alert error">Please fill in all required fields.</p>
    <?php endif; ?>

    <!-- Form -->
    <form action="../app/controller/contact_controller.php" method="POST" class="contact-form">
      <div class="form-group">
        <label for="name">Name</label>
        <input type="text" id="name" name="name" required>
      </div>

      <div class="form-group">
        <label for="email">Email</label>
        <input type="email" id="email" name="email" required>
      </div>

      <div class="form-group">
        <label for="subject">Subject</label>
        <input type="text" id="subject" name="subject">
      </div>

      <div class="form-group full-width">
        <label for="message">Message</label>
        <textarea id="message" name="message" rows="4" required></textarea>
      </div>

      <div class="form-actions">
        <button type="submit" class="btn-primary">Send</button>
      </div>
    </form>

    <!-- Stores -->
    <section class="store-section">
      <h2>Our Address</h2>
      <p>You can also reach us here:</p>

      <div class="store-list">
        <div class="store-item">
          <strong>Main Kitchen HQ</strong>
          <span>123 Flavor Street, District 1, HCMC</span>
          <a href="https://maps.app.goo.gl/qb93n6kxsuWc3991A" target="_blank">View on Google Maps →</a>
          <span>Phone: (0123) 456 789</span>
        </div>
      </div>
    </section>
</main>

<?php include '../app/views/footer.php'; ?>
