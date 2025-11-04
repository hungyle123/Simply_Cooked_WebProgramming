<?php
require_once __DIR__ . '/../config/db.php';
$page_title = "Recipes - Simply Cooked";
$active = 'recipes';
include __DIR__ . '/../app/views/header.php';

/** --- Input (GET) --- */
$cat  = strtolower(trim($_GET['cat'] ?? 'all'));                 // all|breakfast|lunch|dinner
$q    = trim($_GET['q'] ?? '');
$sort = strtolower(trim($_GET['sort'] ?? 'newest'));             // newest|oldest|title|time
$page = max(1, intval($_GET['page'] ?? 1));
$perPage = 9;

$allowedCat  = ['all','breakfast','lunch','dinner'];
if (!in_array($cat, $allowedCat, true)) $cat = 'all';

$allowedSort = ['newest','oldest','title','time'];
if (!in_array($sort, $allowedSort, true)) $sort = 'newest';

/** --- Build WHERE/ORDER --- */
$where  = [];
$params = [];
$types  = '';

if ($cat !== 'all') {
  // lọc theo category slug
  $where[] = "EXISTS (
                SELECT 1
                FROM recipe_categories rc
                JOIN categories c ON c.category_id = rc.category_id
                WHERE rc.recipe_id = r.recipe_id AND c.slug = ?
              )";
  $params[] = $cat;
  $types   .= 's';
}

if ($q !== '') {
  $where[] = "(r.title LIKE CONCAT('%', ?, '%') OR r.keywords LIKE CONCAT('%', ?, '%'))";
  $params[] = $q; $params[] = $q;
  $types .= 'ss';
}

$whereSql = $where ? ('WHERE '.implode(' AND ', $where)) : '';

switch ($sort) {
  case 'oldest': $orderSql = "ORDER BY r.created_at ASC"; break;
  case 'title':  $orderSql = "ORDER BY r.title ASC"; break;
  case 'time':   // ưu tiên total_time rồi đến prep_time nếu thiếu
                 $orderSql = "ORDER BY COALESCE(NULLIF(r.total_time,''), NULLIF(r.prep_time,'')) ASC, r.title ASC"; break;
  default:       $orderSql = "ORDER BY r.created_at DESC"; // newest
}

$offset = ($page - 1) * $perPage;

/** --- Count total --- */
$sqlCount = "SELECT COUNT(*) AS cnt FROM recipes r $whereSql";
$stmt = $conn->prepare($sqlCount);
if ($types) $stmt->bind_param($types, ...$params);
$stmt->execute();
$total = (int)($stmt->get_result()->fetch_assoc()['cnt'] ?? 0);
$stmt->close();

$totalPages = max(1, (int)ceil($total / $perPage));

/** --- Fetch page --- */
$sql = "SELECT r.recipe_id, r.title, r.slug, r.meta_description, r.keywords,
               r.main_image_url, r.prep_time, r.cook_time, r.total_time, r.is_featured
        FROM recipes r
        $whereSql
        $orderSql
        LIMIT ? OFFSET ?";
$stmt = $conn->prepare($sql);
if ($types) {
  $types2 = $types . 'ii';
  $params2 = array_merge($params, [$perPage, $offset]);
  $stmt->bind_param($types2, ...$params2);
} else {
  $stmt->bind_param('ii', $perPage, $offset);
}
$stmt->execute();
$res = $stmt->get_result();
$rows = $res->fetch_all(MYSQLI_ASSOC);
$stmt->close();

/** --- Helper giữ tham số URL --- */
function keep_params(array $extra = []) {
  $params = $_GET;
  foreach ($extra as $k=>$v) $params[$k]=$v;
  return '?' . http_build_query($params);
}
?>

