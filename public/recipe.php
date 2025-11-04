<?php
require_once __DIR__ . '/../config/db.php';
$active = '';
$page_title = "Recipe - Simply Cooked";
include __DIR__ . '/../app/views/header.php';

/* ========== Input: id hoặc slug ========== */
$rid  = isset($_GET['id']) ? intval($_GET['id']) : 0;
$slug = isset($_GET['slug']) ? trim($_GET['slug']) : '';

$recipe = null;
if ($rid > 0) {
  $sql = "SELECT r.*, u.full_name AS author_name, u.profile_image_url AS author_avatar, u.bio AS author_bio
          FROM recipes r
          LEFT JOIN users u ON u.user_id = r.user_id
          WHERE r.recipe_id = ?";
  $stmt = $conn->prepare($sql);
  $stmt->bind_param('i', $rid);
} elseif ($slug !== '') {
  $sql = "SELECT r.*, u.full_name AS author_name, u.profile_image_url AS author_avatar, u.bio AS author_bio
          FROM recipes r
          LEFT JOIN users u ON u.user_id = r.user_id
          WHERE r.slug = ?";
  $stmt = $conn->prepare($sql);
  $stmt->bind_param('s', $slug);
} else {
  http_response_code(404);
  echo "<main class='site-main container'><p>Recipe not found.</p></main>";
  include __DIR__ . '/../app/views/footer.php';
  exit;
}
$stmt->execute();
$res = $stmt->get_result();
$recipe = $res->fetch_assoc();
$stmt->close();

if (!$recipe) {
  http_response_code(404);
  echo "<main class='site-main container'><p>Recipe not found.</p></main>";
  include __DIR__ . '/../app/views/footer.php';
  exit;
}

/* ========== Categories (để hiển thị chip + similar) ========== */
$catSlugs = [];
$catNames = [];
$catSql = "SELECT c.slug, c.name
           FROM recipe_categories rc
           JOIN categories c ON c.category_id = rc.category_id
           WHERE rc.recipe_id = ?";
$stmt = $conn->prepare($catSql);
$stmt->bind_param('i', $recipe['recipe_id']);
$stmt->execute();
$cr = $stmt->get_result();
while ($row = $cr->fetch_assoc()) {
  $catSlugs[] = $row['slug'];
  $catNames[] = $row['name'];
}
$stmt->close();

/* ========== Where to buy (stores) ========== */
$stores = [];
$storeSql = "SELECT s.*
             FROM recipe_stores rs
             JOIN stores s ON s.store_id = rs.store_id
             WHERE rs.recipe_id = ?
             ORDER BY s.name ASC";
$stmt = $conn->prepare($storeSql);
$stmt->bind_param('i', $recipe['recipe_id']);
$stmt->execute();
$stores = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
$stmt->close();

/* ========== Ingredients (normalized) ========== */
$ingredients = [];
$ingSql = "SELECT name, quantity, unit, note
           FROM recipe_ingredients
           WHERE recipe_id = ?
           ORDER BY sort_order, id";
$stmt = $conn->prepare($ingSql);
$stmt->bind_param('i', $recipe['recipe_id']);
$stmt->execute();
$ir = $stmt->get_result();
while ($row = $ir->fetch_assoc()) {
  $ingredients[] = $row;
}
$stmt->close();

/* ========== Equipment & Nutrition (optional) ========== */
$equipment = [];
$eqSql = "SELECT name
          FROM recipe_equipment
          WHERE recipe_id = ?
          ORDER BY sort_order, id";
$stmt = $conn->prepare($eqSql);
$stmt->bind_param('i', $recipe['recipe_id']);
$stmt->execute();
$equipment = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
$stmt->close();

$nutrition = null;
$nuSql = "SELECT calories, protein_g, fat_g, carbs_g, note
          FROM recipe_nutrition
          WHERE recipe_id = ?";
$stmt = $conn->prepare($nuSql);
$stmt->bind_param('i', $recipe['recipe_id']);
$stmt->execute();
$nutrition = $stmt->get_result()->fetch_assoc();
$stmt->close();

