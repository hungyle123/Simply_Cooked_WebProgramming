<?php
// project/app/controller/recipe_update.php
if (session_status() === PHP_SESSION_NONE) session_start();
require_once __DIR__ . '/../../config/db.php';
mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

// ---- Only admin ----
function require_admin_or_block(mysqli $conn) {
  if (empty($_SESSION['user_id'])) {
    header('Location: /Individual_website/project/public/login.php');
    exit;
  }
  $role = $_SESSION['user']['role'] ?? null;
  if (!$role) {
    $uid = (int)$_SESSION['user_id'];
    $res = $conn->query("SELECT role FROM users WHERE user_id = {$uid} LIMIT 1");
    $row = $res->fetch_assoc();
    $role = $row['role'] ?? 'user';
    $_SESSION['user']['role'] = $role;
  }
  if ($role !== 'admin') { http_response_code(403); exit('Forbidden'); }
}
require_admin_or_block($conn);

// ---- Only POST + CSRF ----
if ($_SERVER['REQUEST_METHOD'] !== 'POST') { http_response_code(405); exit('Method Not Allowed'); }
if (empty($_POST['csrf']) || ($_SESSION['csrf'] ?? '') !== $_POST['csrf']) { http_response_code(400); exit('Bad CSRF'); }

// ---- Helpers ----
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
function posted(string $k): bool { return array_key_exists($k, $_POST); }
function null_if_empty(?string $v) { return ($v === '' ? null : $v); }

// ---- Inputs thô ----
$recipe_id = (int)($_POST['recipe_id'] ?? 0);
if ($recipe_id <= 0) { http_response_code(400); exit('Missing recipe_id'); }

// Các nhóm mảng (nếu gửi thì mới replace)
$category_ids = isset($_POST['category_ids']) ? array_map('intval', (array)$_POST['category_ids']) : null;
$ingredients  = $_POST['ing']  ?? null;   // null = không đụng; array = replace
$equipment    = $_POST['eq']   ?? null;   // null = không đụng; array = replace
$sections     = $_POST['sec']  ?? null;   // null = không đụng; array = replace
$notes        = $_POST['notes'] ?? null;  // notes[prep|cook|do|dont][i][note_text]