<main class="site-main">
  <!-- Breadcrumb -->
  <div class="container breadcrumb">
    <ul>
      <li><a href="index.php">Home</a></li>
      <li>/</li>
      <li><strong>Recipes</strong></li>
    </ul>
  </div>

  <!-- Header của trang Recipes -->
  <section class="container recipes-section">
    <div class="recipes-header">
      <button class="recipes-badge" type="button">Explore</button>
      <h1 class="recipes-title">Browse Recipes</h1>
      <p class="recipes-desc">
        Find recipes by category, keyword and sort. Food product card grid interface available.
      </p>

      <!-- Bộ lọc danh mục -->
      <div class="recipe-filters">
        <?php
          $cats = ['all'=>'All','breakfast'=>'Breakfast','lunch'=>'Lunch','dinner'=>'Dinner'];
          foreach ($cats as $slug=>$label):
            $active = ($slug === $cat) ? 'active' : '';
        ?>
          <a class="filter-pill <?= $active ?>"
             href="<?= htmlspecialchars(keep_params(['cat'=>$slug,'page'=>1])) ?>"><?= htmlspecialchars($label) ?></a>
        <?php endforeach; ?>
      </div>

      <!-- Thanh tìm kiếm + sắp xếp -->
      <form method="get" class="login-row-2col" style="margin-top:10px; gap:12px;">
        <input type="hidden" name="cat" value="<?= htmlspecialchars($cat) ?>">
        <input type="hidden" name="page" value="1"><!-- reset về page 1 khi apply/sort -->
        <div class="form-group" style="grid-column:1 / 3;">
          <label for="q">Search recipes</label>
          <input id="q" name="q" type="text" placeholder="Search by title or keyword…"
                 value="<?= htmlspecialchars($q) ?>">
        </div>
        <div class="form-group">
          <label for="sort">Sort by</label>
          <select id="sort" name="sort" style="padding:12px 14px; border:1px solid #cfc8bf; border-radius:8px;">
            <option value="newest" <?= $sort==='newest'?'selected':'' ?>>Newest</option>
            <option value="oldest" <?= $sort==='oldest'?'selected':'' ?>>Oldest</option>
            <option value="title"  <?= $sort==='title'?'selected':''  ?>>Title (A–Z)</option>
            <option value="time"   <?= $sort==='time'?'selected':''   ?>>Time (prep/total)</option>
          </select>
        </div>
        <div class="form-group" style="align-self:end; text-align:right;">
          <button class="btn-primary" type="submit">Apply</button>
        </div>
      </form>
    </div>

    <!-- Grid thẻ công thức -->
    <div class="cards-grid">
      <?php if (!$rows): ?>
        <p class="muted">No recipes found. Try a different filter or keyword.</p>
      <?php else: foreach ($rows as $r): ?>
        <article class="recipe-card">
          <a class="recipe-link" href="recipe.php?id=<?= (int)$r['recipe_id'] ?>">
            <div class="recipe-card-media">
              <?php if (!empty($r['is_featured'])): ?>
                <span class="badge-pill badge-orange">Featured</span>
              <?php endif; ?>
              <img class="recipe-card-img"
                   src="<?= htmlspecialchars($r['main_image_url'] ?: '/assets/images/placeholder.jpg') ?>"
                   alt="<?= htmlspecialchars($r['title']) ?>">
            </div>
            <div class="recipe-body">
              <h3 class="recipe-title"><?= htmlspecialchars($r['title']) ?></h3>
              <?php if (!empty($r['meta_description'])): ?>
                <p class="recipe-excerpt"><?= htmlspecialchars($r['meta_description']) ?></p>
              <?php endif; ?>
              <div class="recipe-meta">
                <?php if (!empty($r['prep_time'])): ?>
                  <span class="meta-item">Prep: <?= htmlspecialchars($r['prep_time']) ?></span>
                <?php endif; ?>
                <?php if (!empty($r['cook_time'])): ?>
                  <span class="meta-item">Cook: <?= htmlspecialchars($r['cook_time']) ?></span>
                <?php endif; ?>
                <?php if (!empty($r['total_time'])): ?>
                  <span class="meta-item">Total: <?= htmlspecialchars($r['total_time']) ?></span>
                <?php endif; ?>
              </div>
              <div class="recipe-cta">
                <span class="btn-small">View Recipe</span>
              </div>
            </div>
          </a>
        </article>
      <?php endforeach; endif; ?>
    </div>

    <!-- Pagination -->
    <?php if ($totalPages > 1): ?>
      <div class="container" style="margin-top:24px; display:flex; gap:8px; justify-content:center;">
        <?php
          $prev = max(1, $page-1);
          $next = min($totalPages, $page+1);
        ?>
        <a class="btn" href="<?= htmlspecialchars(keep_params(['page'=>$prev])) ?>" aria-label="Previous">« Prev</a>
        <?php for ($i=1; $i<=$totalPages; $i++): ?>
          <a class="btn<?= $i===$page?' btn-primary':'' ?>"
             href="<?= htmlspecialchars(keep_params(['page'=>$i])) ?>"><?= $i ?></a>
        <?php endfor; ?>
        <a class="btn" href="<?= htmlspecialchars(keep_params(['page'=>$next])) ?>" aria-label="Next">Next »</a>
      </div>
    <?php endif; ?>

  </section>
</main>

<?php include __DIR__ . '/../app/views/footer.php'; ?>

<!-- Auto-submit sort -->
<script>
  document.addEventListener('DOMContentLoaded', function () {
    var sortSel = document.getElementById('sort');
    if (sortSel && sortSel.form) {
      sortSel.addEventListener('change', function () {
        var pg = sortSel.form.querySelector('input[name="page"]');
        if (pg) pg.value = 1;        // luôn quay lại trang 1 khi đổi sort
        if (sortSel.form.requestSubmit) sortSel.form.requestSubmit();
        else sortSel.form.submit();
      });
    }
  });
</script>