/* ========== Similar recipes theo category ========== */
$similar = [];
if (!empty($catSlugs)) {
  $in = implode(',', array_fill(0, count($catSlugs), '?'));
  $types = str_repeat('s', count($catSlugs)) . 'i';
  $params = array_merge($catSlugs, [$recipe['recipe_id']]);

  $simSql = "SELECT DISTINCT r.recipe_id, r.title, r.slug, r.meta_description, r.main_image_url, r.total_time, r.prep_time, r.is_featured
             FROM recipes r
             JOIN recipe_categories rc ON rc.recipe_id = r.recipe_id
             JOIN categories c ON c.category_id = rc.category_id
             WHERE c.slug IN ($in) AND r.recipe_id <> ?
             ORDER BY r.created_at DESC
             LIMIT 6";
  $stmt = $conn->prepare($simSql);
  $stmt->bind_param($types, ...$params);
  $stmt->execute();
  $similar = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
  $stmt->close();
}

/* ========== Meta hiển thị ========== */
$title = $recipe['title'] ?: 'Recipe';
$intro = $recipe['description'] ?: ($recipe['meta_description'] ?? '');
$img   = $recipe['main_image_url'] ?: '/assets/images/placeholder.jpg';
$prep  = $recipe['prep_time'] ?: '';
$cook  = $recipe['cook_time'] ?: '';
$total = $recipe['total_time'] ?: '';
$serv  = $recipe['servings'] ?: '';
$diff  = strtoupper($recipe['difficulty'] ?: (!empty($recipe['is_featured']) ? 'HARD' : 'EASY')) . ' PREP';

/* ===== Helpers: render instructions & dos/donts theo style Figma ===== */
function render_instructions($introText, $fullText) {
  ob_start(); ?>
  <h2 class="recipes-title" style="font-size:28px;margin-top:20px;">INSTRUCTIONS</h2>
  <?php if (!empty($introText)): ?>
    <p style="margin:10px 0 16px;color:#574f48;line-height:1.7;"><?= nl2br(htmlspecialchars($introText)) ?></p>
  <?php endif; ?>

  <?php
  // Quy ước: dòng tiêu đề (section) viết HOA hoặc kết thúc bằng dấu ":" -> render h3 nhỏ màu cam
  $lines = preg_split('/\R/', (string)$fullText);
  foreach ($lines as $ln) {
    $t = trim($ln);
    if ($t === '') { echo '<br>'; continue; }

    $isHeading = false;
    if (substr($t, -1) === ':' || strtoupper($t) === $t && mb_strlen($t) <= 40) {
      $isHeading = true;
    }
    if ($isHeading) {
      echo '<div style="margin-top:14px;color:#e85b3a;font-weight:800;letter-spacing:.02em;">'
         . htmlspecialchars(rtrim($t, ':'))
         . '</div>';
      continue;
    }

    // bullet nếu bắt đầu bằng "- "
    if (strpos($t, '- ') === 0) {
      echo '<ul style="margin:6px 0;padding-left:18px;"><li style="line-height:1.7;color:#2a2725;">'
         . htmlspecialchars(substr($t, 2))
         . '</li></ul>';
    } else {
      echo '<p style="margin:4px 0;color:#2a2725;line-height:1.7;">'
         . htmlspecialchars($t)
         . '</p>';
    }
  }
  return ob_get_clean();
}

