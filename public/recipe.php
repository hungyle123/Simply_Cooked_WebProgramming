<?php
// /public/recipe.php
require_once __DIR__ . '/../config/db.php';

/* ===================== Input ===================== */
$rid  = isset($_GET['id']) ? intval($_GET['id']) : 0;
$slug = isset($_GET['slug']) ? trim($_GET['slug']) : '';

/* ===================== Helpers ===================== */
function h($s){ return htmlspecialchars((string)$s, ENT_QUOTES, 'UTF-8'); }
function split_paragraphs($text){
  $parts = preg_split('/\R{2,}|\n{1,}/', (string)$text);
  $out = [];
  foreach($parts as $p){ $p = trim($p); if($p!=='') $out[] = $p; }
  return $out;
}
function ingredient_line($ing){
  $line = '';
  if (isset($ing['quantity']) && $ing['quantity'] !== null && $ing['quantity'] !== '') {
    $line .= h($ing['quantity']).' ';
  }
  if (!empty($ing['unit'])) {
    $line .= h($ing['unit']).' ';
  }
  $line .= h($ing['name'] ?? '');
  if (!empty($ing['note'])) {
    $line .= ' — '.h($ing['note']);
  }
  return $line;
}
function embed_youtube_if_any($url){
  if(!$url) return '';
  $vid = '';
  if(preg_match('~youtu\.be/([^?&]+)~', $url, $m)) $vid = $m[1];
  elseif(preg_match('~v=([^?&]+)~', $url, $m))   $vid = $m[1];
  if(!$vid) return '<a class="btn" href="'.h($url).'" target="_blank" rel="noopener">Watch Video</a>';
  $src = "https://www.youtube.com/embed/".h($vid);
  return '<div class="video-embed"><iframe src="'.$src.'" title="Recipe video" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>';
}
function embed_origin_map(array $recipe){
  $place = trim((string)($recipe['origin_place'] ?? ''));
  $zoom  = (int)($recipe['origin_zoom'] ?? 11);
  $mymap = trim((string)($recipe['origin_map_embed_url'] ?? ''));

  if ($mymap !== '') {
    $src = htmlspecialchars($mymap, ENT_QUOTES, 'UTF-8');
  } elseif ($place !== '') {
    $q   = urlencode($place);
    $z   = max(1, min(20, $zoom ?: 11));
    $src = "https://www.google.com/maps?q={$q}&z={$z}&output=embed";
  } else {
    return '';
  }

  return '<div class="map-embed"><iframe src="'.$src.'" loading="lazy" referrerpolicy="no-referrer-when-downgrade" width="100%" height="100%" style="border:0;" allowfullscreen></iframe></div>';
}
function fmt_minutes($m){
  if ($m === null || $m === '' ) return null;
  $m = (int)$m;
  if ($m < 60) return $m . ' mins';
  $h = intdiv($m, 60);
  $r = $m % 60;
  return $r ? "{$h}h {$r}m" : "{$h}h";
}

