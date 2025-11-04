<?php
function get_recipes_for_home(mysqli $conn, $limit = 12, $categorySlug = null) {
    $recipes = [];

    // Nếu có category, JOIN thêm bảng categories
    if ($categorySlug) {
        $sql = "
            SELECT r.recipe_id, r.title, r.main_image_url, r.prep_time, r.cook_time, r.total_time,
                   r.views, r.is_featured, r.meta_description
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
            SELECT recipe_id, title, main_image_url, prep_time, cook_time, total_time,
                   views, is_featured, meta_description
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
            if (empty($row['main_image_url'])) {
                $row['main_image_url'] = "assets/CTABG.png";
            } else {
                if (strpos($row['main_image_url'], '/images/') === 0) {
                    $row['main_image_url'] = ltrim($row['main_image_url'], '/');
                }
            }

            $row['excerpt'] = !empty($row['meta_description'])
                ? $row['meta_description']
                : ("Discover " . $row['title']);

            $timeDisplay = $row['total_time'] ?: ($row['cook_time'] ?: $row['prep_time']);
            $row['time_display'] = $timeDisplay ?: '—';
            $row['difficulty'] = "EASY PREP";
            $row['servings_display'] = !empty($row['servings'])
                ? preg_replace('/[^0-9]/', '', $row['servings']) . ' SERVES'
                : '— SERVES';
            $row['id'] = $row['recipe_id'];

            $recipes[] = $row;
        }

        $stmt->close();
    }

    return $recipes;
}
?>