function render_dos_donts($raw) {
  $lines = preg_split('/\R/', (string)$raw);
  $mode = null; // 'do' | 'dont'
  $bufDo = []; $bufDont = [];

  foreach ($lines as $ln) {
    $t = trim($ln);
    if ($t === '') continue;

    // nhận tiêu đề khối
    if (stripos($t, 'do’') === 0 || stripos($t, "do'") === 0 || preg_match('/^do[\s:]/i',$t)) { $mode = 'do'; continue; }
    if (stripos($t, 'don’') === 0 || stripos($t, "don'") === 0 || preg_match('/^don/i',$t)) { $mode = 'dont'; continue; }

    if (strpos($t, '- ') === 0) $t = substr($t, 2);

    // pattern **Title:** body
    $title = '';
    $body  = $t;
    if (preg_match('/^\*\*(.+?)\*\*:\s*(.+)$/u', $t, $m)) {
      $title = $m[1]; $body = $m[2];
    }

    $itemHtml = '<li style="margin:6px 0;line-height:1.7;"><span style="font-weight:700;">'
              . htmlspecialchars($title)
              . '</span>' . ($title ? ': ' : '')
              . htmlspecialchars($body) . '</li>';

    if ($mode === 'dont') $bufDont[] = $itemHtml; else $bufDo[] = $itemHtml;
  }

  ob_start(); ?>
  <div class="dosdonts" style="margin-top:18px;">
    <h3 class="recipes-title" style="margin-bottom:10px;">
      Let’s go over the basics– the do’s, and the don’ts– for How to Cook a chicken
    </h3>

    <?php if ($bufDo): ?>
      <div style="margin-top:12px;">
        <div style="color:#e85b3a;font-weight:800;letter-spacing:.02em;margin-bottom:8px;">DO’S:</div>
        <ul style="margin:0;padding-left:18px;"><?php echo implode('', $bufDo); ?></ul>
      </div>
    <?php endif; ?>

    <?php if ($bufDont): ?>
      <div style="margin-top:18px;">
        <div style="color:#e85b3a;font-weight:800;letter-spacing:.02em;margin-bottom:8px;">DON’TS:</div>
        <ul style="margin:0;padding-left:18px;"><?php echo implode('', $bufDont); ?></ul>
      </div>
    <?php endif; ?>
  </div>
  <?php
  return ob_get_clean();
}
?>

