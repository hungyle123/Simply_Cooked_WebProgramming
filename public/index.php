<?php
$page_title = 'Simple Cooked - Home';
$active = 'home';

include __DIR__ . '/../config/db.php';

$route = $_GET['route'] ?? '';
if ($route === 'ajax.search') {
  require_once __DIR__ . '/../app/controller/search_controller.php';
  search_recipes_json($conn);
  exit;
}
include __DIR__ . '/../app/views/header.php';
include __DIR__ . '/../app/function/recipe_functions.php';

// lấy category từ URL (nếu có)
$categorySlug = isset($_GET['cat']) ? $_GET['cat'] : null;

// gọi hàm lấy dữ liệu
$recipes_home = get_recipes_for_home($conn, 12, $categorySlug);
?>

<div class="container">
  <?php include __DIR__ . '/../app/views/hero.php'; ?>

  <?php include __DIR__ . '/../app/views/palette-section.php'; ?>

  <?php 
    include __DIR__ . '/../app/views/receipt_section.php';  // Views mới
  ?>

  <?php include __DIR__ . '/../app/views/about-section.php'; ?>

  <?php include __DIR__ . '/../app/views/subscribe_cta.php'; ?>
</div>

<?php include __DIR__ . '/../app/views/footer.php'; ?>
