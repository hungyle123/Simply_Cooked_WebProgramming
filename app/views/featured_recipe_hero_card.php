<?php
// app/views/featured_recipe_hero_card.php
// Hiển thị công thức theo kiểu Hero Card (Card 2)

if (!isset($recipe) || !is_array($recipe)) {
    return;
}

// Ảnh: ưu tiên main_image_url theo schema mới
$img = trim($recipe['main_image_url'] ?? '');
if ($img === '') {
    // fallback placeholder
    $img = '/public/assets/images/placeholder.png';
} else {
    // nếu đường dẫn bắt đầu bằng "/images/" thì bỏ dấu "/" đầu cho thống nhất asset nội bộ
    if (strpos($img, '/images/') === 0) {
        $img = ltrim($img, '/');
    }
}

$tags = isset($recipe['tags']) && is_array($recipe['tags']) ? $recipe['tags'] : [];
$url  = '/recipe.php?id=' . urlencode($recipe['id'] ?? $recipe['recipe_id'] ?? '');

// Badge: lấy tag đầu tiên nếu có, không thì 'FEATURED'
$badge_text = !empty($tags) ? strtoupper((string)$tags[0]) : 'FEATURED';

// Difficulty: lấy từ DB (schema mới có cột difficulty), fallback 'Easy'
$difficulty = $recipe['difficulty'] ?? 'Easy';

// Time display:
// - Nếu controller đã set 'time_display' (ví dụ "25 min") thì dùng luôn
// - Nếu chưa có, tự suy ra từ total_minutes -> cook_minutes -> prep_minutes
$time_display = $recipe['time_display'] ?? null;
if ($time_display === null || $time_display === '') {
    $minutes = null;
    if (!empty($recipe['total_minutes'])) {
        $minutes = (int)$recipe['total_minutes'];
    } elseif (!empty($recipe['cook_minutes'])) {
        $minutes = (int)$recipe['cook_minutes'];
    } elseif (!empty($recipe['prep_minutes'])) {
        $minutes = (int)$recipe['prep_minutes'];
    }
    $time_display = ($minutes !== null && $minutes > 0) ? ($minutes . ' min') : '—';
}

// Excerpt: ưu tiên meta_description đã map sẵn vào $recipe['excerpt']
$excerpt = $recipe['excerpt'] ?? ('Discover ' . ($recipe['title'] ?? ''));

?>
<article class="featured-hero-card">
    <a href="<?php echo htmlspecialchars($url); ?>" class="card-link">
        <div class="card-image" style="background-image: url('<?php echo htmlspecialchars($img); ?>');">
            <span class="card-badge"><?php echo htmlspecialchars($badge_text); ?></span>
        </div>
        <div class="card-content">
            <h3 class="card-title"><?php echo htmlspecialchars($recipe['title'] ?? ''); ?></h3>
            <p class="card-excerpt"><?php echo htmlspecialchars($excerpt); ?></p>
            <div class="card-meta">
                <span class="meta-item cook-time"><?php echo htmlspecialchars($time_display); ?></span>
                <span class="meta-item difficulty"><?php echo htmlspecialchars($difficulty); ?></span>
            </div>
            <span class="btn btn-small">View Recipe</span>
        </div>
    </a>
</article>
