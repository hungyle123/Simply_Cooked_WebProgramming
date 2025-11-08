<?php
require_once __DIR__ . '/../../config/db.php';

/** --- Load categories dynamically --- */
$cats = [];
$catStmt = $conn->prepare("SELECT slug, name FROM categories ORDER BY name ASC");
$catStmt->execute();
$catRes = $catStmt->get_result();
while ($row = $catRes->fetch_assoc()) {
  $slug = strtolower(trim($row['slug']));
  if ($slug !== '') {
    $cats[$slug] = $row['name'];
  }
}
$catStmt->close();

/** --- Resolve selected category (default: all) --- */
$cat = strtolower(trim($_GET['cat'] ?? 'all'));
if ($cat !== 'all' && !array_key_exists($cat, $cats)) {
  $cat = 'all';
}

/** --- Card renderer (re-use existing view) --- */
function render_recipe_card(array $r) {
  include __DIR__ . '/recipe_card.php'; // expects $r
}

/** --- Query recipes --- */
if ($cat === 'all') {
  $sql = "
    SELECT r.*
    FROM recipes r
    ORDER BY r.is_featured DESC, r.created_at DESC
    LIMIT 6";
  $stmt = $conn->prepare($sql);
} else {
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

      <!-- Filter Pills (dynamic from DB) -->
      <div class="recipe-filters">
        <?php
          $currentCat = $cat; // resolved above
          // Render "ALL"
          $isActive = ($currentCat === 'all') ? 'active' : '';
          $href = strtok($_SERVER['REQUEST_URI'], '?'); // same page without query
        ?>
          <a href="<?php echo htmlspecialchars($href); ?>" class="filter-pill <?php echo $isActive; ?>">
            ALL
          </a>
        <?php
          // Render each category from DB
          foreach ($cats as $slug => $name):
            $isActive = ($currentCat === $slug) ? 'active' : '';
            $url = $href . '?cat=' . urlencode($slug);
        ?>
            <a href="<?php echo htmlspecialchars($url); ?>" class="filter-pill <?php echo $isActive; ?>">
              <?php echo htmlspecialchars(strtoupper($name)); ?>
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
