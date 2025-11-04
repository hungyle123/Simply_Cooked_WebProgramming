<?php
// vẫn giữ đoạn bảo vệ biến nếu bạn đang truyền $r
if (!isset($recipe) && isset($r)) { $recipe = $r; }
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
      <?php if (!empty($recipe['total_time'])): ?><span><?php echo htmlspecialchars($recipe['total_time']); ?></span><?php endif; ?>
      <?php if (!empty($recipe['prep_time'])): ?><span><?php echo htmlspecialchars($recipe['prep_time']); ?> PREP</span><?php endif; ?>
      <?php if (!empty($recipe['servings'])): ?><span><?php echo htmlspecialchars($recipe['servings']); ?></span><?php endif; ?>
    </div>

    <a class="btn-view" href="recipe.php?slug=<?php echo $slug; ?>">VIEW RECIPE</a>
  </div>
</div>
