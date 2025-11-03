<?php
// app/views/featured_recipe_hero_card.php
// Hiển thị công thức theo kiểu Hero Card (Card 2)

if (!isset($recipe) || !is_array($recipe)) {
    return;
}

$img = !empty($recipe['image']) ? $recipe['image'] : '/public/assets/images/placeholder.png';
$tags = isset($recipe['tags']) && is_array($recipe['tags']) ? $recipe['tags'] : [];
$url = '/recipe.php?id=' . urlencode($recipe['id']);

// Logic để xác định badge (ví dụ: lấy tag đầu tiên)
$badge_text = !empty($tags) ? strtoupper($tags[0]) : 'FEATURED';
$difficulty = $recipe['difficulty'] ?? 'Easy'; // Card 2 có thể không cần difficulty

?>
<article class="featured-hero-card">
    <a href="<?php echo htmlspecialchars($url); ?>" class="card-link">
        <div class="card-image" style="background-image: url('<?php echo htmlspecialchars($img); ?>');">
            <span class="card-badge"><?php echo htmlspecialchars($badge_text); ?></span>
        </div>
        <div class="card-content">
            <h3 class="card-title"><?php echo htmlspecialchars($recipe['title']); ?></h3>
            <p class="card-excerpt"><?php echo htmlspecialchars($recipe['excerpt'] ?? 'A delightful and easy-to-make dish.'); ?></p>
            <div class="card-meta">
                <span class="meta-item cook-time"><?php echo htmlspecialchars($recipe['cook_time'] ?? '—'); ?></span>
                <span class="meta-item servings"><?php echo htmlspecialchars($recipe['servings'] ?? '—'); ?> servings</span>
            </div>
            <span class="btn btn-small">View Recipe</span>
        </div>
    </a>
</article>