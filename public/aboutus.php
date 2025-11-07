<?php
require_once __DIR__ . '/../config/db.php';

$page_title = "About Us - Simply Cooked";
$page_desc  = "Meet Nguyen Tien Hung, the creator behind Simply Cooked — where culinary inspiration meets global flavor.";

$active = 'about';
include __DIR__ . '/../app/views/header.php';
?>

<main class="site-main">

  <!-- ===== WELCOME SECTION ===== -->
  <section class="welcome-section">
    <div class="welcome-inner container">
      <div class="welcome-left">
        <h1>WELCOME TO<br>MY CULINARY HAVEN!</h1>
      </div>
      <div class="welcome-right">
        <p>
          Bonjour and welcome to the heart of my kitchen! I’m <strong>Nguyen Tien Hung</strong>,
          the culinary enthusiast behind this haven of flavors, Simply Cooked.
          Join me on a gastronomic journey where each dish carries a story,
          and every recipe is a crafted symphony of taste.
        </p>
        <a href="recipes.php" class="btn-primary">Explore Recipes</a>
      </div>
    </div>
  </section>

  <!-- ===== ABOUT SECTION ===== -->
  <section class="aboutus-wrapper">
    <div class="aboutus-inner">
      <!-- LEFT SIDE -->
      <div class="aboutus-left">
        <div class="aboutus-photo-box">
          <img src="assets/webowner.png" alt="Nguyen Tien Hung cooking" class="aboutus-photo">
        </div>

        <div class="aboutus-follow-strip">
          <span>FOLLOW ME</span>
          <div class="aboutus-socials">
            <a href="https://www.facebook.com/nguyen.tien.hung.29023/" target="_blank">
              <img src="assets/facebook.png" alt="Facebook">
            </a>
            <a href="https://www.instagram.com/_hungyle123/" target="_blank">
              <img src="assets/instagram.png" alt="Instagram">
            </a>
            <a href="https://www.youtube.com/@NguyenTienHung-pn8bx" target="_blank">
              <img src="assets/youtube.png" alt="YouTube">
            </a>
          </div>
        </div>
      </div>

      <!-- RIGHT SIDE -->
      <div class="aboutus-right">
        <h2 class="aboutus-headline">
          FROM ITALIAN ROOTS TO<br>GLOBAL PALATES
        </h2>

        <p>
          Born and raised in the vibrant culinary landscape of Italy, my journey with food began in the heart of my family's kitchen.
          Surrounded by the aroma of fresh herbs, the sizzle of pans, and the laughter of loved ones, I developed a deep appreciation
          for the art of cooking. My culinary education took me from the historic streets of Rome to the bustling markets of Florence,
          where I honed my skills and cultivated a love for the simplicity and authenticity of Italian cuisine.
        </p>

        <p>
          Driven by a relentless curiosity, I embarked on a global culinary exploration, seeking inspiration from the rich tapestry of
          flavors found in kitchens around the world. From the spicy markets of Marrakech to the sushi stalls of Tokyo, each experience
          added a unique brushstroke to my culinary canvas.
        </p>

        <p>
          Whether you’re a seasoned home cook or just starting your culinary adventure, I’m delighted to have you here. Let’s stir,
          simmer, and savor the beauty of creating something wonderful together.
        </p>

        <p class="aboutus-signoff-label">Warmest regards,</p>
        <p class="aboutus-signature">Nguyen Tien Hung</p>
      </div>
    </div>

    <!-- GALLERY GRID -->
    <div class="aboutus-gallery">
      <div class="aboutus-gallery-item"><img src="assets/together.png" alt="Cooking together in the kitchen"></div>
      <div class="aboutus-gallery-item"><img src="assets/prepare.png" alt="Prepping ingredients"></div>
      <div class="aboutus-gallery-item"><img src="images/recipe_mushroom_risotto.jpg" alt="Plating risotto"></div>
      <div class="aboutus-gallery-item"><img src="images/recipe_honey_soy_salmon.jpg" alt="Salmon with garnish"></div>
      <div class="aboutus-gallery-item"><img src="images/recipe_buddha_bowl.jpg" alt="Colorful bowl"></div>
      <div class="aboutus-gallery-item"><img src="images/recipe_quinoa_salad.jpg" alt="Chopped vegetables on board"></div>
      <div class="aboutus-gallery-item"><img src="images/recipe_cajun_chicken_pasta.jpg" alt="Finishing touches on pasta"></div>
      <div class="aboutus-gallery-item"><img src="images/recipe_tomato_basil_pasta.jpg" alt="Food content filmed on phone"></div>
    </div>
  </section>
</main>

<?php include __DIR__ . '/../app/views/footer.php'; ?>
