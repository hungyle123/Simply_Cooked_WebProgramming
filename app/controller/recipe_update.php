<?php
// project/app/controller/recipe_update.php
if (session_status() === PHP_SESSION_NONE) session_start();
require_once __DIR__ . '/../../config/db.php';
mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

// ---- Only admin ----
function require_admin_or_block(mysqli $conn) {
  if (empty($_SESSION['user_id'])) { header('Location: /Individual_website/project/public/login.php'); exit; }
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

// ---- Inputs ----
$recipe_id        = (int)($_POST['recipe_id'] ?? 0);
$title            = trim($_POST['title'] ?? '');
$slug             = trim($_POST['slug'] ?? '');
$description      = $_POST['description'] ?? null;
$meta_description = $_POST['meta_description'] ?? null;
$difficulty       = $_POST['difficulty'] ?? 'easy';
$is_featured      = isset($_POST['is_featured']) ? (int)$_POST['is_featured'] : 0;

if ($recipe_id <= 0 || $title === '' || $slug === '') {
  http_response_code(400); exit('Missing required fields');
}

// ---- Transaction ----
$conn->begin_transaction();
try {
  // 1) Check recipe exists
  $stmt = $conn->prepare("SELECT recipe_id FROM recipes WHERE recipe_id = ? LIMIT 1");
  $stmt->bind_param('i', $recipe_id);
  $stmt->execute();
  $exists = $stmt->get_result()->fetch_assoc();
  $stmt->close();
  if (!$exists) { throw new RuntimeException('Recipe not found'); }

  // 2) Unique slug (exclude current recipe)
  $stmt = $conn->prepare("SELECT recipe_id FROM recipes WHERE slug = ? AND recipe_id <> ? LIMIT 1");
  $stmt->bind_param('si', $slug, $recipe_id);
  $stmt->execute();
  if ($stmt->get_result()->fetch_assoc()) {
    $stmt->close();
    throw new RuntimeException('Slug already exists');
  }
  $stmt->close();

  // 3) Update core fields (không động tới user_id ở bước này)
  $stmt = $conn->prepare("
    UPDATE recipes
       SET title = ?, slug = ?, description = ?, meta_description = ?,
           difficulty = ?, is_featured = ?, updated_at = NOW()
     WHERE recipe_id = ? LIMIT 1
  ");
  $stmt->bind_param(
    'ssssssi',
    $title, $slug, $description, $meta_description,
    $difficulty, $is_featured, $recipe_id
  );
  $stmt->execute();
  $stmt->close();

  $conn->commit();

  // Quay lại danh sách
  header('Location: /Individual_website/project/public/index.php?page=admin_edit_recipes&ok=1');
  exit;

} catch (Throwable $e) {
  $conn->rollback();
  http_response_code(500);
  echo "Update failed: " . htmlspecialchars($e->getMessage());
  exit;
}
