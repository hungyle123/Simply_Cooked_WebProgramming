<?php
// /public/sitemap.xml.php
require_once __DIR__ . '/../config/db.php'; // dùng $conn + BASE_URL (đã có) :contentReference[oaicite:0]{index=0}
header('Content-Type: application/xml; charset=utf-8');

// Helper
function x($s){ return htmlspecialchars($s, ENT_QUOTES, 'UTF-8'); }
function iso8601($ts){ return date('c', strtotime($ts)); }

// 1) Static pages
$urls = [];
$now = date('c');
$base = rtrim(BASE_URL, '/').'/'; // ví dụ http://localhost/Individual_website/project/public/ :contentReference[oaicite:1]{index=1}
$urls[] = [$base.'index.php', $now];
$urls[] = [$base.'recipes.php', $now];
$urls[] = [$base.'aboutus.php', $now];
$urls[] = [$base.'contact.php', $now];

// 2) Category listings (nếu có)
$cats = [];
$res = $conn->query("SELECT slug FROM categories ORDER BY name ASC");
if ($res) { while($c = $res->fetch_assoc()) $cats[] = strtolower($c['slug']); }
foreach ($cats as $slug) {
  $urls[] = [$base.'recipes.php?cat='.rawurlencode($slug), $now];
}

// 3) Recipe detail URLs (ưu tiên slug; lấy lastmod từ updated_at hoặc created_at)
// (schema có cột updated_at trong bảng recipes) :contentReference[oaicite:2]{index=2}
$sql = "SELECT slug, recipe_id, COALESCE(updated_at, created_at) AS lastmod
        FROM recipes ORDER BY recipe_id DESC";
if ($rs = $conn->query($sql)) {
  while ($r = $rs->fetch_assoc()) {
    $loc = !empty($r['slug'])
      ? $base.'recipe.php?slug='.rawurlencode($r['slug'])
      : $base.'recipe.php?id='.(int)$r['recipe_id'];
    $urls[] = [$loc, $r['lastmod'] ?: $now];
  }
}

echo '<?xml version="1.0" encoding="UTF-8"?>'."\n";
?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
<?php foreach ($urls as [$loc,$last]): ?>
  <url>
    <loc><?= x($loc) ?></loc>
    <lastmod><?= x(iso8601($last)) ?></lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>
<?php endforeach; ?>
</urlset>
