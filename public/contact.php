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
          <strong>Headquarters</strong>
          <span>268 Ly Thuong Kiet Street, Ward 14, District 10, Ho Chi Minh City</span>
          <span>Phone: (0123) 456 789</span>
          <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3919.511579457489!2d106.65790179999999!3d10.772075!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x31752ec3c161a3fb%3A0xef77cd47a1cc691e!2zVHLGsOG7nW5nIMSQ4bqhaSBo4buNYyBCw6FjaCBraG9hIC0gxJDhuqFpIGjhu41jIFF14buRYyBnaWEgVFAuSENN!5e0!3m2!1svi!2s!4v1762272695118!5m2!1svi!2s" width="600" height="450" style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
        </div>
      </div>
    </section>
</main>

<?php include '../app/views/footer.php'; ?>
