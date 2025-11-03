<?php
// recipe_card.php
if (!isset($recipe) || !is_array($recipe)) {
    return;
}

$show_button = $show_button ?? true;
$img = !empty($recipe['image']) ? $recipe['image'] : '/public/assets/images/placeholder.png';
$tags = isset($recipe['tags']) && is_array($recipe['tags']) ? $recipe['tags'] : [];
?>
<article class="recipe-card">
  <a href="/recipe.php?id=<?php echo urlencode($recipe['id']); ?>" class="recipe-link">
    <div class="recipe-media">
      <img src="<?php echo htmlspecialchars($img); ?>" alt="<?php echo htmlspecialchars($recipe['title']); ?>">
      <?php if(in_array('vegan', $tags)): ?>
        <span class="badge badge-top">VEGAN</span>
      <?php endif; ?>
    </div>

    <div class="recipe-body">
      <h3 class="recipe-title"><?php echo htmlspecialchars($recipe['title']); ?></h3>
      <p class="recipe-excerpt"><?php echo htmlspecialchars($recipe['excerpt'] ?? ''); ?></p>

      <div class="recipe-meta">
        <span class="meta-item"><?php echo htmlspecialchars($recipe['cook_time'] ?? '—'); ?></span>
        <span class="meta-item"><?php echo htmlspecialchars($recipe['difficulty'] ?? ''); ?></span>
        <span class="meta-item"><?php echo htmlspecialchars($recipe['servings'] ?? ''); ?></span>
      </div>

      <?php if ($show_button): ?>
        <div class="recipe-cta">
          <a class="btn btn-small" href="/recipe.php?id=<?php echo urlencode($recipe['id']); ?>">View Recipe</a>
        </div>
      <?php endif; ?>
    </div>
  </a>
</article>
