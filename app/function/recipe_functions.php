<?php
function get_recipes_for_home(mysqli $conn, $limit = 12, $categorySlug = null) {
    $recipes = [];

    if ($categorySlug) {
        // Lọc theo category slug (many-to-many)
        $sql = "
            SELECT 
                r.recipe_id,
                r.title,
                r.main_image_url,
                r.prep_minutes,
                r.cook_minutes,
                r.total_minutes,
                r.views,
                r.is_featured,
                r.difficulty,
                r.meta_description
            FROM recipes r
            JOIN recipe_categories rc ON r.recipe_id = rc.recipe_id
            JOIN categories c ON rc.category_id = c.category_id
            WHERE c.slug = ?
            ORDER BY r.created_at DESC
            LIMIT ?
        ";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("si", $categorySlug, $limit);
    } else {
        // Không có category → lấy tất cả
        $sql = "
            SELECT 
                recipe_id,
                title,
                main_image_url,
                prep_minutes,
                cook_minutes,
                total_minutes,
                views,
                is_featured,
                difficulty,
                meta_description
            FROM recipes
            ORDER BY created_at DESC
            LIMIT ?
        ";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("i", $limit);
    }

    if ($stmt) {
        $stmt->execute();
        $result = $stmt->get_result();

        while ($row = $result->fetch_assoc()) {
            // Ảnh mặc định + chuẩn hoá đường dẫn nếu bắt đầu bằng /images/
            if (empty($row['main_image_url'])) {
                $row['main_image_url'] = "assets/CTABG.png";
            } else {
                if (strpos($row['main_image_url'], '/images/') === 0) {
                    $row['main_image_url'] = ltrim($row['main_image_url'], '/');
                }
            }

            // Excerpt fallback
            $row['excerpt'] = !empty($row['meta_description'])
                ? $row['meta_description']
                : ("Discover " . $row['title']);

            // Hiển thị thời gian theo phút (ưu tiên total -> cook -> prep)
            $minutes = null;
            if (!empty($row['total_minutes'])) {
                $minutes = (int)$row['total_minutes'];
            } elseif (!empty($row['cook_minutes'])) {
                $minutes = (int)$row['cook_minutes'];
            } elseif (!empty($row['prep_minutes'])) {
                $minutes = (int)$row['prep_minutes'];
            }
            $row['time_display'] = ($minutes !== null && $minutes > 0) ? ($minutes . ' min') : '—';

            // Difficulty: lấy từ DB, fallback mặc định
            $row['difficulty'] = !empty($row['difficulty']) ? $row['difficulty'] : 'EASY PREP';

            // Schema mới không còn cột servings
            $row['servings_display'] = '— SERVES';

            // Alias id giữ tương thích UI
            $row['id'] = $row['recipe_id'];

            $recipes[] = $row;
        }

        $stmt->close();
    }

    return $recipes;
}
?>
