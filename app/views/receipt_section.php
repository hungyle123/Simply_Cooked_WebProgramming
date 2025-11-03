<?php
// app/views/receipt_section.php
// Hiển thị danh sách công thức từ DB: dùng $recipes_home (một mảng các recipe)
?>

<section class="recipes-section">
  <div class="container">

    <!-- Heading -->
    <header class="recipes-header">
      <button class="recipes-badge" disabled>Recipes</button>

      <h2 class="recipes-title">
        EMBARK ON A <br> JOURNEY
      </h2>

      <p class="recipes-desc">
        With our diverse collection of recipes we have something to satisfy every palate.
      </p>

      <!-- Filter Pills (chỉ giao diện, chưa lọc backend) -->
      <div class="recipe-filters">
        <?php
          $currentCat = isset($_GET['cat']) ? strtolower($_GET['cat']) : 'all';
          $filters = [
            'ALL' => '',
            'BREAKFAST' => 'breakfast',
            'LUNCH' => 'lunch',
            'DINNER' => 'dinner'
          ];
          foreach ($filters as $label => $slug):
            $isActive = ($slug === $currentCat || ($currentCat === 'all' && $slug === '')) ? 'active' : '';
            $href = $slug ? "?cat={$slug}" : "index.php";
        ?>
          <a href="<?php echo $href; ?>" class="filter-pill <?php echo $isActive; ?>">
            <?php echo htmlspecialchars($label); ?>
          </a>
        <?php endforeach; ?>
      </div>
    </header>

    <!-- Cards Grid -->
    <div class="cards-grid">

      <?php if (!empty($recipes_home) && is_array($recipes_home)): ?>
        <?php foreach ($recipes_home as $r): ?>
          <article class="recipe-card">
            <a href="/recipe.php?id=<?php echo htmlspecialchars($r['id']); ?>" class="recipe-link">
              <div class="recipe-media">
                <img 
                  src="<?php echo htmlspecialchars($r['main_image_url']); ?>" 
                  alt="<?php echo htmlspecialchars($r['title']); ?>">

                <?php
                  // Badge logic cơ bản
                  $badge_text = !empty($r['is_featured']) ? 'CHEF PICK' : 'NEW';
                ?>
                <span class="badge">
                  <?php echo htmlspecialchars($badge_text); ?>
                </span>
              </div>

              <div class="recipe-body">
                <h3 class="recipe-title">
                  <?php echo htmlspecialchars($r['title']); ?>
                </h3>

                <p class="recipe-excerpt">
                  <?php echo htmlspecialchars($r['excerpt']); ?>
                </p>

                <div class="recipe-meta">
                  <span class="meta-item">
                    <?php echo htmlspecialchars($r['time_display']); ?>
                  </span>
                  <span class="meta-item">
                    <?php echo htmlspecialchars($r['difficulty']); ?>
                  </span>
                  <span class="meta-item">
                    <?php echo htmlspecialchars($r['servings_display']); ?>
                  </span>
                </div>

                <div class="recipe-cta">
                  <span class="btn-small">VIEW RECIPE</span>
                </div>
              </div>
            </a>
          </article>
        <?php endforeach; ?>
      <?php else: ?>
        <p>No recipes found.</p>
      <?php endif; ?>

    </div><!-- /.cards-grid -->

  </div><!-- /.container -->
</section>
