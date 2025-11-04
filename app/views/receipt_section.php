<?php
require_once __DIR__ . '/../../config/db.php';

/** cat = all|breakfast|lunch|dinner (mặc định all) */
$cat = strtolower(trim($_GET['cat'] ?? 'all'));
$allowed = ['all','breakfast','lunch','dinner'];
if (!in_array($cat, $allowed, true)) $cat = 'all';

/** Hàm render 1 card (tận dụng file view có sẵn) */
function render_recipe_card(array $r) {
  include __DIR__ . '/recipe_card.php'; // dùng $r
}

if ($cat === 'all') {
  $sql = "
    SELECT r.*
    FROM recipes r
    ORDER BY r.is_featured DESC, r.created_at DESC
    LIMIT 6";
  $stmt = $conn->prepare($sql);
} else {
  // lọc theo slug category
  $sql = "
    SELECT r.*
    FROM recipes r
    JOIN recipe_categories rc ON rc.recipe_id = r.recipe_id
    JOIN categories c ON c.category_id = rc.category_id
    WHERE c.slug = ?
    ORDER BY r.is_featured DESC, r.created_at DESC
    LIMIT 6";
  $stmt = $conn->prepare($sql);
  $stmt->bind_param('s', $cat);
}

$stmt->execute();
$res = $stmt->get_result();
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
      <?php while ($r = $res->fetch_assoc()): ?>
        <?php render_recipe_card($r); ?>
      <?php endwhile; ?>
    </div>

  </div><!-- /.container -->
</section>
