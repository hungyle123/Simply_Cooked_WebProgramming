<?php
// /app/controller/recipe_store.php
session_start();
require_once __DIR__ . '/../../config/db.php';

// Để mysqli ném Exception (dễ try/catch hơn)
mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

/** CSRF & Auth */
if ($_SERVER['REQUEST_METHOD'] !== 'POST') { http_response_code(405); exit('Method Not Allowed'); }
if (empty($_SESSION['user_id'])) { header('Location: /Individual_website/project/public/login.php'); exit; }
if (empty($_POST['csrf']) || $_POST['csrf'] !== ($_SESSION['csrf'] ?? '')) { http_response_code(400); exit('Bad CSRF'); }

/** Helper: chuẩn hoá bullet (mỗi dòng -> "• ...") */
function normalize_bullets(?string $text): ?string {
  if ($text === null) return null;
  $lines = preg_split('/\R/u', $text);
  $out = [];
  foreach ($lines as $ln) {
    $ln = trim($ln);
    if ($ln === '') continue;
    // gỡ bullet/số có sẵn ở đầu để tránh double
    $ln = preg_replace('/^\s*(?:[\x{2022}\x{00B7}\x{2023}\x{25CF}\-\*\x{2013}\x{2014}]|\d+[.)])\s*/u', '', $ln);
    $out[] = '• ' . $ln;
  }
  return $out ? implode("\n", $out) : null;
}

/** Input chính */
$user_id = (int)$_SESSION['user_id'];

$title = trim($_POST['title'] ?? '');
$slug  = trim($_POST['slug'] ?? '');
if ($title === '' || $slug === '') { http_response_code(400); exit('Title/Slug required'); }

$description        = $_POST['description']         ?? null;
$meta_description   = $_POST['meta_description']    ?? null;
$keywords           = $_POST['keywords']            ?? null;
$main_image_url     = $_POST['main_image_url']      ?? null;
$prep_time          = $_POST['prep_time']           ?? null;
$cook_time          = $_POST['cook_time']           ?? null;
$total_time         = $_POST['total_time']          ?? null;
$difficulty         = $_POST['difficulty']          ?? 'easy';
$is_featured        = isset($_POST['is_featured']) ? (int)$_POST['is_featured'] : 0;
$instructions_intro = $_POST['instructions_intro']  ?? null;
$instructions       = $_POST['instructions']        ?? '';
$prep_instructions  = $_POST['prep_instructions']   ?? null;
$cook_instructions  = $_POST['cook_instructions']   ?? null;
$do_tips            = normalize_bullets($_POST['do_tips']   ?? null);
$dont_tips          = normalize_bullets($_POST['dont_tips'] ?? null);
$video_url          = $_POST['video_url']           ?? null;
$origin_place       = $_POST['origin_place']        ?? null;
$origin_zoom        = (isset($_POST['origin_zoom']) && $_POST['origin_zoom'] !== '') ? (int)$_POST['origin_zoom'] : null;
$origin_map_embed_url = $_POST['origin_map_embed_url'] ?? null;

$category_ids = array_map('intval', $_POST['category_ids'] ?? []);
$ingredients  = $_POST['ing'] ?? [];
$equipment    = $_POST['eq']  ?? [];
$sections     = $_POST['sec'] ?? [];

$conn->begin_transaction();

try {
  // ---------- Insert recipes ----------
  $sql = "INSERT INTO recipes
    (user_id, title, slug, description, meta_description, keywords,
     main_image_url, prep_time, cook_time, total_time,
     difficulty, is_featured,
     instructions_intro, instructions, prep_instructions, cook_instructions,
     do_tips, dont_tips, video_url, origin_place, origin_zoom, origin_map_embed_url)
    VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
  $stmt = $conn->prepare($sql);
  // types: i + 10s + i + 8s + i + s = 'issssssssssissssssssis'
  $stmt->bind_param(
    'issssssssssissssssssis',
    $user_id,
    $title, $slug, $description, $meta_description, $keywords,
    $main_image_url, $prep_time, $cook_time, $total_time,
    $difficulty, $is_featured,
    $instructions_intro, $instructions, $prep_instructions, $cook_instructions,
    $do_tips, $dont_tips, $video_url, $origin_place, $origin_zoom, $origin_map_embed_url
  );
  $stmt->execute();
  $recipe_id = $stmt->insert_id;
  $stmt->close();

  // ---------- recipe_categories ----------
  if (!empty($category_ids)) {
    $stmt = $conn->prepare("INSERT IGNORE INTO recipe_categories (recipe_id, category_id) VALUES (?,?)");
    foreach ($category_ids as $cid) {
      if ($cid > 0) {
        $stmt->bind_param('ii', $recipe_id, $cid);
        $stmt->execute();
      }
    }
    $stmt->close();
  }

  // ---------- recipe_ingredients ----------
  if (!empty($ingredients)) {
    $stmt = $conn->prepare("INSERT INTO recipe_ingredients
      (recipe_id, name, quantity, unit, note, sort_order)
      VALUES (?,?,?,?,?,?)");
    foreach ($ingredients as $row) {
      $name = trim($row['name'] ?? '');
      if ($name === '') continue;
      $quantity = $row['quantity'] ?? null;
      $unit     = $row['unit'] ?? null;
      $note     = $row['note'] ?? null;
      $sort     = isset($row['sort_order']) ? (int)$row['sort_order'] : 0;
      $stmt->bind_param('issssi', $recipe_id, $name, $quantity, $unit, $note, $sort);
      $stmt->execute();
    }
    $stmt->close();
  }

  // ---------- recipe_equipment ----------
  if (!empty($equipment)) {
    $stmt = $conn->prepare("INSERT INTO recipe_equipment (recipe_id, name, sort_order) VALUES (?,?,?)");
    foreach ($equipment as $row) {
      $name = trim($row['name'] ?? '');
      if ($name === '') continue;
      $sort = isset($row['sort_order']) ? (int)$row['sort_order'] : 0;
      $stmt->bind_param('isi', $recipe_id, $name, $sort);
      $stmt->execute();
    }
    $stmt->close();
  }

  // ---------- recipe_instruction_sections ----------
  if (!empty($sections)) {
    $stmt = $conn->prepare("INSERT INTO recipe_instruction_sections
      (recipe_id, section_title, section_body, sort_order)
      VALUES (?,?,?,?)");
    foreach ($sections as $row) {
      $t = trim($row['section_title'] ?? '');
      $b = trim($row['section_body'] ?? '');
      if ($t === '' || $b === '') continue;
      $s = isset($row['sort_order']) ? (int)$row['sort_order'] : 0;
      $stmt->bind_param('issi', $recipe_id, $t, $b, $s);
      $stmt->execute();
    }
    $stmt->close();
  }

  // OK
  $conn->commit();
  header('Location: /Individual_website/project/public/recipe.php?slug=' . urlencode($slug));
  exit;

} catch (Throwable $e) {
  // luôn còn trong khối try/catch -> không còn lỗi "unexpected $conn"
  $conn->rollback();
  http_response_code(500);
  echo "Insert failed: " . htmlspecialchars($e->getMessage());
  exit;
}
