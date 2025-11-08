<?php
// /app/controller/recipe_store.php
session_start();
require_once __DIR__ . '/../../config/db.php';

// Để mysqli ném Exception
mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

/** CSRF & Auth */
if ($_SERVER['REQUEST_METHOD'] !== 'POST') { http_response_code(405); exit('Method Not Allowed'); }
if (empty($_SESSION['user_id'])) { header('Location: /Individual_website/project/public/login.php'); exit; }
if (empty($_POST['csrf']) || $_POST['csrf'] !== ($_SESSION['csrf'] ?? '')) { http_response_code(400); exit('Bad CSRF'); }

/** Helper: tách dòng & làm sạch bullet/đánh số ở đầu */
function split_lines(?string $text): array {
  if ($text === null) return [];
  $lines = preg_split('/\R/u', $text);
  $out = [];
  foreach ($lines as $ln) {
    $ln = trim($ln);
    if ($ln === '') continue;
    // gỡ bullet/số đầu dòng
    $ln = preg_replace('/^\s*(?:[\x{2022}\x{00B7}\x{2023}\x{25CF}\-\*\x{2013}\x{2014}]|\d+[.)])\s*/u', '', $ln);
    $out[] = $ln;
  }
  return $out;
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

// ĐÚNG schema mới: *_minutes
$prep_minutes  = ($_POST['prep_minutes']  ?? '') !== '' ? (int)$_POST['prep_minutes']  : null;
$cook_minutes  = ($_POST['cook_minutes']  ?? '') !== '' ? (int)$_POST['cook_minutes']  : null;
$total_minutes = ($_POST['total_minutes'] ?? '') !== '' ? (int)$_POST['total_minutes'] : null;

$difficulty         = $_POST['difficulty']          ?? 'easy';
$is_featured        = isset($_POST['is_featured']) ? (int)$_POST['is_featured'] : 0;
$instructions_intro = $_POST['instructions_intro']  ?? null;

$video_url          = $_POST['video_url']           ?? null;
$origin_place       = $_POST['origin_place']        ?? null;
$origin_zoom        = (isset($_POST['origin_zoom']) && $_POST['origin_zoom'] !== '') ? (int)$_POST['origin_zoom'] : null;
$origin_map_embed_url = $_POST['origin_map_embed_url'] ?? null;

// Mảng form
$category_ids = array_map('intval', $_POST['category_ids'] ?? []);
$ingredients  = $_POST['ing'] ?? [];
$equipment    = $_POST['eq']  ?? [];
$sections     = $_POST['sec'] ?? [];
$notes        = $_POST['notes'] ?? []; // notes[prep|cook|do|dont][i][note_text]

$conn->begin_transaction();

try {
  // ---------- Insert recipes ----------
  $sql = "INSERT INTO recipes
    (user_id, title, slug, description, meta_description, keywords,
     main_image_url, prep_minutes, cook_minutes, total_minutes,
     difficulty, is_featured,
     instructions_intro, video_url, origin_place, origin_zoom, origin_map_embed_url)
    VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
  $stmt = $conn->prepare($sql);
  // types: i s s s s s s i i i s i s s s i s
  $stmt->bind_param(
    'issssssiiisisssis',
    $user_id,
    $title, $slug, $description, $meta_description, $keywords,
    $main_image_url, $prep_minutes, $cook_minutes, $total_minutes,
    $difficulty, $is_featured,
    $instructions_intro, $video_url, $origin_place, $origin_zoom, $origin_map_embed_url
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

  // ---------- recipe_instruction_sections + steps ----------
  if (!empty($sections)) {
    $stmtSec = $conn->prepare("INSERT INTO recipe_instruction_sections (recipe_id, section_title, sort_order) VALUES (?,?,?)");
    $stmtStp = $conn->prepare("INSERT INTO recipe_instruction_steps (section_id, step_text, sort_order) VALUES (?,?,?)");

    foreach ($sections as $row) {
      $titleSec = trim($row['section_title'] ?? '');
      $body     = trim($row['section_body'] ?? '');
      if ($titleSec === '') continue;

      $sortSec = isset($row['sort_order']) ? (int)$row['sort_order'] : 0;
      $stmtSec->bind_param('isi', $recipe_id, $titleSec, $sortSec);
      $stmtSec->execute();
      $section_id = $stmtSec->insert_id;

      // tách body -> steps theo dòng
      $steps = split_lines($body);
      $order = 1;
      foreach ($steps as $stepText) {
        $sortOrder = $order;   
        $stmtStp->bind_param('isi', $section_id, $stepText, $sortOrder);
        $stmtStp->execute();
        $order++;              // tăng sau khi execute
      }
    }
    $stmtSec->close();
    $stmtStp->close();
  }

  // ---------- recipe_notes (prep/cook/do/dont) ----------
  if (!empty($notes) && is_array($notes)) {
    $stmt = $conn->prepare("INSERT INTO recipe_notes (recipe_id, content_type, note_text, sort_order) VALUES (?,?,?,?)");
    foreach (['prep','cook','do','dont'] as $type) {
      if (empty($notes[$type]) || !is_array($notes[$type])) continue;
      foreach ($notes[$type] as $row) {
        $txt  = trim($row['note_text'] ?? '');
        if ($txt === '') continue;
        $sort = isset($row['sort_order']) ? (int)$row['sort_order'] : 0;
        $stmt->bind_param('issi', $recipe_id, $type, $txt, $sort);
        $stmt->execute();
      }
    }
    $stmt->close();
  }

  // OK
  $conn->commit();
  header('Location: /Individual_website/project/public/recipe.php?slug=' . urlencode($slug));
  exit;

} catch (Throwable $e) {
  $conn->rollback();
  http_response_code(500);
  echo "Insert failed: " . htmlspecialchars($e->getMessage());
  exit;
}