/* ===================== Load recipe ===================== */
if ($rid > 0) {
  $sql = "SELECT r.*, u.full_name AS author_name, u.profile_image_url AS author_avatar
          FROM recipes r
          LEFT JOIN users u ON u.user_id = r.user_id
          WHERE r.recipe_id = ?";
  $stmt = $conn->prepare($sql);
  $stmt->bind_param('i', $rid);
} elseif ($slug !== '') {
  $sql = "SELECT r.*, u.full_name AS author_name, u.profile_image_url AS author_avatar
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

/* ===================== Preferred URL (slug) ===================== */
if (!empty($recipe['slug']) && isset($_GET['id']) && !isset($_GET['slug'])) {
  $target = BASE_URL . 'recipe.php?slug=' . urlencode($recipe['slug']);
  header('Location: ' . $target, true, 301);
  exit;
}

/* ===================== Increment views ===================== */
$rid = (int)$recipe['recipe_id'];
$conn->query("UPDATE recipes SET views = views + 1 WHERE recipe_id = {$rid} LIMIT 1");

/* ===================== Load related data ===================== */
// RELATED: recipes cùng category, trừ chính nó
$related = [];
if ($rid > 0) {
  $sqlRel = "SELECT r.recipe_id, r.title, r.slug, r.main_image_url,
                    r.total_minutes AS total_time,  /* alias để không vỡ view cũ */
                    r.difficulty, r.is_featured, r.views, r.created_at
    FROM recipes r
    JOIN recipe_categories rc ON rc.recipe_id = r.recipe_id
    WHERE rc.category_id IN (
      SELECT category_id FROM recipe_categories WHERE recipe_id = ?
    )
      AND r.recipe_id <> ?
    GROUP BY r.recipe_id
    ORDER BY r.is_featured DESC, r.views DESC, r.created_at DESC
    LIMIT 6";
  if ($st = $conn->prepare($sqlRel)) {
    $st->bind_param('ii', $rid, $rid);
    $st->execute();
    $related = $st->get_result()->fetch_all(MYSQLI_ASSOC);
    $st->close();
  }
  if (!$related) {
    $q = $conn->query("
      SELECT recipe_id, title, slug, main_image_url,
             total_minutes AS total_time, /* alias để không vỡ view cũ */
             difficulty, is_featured, views, created_at
      FROM recipes
      WHERE recipe_id <> {$rid}
      ORDER BY created_at DESC
      LIMIT 6
    ");
    if ($q) $related = $q->fetch_all(MYSQLI_ASSOC);
  }
}

// Categories
$cats = [];
$q = $conn->query("SELECT c.name, c.slug
                   FROM recipe_categories rc
                   JOIN categories c ON c.category_id = rc.category_id
                   WHERE rc.recipe_id = {$rid}");
if ($q) $cats = $q->fetch_all(MYSQLI_ASSOC);

// Ingredients
$ingredients = [];
$q = $conn->query("SELECT name, quantity, unit, note, sort_order
                   FROM recipe_ingredients
                   WHERE recipe_id = {$rid}
                   ORDER BY sort_order ASC, id ASC");
if ($q) $ingredients = $q->fetch_all(MYSQLI_ASSOC);

// Equipment
$equipment = [];
$q = $conn->query("SELECT name, sort_order
                   FROM recipe_equipment
                   WHERE recipe_id={$rid}
                   ORDER BY sort_order ASC, id ASC");
if ($q) $equipment = $q->fetch_all(MYSQLI_ASSOC);

// Instruction sections (no section_body) + steps
$sections = [];
$secRows = [];
$q = $conn->query("SELECT id AS section_id, section_title
                   FROM recipe_instruction_sections
                   WHERE recipe_id = {$rid}
                   ORDER BY sort_order ASC, id ASC");
if ($q) $secRows = $q->fetch_all(MYSQLI_ASSOC);
$sections = [];
$secIds = array_column($secRows, 'section_id');
if ($secIds) {
  $idList = implode(',', array_map('intval', $secIds));
  $steps = [];
  $q2 = $conn->query("SELECT section_id, step_text, sort_order, id
                      FROM recipe_instruction_steps
                      WHERE section_id IN ($idList)
                      ORDER BY section_id ASC, sort_order ASC, id ASC");
  if ($q2) $steps = $q2->fetch_all(MYSQLI_ASSOC);
  // group steps by section_id
  $bySec = [];
  foreach ($steps as $s) {
    $bySec[(int)$s['section_id']][] = $s['step_text'];
  }
  foreach ($secRows as $sr) {
    $sid = (int)$sr['section_id'];
    $sections[] = [
      'section_title' => $sr['section_title'],
      'steps' => $bySec[$sid] ?? []
    ];
  }
}

// Notes (prep/cook/do/dont) từ recipe_notes
$prep_notes = $cook_notes = $do_notes = $dont_notes = [];
$q = $conn->query("SELECT content_type, note_text, sort_order, id
                   FROM recipe_notes
                   WHERE recipe_id = {$rid}
                   ORDER BY FIELD(content_type,'prep','cook','do','dont'), sort_order ASC, id ASC");
if ($q) {
  while ($row = $q->fetch_assoc()) {
    $t = $row['content_type'];
    $txt = trim((string)$row['note_text']);
    if ($txt === '') continue;
    switch ($t) {
      case 'prep':  $prep_notes[]  = $txt; break;
      case 'cook':  $cook_notes[]  = $txt; break;
      case 'do':    $do_notes[]    = $txt; break;
      case 'dont':  $dont_notes[]  = $txt; break;
    }
  }
}

/* ===================== Derived ===================== */
$recipe_title = trim((string)($recipe['title'] ?? ''));

// Title cho body
$page_title = h($recipe_title) . " - Cooks Delight";

// ===== SEO: Meta Title & Description =====
$meta_title = $recipe_title !== ''
  ? ($recipe_title . ' — Cooks Delight')
  : 'Recipe — Cooks Delight';

if (!empty($recipe['meta_description'])) {
  $meta_description = $recipe['meta_description'];
} else {
  $raw = trim((string)($recipe['description'] ?? ''));
  $raw = preg_replace('/\s+/', ' ', $raw);
  $meta_description = $raw !== ''
    ? $raw
    : 'Step-by-step instructions, ingredients, timing and helpful tips for this recipe.';
}

// ===== Canonical URL =====
if (!empty($recipe['slug'])) {
  $canonical_url = BASE_URL . 'recipe.php?slug=' . urlencode($recipe['slug']);
} else {
  $canonical_url = BASE_URL . 'recipe.php?id=' . (int)$recipe['recipe_id'];
}

// === Include header sau khi đã có biến SEO ===
include __DIR__ . '/../app/views/header.php';

// ===== Breadcrumbs for recipe detail =====
$primaryCat = isset($cats[0]) ? $cats[0] : null;
$breadcrumbs = [
  ['label' => 'Home',    'url' => BASE_URL . 'index.php'],
  ['label' => 'Recipes', 'url' => BASE_URL . 'recipes.php'],
];
if ($primaryCat && !empty($primaryCat['slug'])) {
  $catSlug = strtolower($primaryCat['slug']);
  $breadcrumbs[] = [
    'label' => $primaryCat['name'],
    'url'   => BASE_URL . 'recipes.php?cat=' . urlencode($catSlug) . '&q=&sort=newest&page=1',
  ];
}
$breadcrumbs[] = ['label' => $recipe['title'] ?? 'Recipe', 'url' => null];

include dirname(__DIR__) . '/app/views/breadcrumb.php';
?>


<main class="site-main">
  <!-- HERO -->
  <section class="recipe-hero">
    <div class="container hero-grid">
      <div class="hero-left">
        <h1 class="recipe-title"><?= h($recipe['title']) ?></h1>

        <?php if (!empty($cats)): ?>
          <div class="recipe-cats">
            <?php foreach ($cats as $c): ?>
              <span class="chip"><?= h($c['name']) ?></span>
            <?php endforeach; ?>
          </div>
        <?php endif; ?>

        <?php if (!empty($recipe['description'])): ?>
          <?php foreach (split_paragraphs($recipe['description']) as $p): ?>
            <p class="recipe-desc"><?= h($p) ?></p>
          <?php endforeach; ?>
        <?php endif; ?>

        <ul class="meta-list">
          <?php if (($t = fmt_minutes($recipe['prep_minutes'] ?? null))): ?><li><strong>Prep:</strong> <?= h($t) ?></li><?php endif; ?>
          <?php if (($t = fmt_minutes($recipe['cook_minutes'] ?? null))): ?><li><strong>Cook:</strong> <?= h($t) ?></li><?php endif; ?>
          <?php if (($t = fmt_minutes($recipe['total_minutes'] ?? null))): ?><li><strong>Total:</strong> <?= h($t) ?></li><?php endif; ?>
          <li><strong>Difficulty:</strong> <?= h($recipe['difficulty']) ?></li>
          <li><strong>Views:</strong> <?= (int)$recipe['views'] + 1 ?></li>
        </ul>

        <div class="mini-cards">
          <div class="mini-card">
            <div class="mini-title">Ingredients</div>
            <?php if ($ingredients): ?>
              <ul class="mini-list">
                <?php foreach (array_slice($ingredients,0,8) as $ing): ?>
                  <li><?= ingredient_line($ing) ?></li>
                <?php endforeach; ?>
              </ul>
              <a href="#ingredients" class="mini-more">View full list ↓</a>
            <?php else: ?>
              <p class="muted">No ingredients listed.</p>
            <?php endif; ?>
          </div>

          <div class="mini-card">
            <div class="mini-title">Equipment</div>
            <?php if ($equipment): ?>
              <ul class="mini-list">
                <?php foreach (array_slice($equipment,0,6) as $eq): ?>
                  <li><?= h($eq['name']) ?></li>
                <?php endforeach; ?>
              </ul>
            <?php else: ?>
              <p class="muted">No special equipment.</p>
            <?php endif; ?>
          </div>
        </div>
      </div>

      <div class="hero-right">
        <?php if (!empty($recipe['main_image_url'])): ?>
          <img class="hero-img" src="<?= h($recipe['main_image_url']) ?>" alt="<?= h($recipe['title']) ?>">
        <?php endif; ?>
      </div>
    </div>
  </section>

  <!-- MAIN GRID: left text (tips + instructions), right sidebar (stores + video) -->
  <section class="container main-grid">
    <div class="main-left">
      <!-- TIPS -->
      <?php if (!empty($do_notes) || !empty($dont_notes)): ?>
      <section class="tips-block bordered" id="tips">
        <h2 class="tips-heading">Let’s go over the basics — the do’s and don’ts — for <?= h($recipe['title']) ?></h2>

        <?php if (!empty($do_notes)): ?>
          <div class="tips-col">
            <div class="tips-label tips-label--do">DO’S:</div>
            <ul class="tips-list">
              <?php foreach ($do_notes as $line): ?>
                <li><?= h($line) ?></li>
              <?php endforeach; ?>
            </ul>
          </div>
        <?php endif; ?>

        <?php if (!empty($dont_notes)): ?>
          <div class="tips-col">
            <div class="tips-label tips-label--dont">DON’TS:</div>
            <ul class="tips-list">
              <?php foreach ($dont_notes as $line): ?>
                <li><?= h($line) ?></li>
              <?php endforeach; ?>
            </ul>
          </div>
        <?php endif; ?>
      </section>
      <?php endif; ?>

      <!-- INSTRUCTIONS -->
      <section class="instructions bordered" id="instructions">
        <h2 class="instructions-title">INSTRUCTIONS</h2>

        <?php if (!empty($recipe['instructions_intro'])): ?>
          <?php foreach (split_paragraphs($recipe['instructions_intro']) as $p): ?>
            <p class="instructions-intro"><?= h($p) ?></p>
          <?php endforeach; ?>
        <?php endif; ?>

        <?php if (!empty($prep_notes)): ?>
          <h3 class="section-heading accent">PREHEAT AND PREPARE</h3>
          <ul class="section-list">
            <?php foreach ($prep_notes as $line): ?>
              <li><?= h($line) ?></li>
            <?php endforeach; ?>
          </ul>
        <?php endif; ?>

        <?php if (!empty($cook_notes)): ?>
          <h3 class="section-heading accent">COOK</h3>
          <ul class="section-list">
            <?php foreach ($cook_notes as $line): ?>
              <li><?= h($line) ?></li>
            <?php endforeach; ?>
          </ul>
        <?php endif; ?>

        <?php if (!empty($sections)): ?>
          <?php foreach ($sections as $sec): ?>
            <h3 class="section-heading accent"><?= h($sec['section_title']) ?></h3>
            <ul class="section-list">
              <?php foreach ($sec['steps'] as $line): ?>
                <li><?= h($line) ?></li>
              <?php endforeach; ?>
            </ul>
          <?php endforeach; ?>
        <?php endif; ?>
      </section>

      <!-- Full Ingredients section -->
      <section class="ingredients bordered" id="ingredients">
        <h2 class="block-title">Ingredients</h2>
        <?php if ($ingredients): ?>
          <ul class="ingredients-list">
            <?php foreach ($ingredients as $ing): ?>
              <li><?= ingredient_line($ing) ?></li>
            <?php endforeach; ?>
          </ul>
        <?php else: ?>
          <p class="muted">No ingredients listed.</p>
        <?php endif; ?>
      </section>

      <?php if ($equipment): ?>
      <section class="equipment bordered">
        <h2 class="block-title">Equipment</h2>
        <ul class="ingredients-list">
          <?php foreach ($equipment as $eq): ?>
            <li><?= h($eq['name']) ?></li>
          <?php endforeach; ?>
        </ul>
      </section>
      <?php endif; ?>
    </div>

    <!-- Right Sidebar -->
    <aside class="main-right">
      <?php if (!empty($recipe['origin_place']) || !empty($recipe['origin_map_embed_url'])): ?>
        <div class="sidebar-card bordered">
          <h3 class="sidebar-title">Origin</h3>
          <?php if (!empty($recipe['origin_place'])): ?>
            <p class="origin-place"><strong>Region:</strong> <?= h($recipe['origin_place']) ?></p>
          <?php endif; ?>
          <?= embed_origin_map($recipe); ?>
        </div>
      <?php endif; ?>

      <?php if (!empty($recipe['video_url'])): ?>
      <div class="sidebar-card bordered">
        <h3 class="sidebar-title">Video</h3>
        <?= embed_youtube_if_any($recipe['video_url']); ?>
      </div>
      <?php endif; ?>
    </aside>
  </section>

  <?php if (!empty($related)) { ?>
    <?php
      $seen_ids   = [];
      $rendered   = 0;
      $current_id = isset($recipe['recipe_id']) ? (int)$recipe['recipe_id'] : 0;
    ?>
    <section class="container related bordered" id="related">
      <h2 class="block-title">You might also like</h2>
      <div class="cards-grid">
        <?php foreach ($related as $r) {
          if (!isset($r['recipe_id'])) continue;
          $rrid = (int)$r['recipe_id'];
          if ($rrid === $current_id) continue;
          if (isset($seen_ids[$rrid])) continue;
          $seen_ids[$rrid] = true;
          if ($rendered >= 6) break;
          $rendered++;

          $__orig_recipe = $recipe ?? null;
          $recipe = $r;
          include __DIR__ . '/../app/views/recipe_card.php';
          $recipe = $__orig_recipe;
        } ?>
      </div>
    </section>
  <?php } ?>

</main>

<style>
  .container{ max-width: var(--max-width, 1100px); margin:0 auto; padding:0 16px; }
  .muted{ color:#6f6b68; }

  /* HERO */
  .recipe-hero{ background:#f7efe8; padding:28px 0 24px; }
  .hero-grid{ display:grid; grid-template-columns: 1.2fr 1fr; gap:24px; align-items:start; }
  .recipe-title{ font-family:var(--font-heading,'Montserrat',sans-serif); font-size:44px; margin:0 0 10px; }
  .recipe-cats .chip{ display:inline-block; background:#fff; border:1px solid #ddd; border-radius:999px; padding:6px 12px; margin:0 8px 8px 0; font-size:12px; }
  .recipe-desc{ font-size:18px; line-height:1.65; margin:10px 0; color:#4b4745; }
  .meta-list{ display:flex; flex-wrap:wrap; gap:12px; list-style:none; padding:0; margin:16px 0 0; }
  .meta-list li{ background:#fff; border:1px solid #e6e1dc; border-radius:12px; padding:8px 12px; font-size:14px; }

  .hero-img{ width:100%; border-radius:18px; box-shadow:var(--shadow,0 6px 18px rgba(14,14,14,0.06)); }

  /* Mini cards under meta to fill space */
  .mini-cards{ display:grid; grid-template-columns: 1fr 1fr; gap:14px; margin-top:16px; }
  .mini-card{ background:#fff; border:1px solid #e6e1dc; border-radius:14px; padding:12px 14px; }
  .mini-title{ font-weight:800; margin-bottom:8px; color:#35312f; }
  .mini-list{ margin:0; padding-left:16px; display:grid; gap:6px; font-size:14px; }
  .mini-more{ display:inline-block; margin-top:8px; font-size:13px; text-decoration:underline; }

  /* Main grid below */
  .main-grid{ display:grid; grid-template-columns: 3fr 2fr; gap:24px; padding:24px 0 40px; }
  .bordered{ background:#f9f6f2; border:1.5px solid #e3d9d1; border-radius:14px; padding:18px; }

  /* Tips (stacked) */
  .tips-heading{ font-family:var(--font-heading,'Montserrat',sans-serif); font-size:26px; font-weight:800; margin:0 0 12px; }
  .tips-col{ margin-top:6px; }
  .tips-label{ font-weight:900; letter-spacing:.02em; margin:4px 0 6px; }
  .tips-label--do,
  .tips-label--dont{ color:#ff6f48; }
  .tips-list{ margin:0; padding-left:18px; display:grid; gap:8px; }
  .tips-list li{ line-height:1.55; }
  .tips-list li strong{ font-weight:800; }

  /* Instructions */
  .instructions-title{ font-family:var(--font-heading,'Montserrat',sans-serif); font-size:34px; line-height:1; margin:0 0 10px; font-weight:900; letter-spacing:.02em; }
  .instructions-intro{ color:#6f6b68; font-size:16px; margin:8px 0 10px; }
  .section-heading{ margin:18px 0 8px; font-weight:800; text-transform:uppercase; font-size:18px; }
  .section-heading.accent{ color:#ff6f48; }
  .section-list{ margin:0; padding-left:18px; display:grid; gap:8px; }

  /* Ingredients & Equipment */
  .block-title{ font-size:22px; font-weight:900; margin:0 0 10px; }
  .ingredients-list{ margin:0; padding-left:18px; display:grid; gap:8px; }

  .cards-grid{
    display:grid;
    grid-template-columns:repeat(auto-fill, minmax(220px,1fr));
    gap:16px;
  }
  .card{
    display:block;
    background:#fff;
    border:1px solid #e6e1dc;
    border-radius:14px;
    overflow:hidden;
    transition:transform .12s ease, box-shadow .12s ease;
  }
  .card:hover{ transform:translateY(-2px); box-shadow:0 6px 18px rgba(14,14,14,.06); }
  .card .thumb{ aspect-ratio:16/10; background:#f3efe9; }
  .card .thumb img{ width:100%; height:100%; object-fit:cover; display:block; }
  .card .meta{ padding:10px 12px; }
  .card .meta .title{ font-weight:700; line-height:1.3; margin:0 0 4px; color:#35312f; }
  .card .meta .sub{ font-size:13px; color:#6f6b68; display:flex; gap:6px; }

  #related{ margin-top: 12px; }

  /* Sidebar */
  .sidebar-card{ margin-bottom:18px; }
  .sidebar-title{ font-size:18px; font-weight:800; margin:0 0 10px; }
  .map-embed, .video-embed{ width:100%; aspect-ratio:16/9; border-radius:12px; overflow:hidden; background:#eee; }
  .map-embed iframe, .video-embed iframe{ width:100%; height:100%; border:0;}
  .origin-place { margin: 0 0 8px; color:#4b4745; }
  @media (max-width: 980px){
    .hero-grid{ grid-template-columns: 1fr; }
    .main-grid{ grid-template-columns: 1fr; }
    .mini-cards{ grid-template-columns: 1fr; }
  }
</style>

<?php include __DIR__ . '/../app/views/footer.php'; ?>