// ---- Bắt đầu giao dịch ----
$conn->begin_transaction();
try {
  // 1) Tải bản ghi hiện tại để giữ lại các field không post
  $stmt = $conn->prepare("
    SELECT recipe_id, title, slug, description, meta_description, keywords,
           main_image_url, prep_minutes, cook_minutes, total_minutes,
           difficulty, is_featured, instructions_intro, video_url,
           origin_place, origin_zoom, origin_map_embed_url
    FROM recipes WHERE recipe_id = ? LIMIT 1
  ");
  $stmt->bind_param('i', $recipe_id);
  $stmt->execute();
  $cur = $stmt->get_result()->fetch_assoc();
  $stmt->close();
  if (!$cur) { throw new RuntimeException('Recipe not found'); }

  // 2) Lấy/giữ giá trị cho từng field
  $title            = posted('title')            ? trim($_POST['title'])               : $cur['title'];
  $slug             = posted('slug')             ? trim($_POST['slug'])                : $cur['slug'];
  $description      = posted('description')      ? $_POST['description']               : $cur['description'];
  $meta_description = posted('meta_description') ? $_POST['meta_description']          : $cur['meta_description'];
  $keywords         = posted('keywords')         ? $_POST['keywords']                  : $cur['keywords'];
  $main_image_url   = posted('main_image_url')   ? null_if_empty($_POST['main_image_url']) : $cur['main_image_url'];

  $prep_minutes     = posted('prep_minutes')  ? (($_POST['prep_minutes']  === '') ? null : (int)$_POST['prep_minutes'])  : ($cur['prep_minutes']  === null ? null : (int)$cur['prep_minutes']);
  $cook_minutes     = posted('cook_minutes')  ? (($_POST['cook_minutes']  === '') ? null : (int)$_POST['cook_minutes'])  : ($cur['cook_minutes']  === null ? null : (int)$cur['cook_minutes']);
  $total_minutes    = posted('total_minutes') ? (($_POST['total_minutes'] === '') ? null : (int)$_POST['total_minutes']) : ($cur['total_minutes'] === null ? null : (int)$cur['total_minutes']);

  $difficulty       = posted('difficulty')  ? $_POST['difficulty']               : $cur['difficulty'];
  $is_featured      = posted('is_featured') ? (int)$_POST['is_featured']         : (int)$cur['is_featured'];

  $instructions_intro   = posted('instructions_intro')   ? $_POST['instructions_intro']        : $cur['instructions_intro'];
  $video_url            = posted('video_url')            ? null_if_empty($_POST['video_url'])  : $cur['video_url'];
  $origin_place         = posted('origin_place')         ? $_POST['origin_place']              : $cur['origin_place'];
  $origin_zoom          = posted('origin_zoom')          ? (($_POST['origin_zoom'] === '') ? null : (int)$_POST['origin_zoom']) : ($cur['origin_zoom'] === null ? null : (int)$cur['origin_zoom']);
  $origin_map_embed_url = posted('origin_map_embed_url') ? null_if_empty($_POST['origin_map_embed_url']) : $cur['origin_map_embed_url'];

  // 3) Unique slug (exclude current recipe)
  if ($slug === '') { throw new RuntimeException('Slug is required'); }
  $stmt = $conn->prepare("SELECT recipe_id FROM recipes WHERE slug = ? AND recipe_id <> ? LIMIT 1");
  $stmt->bind_param('si', $slug, $recipe_id);
  $stmt->execute();
  if ($stmt->get_result()->fetch_assoc()) {
    $stmt->close();
    throw new RuntimeException('Slug already exists');
  }
  $stmt->close();

  // 4) Update core fields (KHỚP SCHEMA MỚI) — không đụng updated_at nếu cột không tồn tại
  $stmt = $conn->prepare("
    UPDATE recipes
       SET title = ?, slug = ?, description = ?, meta_description = ?, keywords = ?,
           main_image_url = ?, prep_minutes = ?, cook_minutes = ?, total_minutes = ?,
           difficulty = ?, is_featured = ?,
           instructions_intro = ?, video_url = ?, origin_place = ?, origin_zoom = ?, origin_map_embed_url = ?
     WHERE recipe_id = ? LIMIT 1
  ");
  // types: ssssss ii i s i s s s i s i  => tổng 17 tham số
  $stmt->bind_param(
    'ssssssiiisisssisi',
    $title, $slug, $description, $meta_description, $keywords,
    $main_image_url, $prep_minutes, $cook_minutes, $total_minutes,
    $difficulty, $is_featured,
    $instructions_intro, $video_url, $origin_place, $origin_zoom, $origin_map_embed_url,
    $recipe_id
  );
  $stmt->execute();
  $stmt->close();

  // 5) Categories — chỉ replace khi form gửi category_ids
  if ($category_ids !== null) {
    $stmt = $conn->prepare("DELETE FROM recipe_categories WHERE recipe_id = ?");
    $stmt->bind_param('i', $recipe_id);
    $stmt->execute();
    $stmt->close();

    if (!empty($category_ids)) {
      $stmt = $conn->prepare("INSERT IGNORE INTO recipe_categories (recipe_id, category_id) VALUES (?,?)");
      foreach ($category_ids as $cid) {
        if ($cid > 0) { $stmt->bind_param('ii', $recipe_id, $cid); $stmt->execute(); }
      }
      $stmt->close();
    }
  }

  // 6) Ingredients — replace nếu form gửi mảng ing
  if (is_array($ingredients)) {
    $stmt = $conn->prepare("DELETE FROM recipe_ingredients WHERE recipe_id = ?");
    $stmt->bind_param('i', $recipe_id);
    $stmt->execute();
    $stmt->close();

    if (!empty($ingredients)) {
      $stmt = $conn->prepare("INSERT INTO recipe_ingredients (recipe_id, name, quantity, unit, note, sort_order) VALUES (?,?,?,?,?,?)");
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
  }

  // 7) Equipment — replace nếu form gửi mảng eq
  if (is_array($equipment)) {
    $stmt = $conn->prepare("DELETE FROM recipe_equipment WHERE recipe_id = ?");
    $stmt->bind_param('i', $recipe_id);
    $stmt->execute();
    $stmt->close();

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
  }

  // 8) Instruction sections + steps — replace nếu form gửi mảng sec
  if (is_array($sections)) {
    // xóa cũ (steps phụ thuộc sections ON DELETE CASCADE)
    $stmt = $conn->prepare("DELETE FROM recipe_instruction_sections WHERE recipe_id = ?");
    $stmt->bind_param('i', $recipe_id);
    $stmt->execute();
    $stmt->close();

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

        $steps = split_lines($body);
        $order = 1;
        foreach ($steps as $stepText) {
          $stmtStp->bind_param('isi', $section_id, $stepText, $order++);
          $stmtStp->execute();
        }
      }
      $stmtSec->close();
      $stmtStp->close();
    }
  }

  // 9) Notes (prep/cook/do/dont) — replace nếu form gửi mảng notes
  if (is_array($notes)) {
    $stmt = $conn->prepare("DELETE FROM recipe_notes WHERE recipe_id = ?");
    $stmt->bind_param('i', $recipe_id);
    $stmt->execute();
    $stmt->close();

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

  // 10) Commit
  $conn->commit();

  // Quay lại trang quản trị
  header('Location: /Individual_website/project/public/index.php?page=admin_edit_recipes&ok=1');
  exit;

} catch (Throwable $e) {
  $conn->rollback();
  http_response_code(500);
  echo "Update failed: " . htmlspecialchars($e->getMessage());
  exit;
}
