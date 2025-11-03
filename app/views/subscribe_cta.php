<?php
// subscribe_cta.php
// Place this in: app/views/partials/subscribe_cta.php
?>
<section class="subscribe-cta">
  <div class="container cta-inner">
    <div class="cta-copy">
      <small>SUBSCRIBE</small>
      <h2>JOIN THE FUN<br><span class="accent">SUBSCRIBE NOW!</span></h2>
      <p>Subscribe to our newsletter for a weekly serving of recipes, cooking tips, and exclusive insights straight to your inbox.</p>
    </div>

    <form id="subscribeForm" class="subscribe-form" method="post" action="/subscribe_process.php">
      <input type="email" name="email" id="subscribeEmail" required placeholder="Email Address">
      <button type="submit" class="btn subscribe-primary">Subscribe</button>
    </form>
  </div>
</section>
