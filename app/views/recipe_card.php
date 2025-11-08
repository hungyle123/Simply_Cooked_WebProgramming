<?php
// vẫn giữ đoạn bảo vệ biến nếu bạn đang truyền $r
if (!isset($recipe) && isset($r)) { $recipe = $r; }

if (!function_exists('fmt_minutes_card')) {
  function fmt_minutes_card($m) {
    if ($m === null || $m === '' ) return null;
    $m = (int)$m;
    if ($m < 60) return $m . ' mins';
    $h = intdiv($m, 60);
    $r = $m % 60;
    return $r ? "{$h}h {$r}m" : "{$h}h";
  }
}

$slug   = htmlspecialchars($recipe['slug']);
$title  = htmlspecialchars($recipe['title']);
$img    = htmlspecialchars($recipe['main_image_url'] ?? '');
$desc   = htmlspecialchars($recipe['meta_description'] ?? '');
?>
<div class="recipe-card">
  <div class="recipe-card-media">
    <img class="recipe-card-img" src="<?php echo $img; ?>" alt="<?php echo $title; ?>" loading="lazy">
    <?php if (!empty($recipe['is_featured'])): ?>
      <span class="badge-pill badge-orange">CHEF PICK</span>
    <?php endif; ?>
  </div>

  <div class="recipe-card-body">
    <h3 class="recipe-card-title">
      <a class="recipe-card-link" href="recipe.php?slug=<?php echo $slug; ?>">
        <?php echo $title; ?>
      </a>
    </h3>
    <p class="recipe-card-desc"><?php echo $desc; ?></p>

    <div class="recipe-card-meta">
      <?php if (!empty($recipe['total_minutes'])): ?>
        <span><?php echo htmlspecialchars(fmt_minutes_card($recipe['total_minutes'])); ?></span>
      <?php endif; ?>
      <?php if (!empty($recipe['prep_minutes'])): ?>
        <span><?php echo htmlspecialchars(fmt_minutes_card($recipe['prep_minutes'])); ?> PREP</span>
      <?php endif; ?>
      <?php if (!empty($recipe['cook_minutes'])): ?>
        <span><?php echo htmlspecialchars(fmt_minutes_card($recipe['cook_minutes'])); ?> COOK</span>
      <?php endif; ?>
    </div>

    <a class="btn-view" href="recipe.php?slug=<?php echo $slug; ?>">VIEW RECIPE</a>
  </div>
</div>