<style>
.recipe-hero{background:var(--card);border-radius:var(--round);box-shadow:var(--shadow);padding:28px 28px 18px;border:1px solid rgba(0,0,0,0.04)}
.recipe-hero .meta-line{display:flex;gap:14px;align-items:center;justify-content:center;font-weight:600;letter-spacing:.02em}
.recipe-hero .meta-dot{opacity:.6}
.recipe-hero-img{width:100%;height:auto;border-radius:16px;display:block;margin-top:18px}
.recipe-layout{display:grid;grid-template-columns:1.45fr .8fr;gap:22px;margin-top:22px}
@media(max-width:960px){.recipe-layout{grid-template-columns:1fr}}
.sidebox{background:var(--card);border:1px solid #e6ded5;border-radius:14px;padding:16px 18px;box-shadow:var(--shadow)}
.sidebox h4{margin:4px 0 10px;font-family:var(--font-heading);letter-spacing:.02em}
.sidebox ul{margin:0;padding-left:18px}
.sidebox .map-placeholder{background:#f3ece5;border:1px dashed #d7cfc7;border-radius:12px;height:180px;display:flex;align-items:center;justify-content:center;font-size:14px;color:#7b7570}
.badge-chip{display:inline-block;padding:6px 10px;border-radius:999px;background:#fde7df;color:#e85b3a;font-weight:700;font-size:12px}
.author-box{display:flex;gap:12px;align-items:center;border-top:1px solid #e6ded5;padding-top:16px;margin-top:16px}
.author-box img{width:44px;height:44px;border-radius:999px;object-fit:cover}
.similar-head{margin:26px 0 10px}

.author-spotlight{
  border:1px solid #e6ded5;
  background:var(--card);
  border-radius:16px;
  padding:18px;
  box-shadow:var(--shadow);
  display:flex;
  gap:16px;
  align-items:flex-start;
  margin-top:28px;
}
.author-spotlight .avatar{
  width:88px;height:88px;border-radius:14px;object-fit:cover;flex:0 0 88px;
  box-shadow:0 2px 10px rgba(0,0,0,.06);
}
.author-spotlight .name{
  font-weight:700; font-size:18px; margin:0 0 6px;
}
.author-spotlight .bio{
  color:#4e4944; line-height:1.7; margin:0 0 14px;
}
.author-spotlight .cta{
  display:inline-flex; align-items:center; gap:6px;
  padding:10px 16px; border:1px solid #1a1a1a; border-radius:999px;
  font-weight:700; text-transform:uppercase; font-size:13px;
}
.author-spotlight .cta:hover{ box-shadow:0 4px 14px rgba(0,0,0,.08); }
</style>

<main class="site-main">
  <!-- Breadcrumb -->
  <div class="container breadcrumb">
    <ul>
      <li><a href="index.php">Home</a></li>
      <li>/</li>
      <li><a href="recipes.php">Recipes</a></li>
      <li>/</li>
      <li><strong><?= htmlspecialchars($title) ?></strong></li>
    </ul>
  </div>

  <section class="container">
    <div class="recipe-hero">
      <div style="text-align:center;">
        <span class="badge-chip">RECIPE</span>
        <h1 class="recipes-title" style="margin:10px 0 8px;"><?= htmlspecialchars(strtoupper($title)) ?></h1>
        <?php if ($intro): ?>
          <p class="recipes-desc" style="max-width:760px;margin:0 auto;"><?= htmlspecialchars($intro) ?></p>
        <?php endif; ?>
        <div class="meta-line" style="margin-top:8px;">
          <?php if ($total): ?>
            <span>⏱ <?= htmlspecialchars($total) ?></span>
          <?php elseif ($prep || $cook): ?>
            <span>⏱ Prep <?= htmlspecialchars($prep) ?><?= $cook ? " · Cook ".htmlspecialchars($cook) : "" ?></span>
          <?php endif; ?>
          <span class="meta-dot">•</span>
          <span><?= htmlspecialchars($diff) ?></span>
          <span class="meta-dot">•</span>
          <span><?= $serv ? htmlspecialchars($serv) : 'Serves —' ?></span>
        </div>
      </div>
      <img class="recipe-hero-img" src="<?= htmlspecialchars($img) ?>" alt="<?= htmlspecialchars($title) ?>">
    </div>

    <div class="recipe-layout">
      <!-- MAIN -->
      <article>
        <?php if (!empty($recipe['description'])): ?>
          <p style="margin-top:16px;color:#574f48;"><?= nl2br(htmlspecialchars($recipe['description'])) ?></p>
        <?php endif; ?>

        <?php
          // DO’s / DON’Ts (nếu có)
          if (!empty($recipe['dos_donts'])) {
            echo render_dos_donts($recipe['dos_donts']);
          }
        ?>

        <?php
          // INSTRUCTIONS (intro + nội dung)
          echo render_instructions($recipe['instructions_intro'] ?? '', $recipe['instructions'] ?? '');
        ?>

        <!-- Author Spotlight -->
        <div class="author-spotlight">
          <img class="avatar"
              src="<?= htmlspecialchars($recipe['author_avatar'] ?: '/assets/images/author_sophia.jpg') ?>"
              alt="<?= htmlspecialchars($recipe['author_name'] ?: 'Author') ?>">

          <div>
            <div class="name"><?= htmlspecialchars($recipe['author_name'] ?: 'Cooks Delight') ?></div>
            <p class="bio">
              <?php
                $bio = trim($recipe['author_bio'] ?? '');
                if ($bio === '') {
                  $bio = "In the world of pots and pans, I'm on a mission to turn every meal into a masterpiece. "
                      . "Cooks Delight is not just a blog; it's a shared space where the love for food transcends boundaries. "
                      . "Here, we celebrate the art of crafting meals that not only nourish the body but also feed the soul.";
                }
                echo htmlspecialchars($bio);
              ?>
            </p>
            <a class="cta" href="aboutus.php">Learn More</a>
          </div>
        </div>
      </article>

      <!-- SIDEBAR -->
      <aside>
        <div class="sidebox">
          <h4>INGREDIENTS</h4>
          <?php if ($ingredients): ?>
            <ul>
              <?php foreach ($ingredients as $ing):
                $txt = $ing['name'];
                if (!empty($ing['quantity'])) $txt = $ing['quantity'].' '.($ing['unit']??''). ' ' . $txt;
                if (!empty($ing['note'])) $txt .= ' — '.$ing['note'];
              ?>
                <li><?= htmlspecialchars(trim(preg_replace('/\s+/', ' ', $txt))) ?></li>
              <?php endforeach; ?>
            </ul>
          <?php else: ?>
            <p class="muted">No ingredients listed.</p>
          <?php endif; ?>
        </div>

        <div class="sidebox" style="margin-top:14px;">
          <h4>WHERE TO BUY</h4>
          <?php if ($stores): ?>
            <ul style="margin-bottom:12px;">
              <?php foreach ($stores as $s): ?>
                <li style="margin-bottom:6px;">
                  <strong><?= htmlspecialchars($s['name']) ?></strong>
                  <?php if ($s['address']): ?>
                    <div class="muted" style="font-size:13px;"><?= htmlspecialchars($s['address']) ?></div>
                  <?php endif; ?>
                  <div style="margin-top:6px;">
                    <?php if (!empty($s['google_maps_url'])): ?>
                      <a class="btn-small" target="_blank" href="<?= htmlspecialchars($s['google_maps_url']) ?>">View on Map</a>
                    <?php else: ?>
                      <span class="muted">Map link coming soon</span>
                    <?php endif; ?>
                  </div>
                </li>
              <?php endforeach; ?>
            </ul>
          <?php else: ?>
            <p class="muted">No store suggestions yet.</p>
          <?php endif; ?>
          <div class="sidebox map-placeholder" style="height:160px;margin-top:8px;">Map preview placeholder</div>
        </div>

        <div class="sidebox" style="margin-top:14px;">
          <h4>EQUIPMENT</h4>
          <?php if ($equipment): ?>
            <ul>
              <?php foreach ($equipment as $e): ?>
                <li><?= htmlspecialchars($e['name']) ?></li>
              <?php endforeach; ?>
            </ul>
          <?php else: ?>
            <ul>
              <li>Roasting pan</li>
              <li>Meat thermometer</li>
              <li>Cutting board</li>
              <li>Kitchen twine</li>
            </ul>
          <?php endif; ?>
        </div>

        <div class="sidebox" style="margin-top:14px;">
          <h4>NUTRITION (est.)</h4>
          <?php if ($nutrition): ?>
            <ul>
              <?php if ($nutrition['calories'] !== null): ?><li><strong>Calories:</strong> <?= (int)$nutrition['calories'] ?></li><?php endif; ?>
              <?php if ($nutrition['protein_g'] !== null): ?><li><strong>Protein:</strong> <?= htmlspecialchars($nutrition['protein_g']) ?> g</li><?php endif; ?>
              <?php if ($nutrition['fat_g'] !== null): ?><li><strong>Total fat:</strong> <?= htmlspecialchars($nutrition['fat_g']) ?> g</li><?php endif; ?>
              <?php if ($nutrition['carbs_g'] !== null): ?><li><strong>Carbs:</strong> <?= htmlspecialchars($nutrition['carbs_g']) ?> g</li><?php endif; ?>
            </ul>
            <?php if (!empty($nutrition['note'])): ?>
              <div class="muted" style="font-size:12px;margin-top:8px;"><?= htmlspecialchars($nutrition['note']) ?></div>
            <?php endif; ?>
          <?php else: ?>
            <div class="muted" style="font-size:12px;">* Approximate values per serving.</div>
          <?php endif; ?>
        </div>
      </aside>
    </div>

    <!-- SIMILAR -->
    <?php if ($similar): ?>
      <h2 class="recipes-title similar-head">SIMILAR RECIPES</h2>
      <div class="cards-grid">
        <?php foreach ($similar as $r): ?>
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
                  <?php if (!empty($r['total_time'])): ?>
                    <span class="meta-item">Total: <?= htmlspecialchars($r['total_time']) ?></span>
                  <?php elseif (!empty($r['prep_time'])): ?>
                    <span class="meta-item">Prep: <?= htmlspecialchars($r['prep_time']) ?></span>
                  <?php endif; ?>
                </div>
                <div class="recipe-cta"><span class="btn-small">View Recipe</span></div>
              </div>
            </a>
          </article>
        <?php endforeach; ?>
      </div>
    <?php endif; ?>
  </section>
</main>

<?php include __DIR__ . '/../app/views/footer.php'; ?>
