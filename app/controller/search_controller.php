<?php
// app/controller/search_controller.php
declare(strict_types=1);

/**
 * Search recipes by keyword and return JSON list
 * Output format: [{recipe_id, slug, title, thumb, prep_time, cook_time}]
 */
function search_recipes_json(mysqli $conn): void {
    header('Content-Type: application/json; charset=utf-8');

    $q = isset($_GET['q']) ? trim((string)$_GET['q']) : '';
    $limit = isset($_GET['limit']) ? (int)$_GET['limit'] : 8;
    if ($limit < 1 || $limit > 20) $limit = 8;

    if ($q === '') { echo json_encode([]); return; }

    // NOTE: các cột khớp với recipes.php đang dùng: main_image_url, title, slug, prep_time, cook_time
    $sql = "
      SELECT r.recipe_id,
             r.slug,
             r.title,
             COALESCE(NULLIF(r.main_image_url,''), '/public/assets/placeholder.jpg') AS thumb,
             r.prep_time,
             r.cook_time
      FROM recipes r
      WHERE r.title LIKE CONCAT('%', ?, '%')
         OR r.keywords LIKE CONCAT('%', ?, '%')
      ORDER BY r.created_at DESC
      LIMIT ?
    ";

    if (!$stmt = $conn->prepare($sql)) {
        http_response_code(500);
        echo json_encode(['error' => 'prepare_failed']);
        return;
    }

    $stmt->bind_param('ssi', $q, $q, $limit);
    $stmt->execute();
    $res = $stmt->get_result();

    $out = [];
    while ($row = $res->fetch_assoc()) {
        $out[] = [
            'recipe_id' => (int)$row['recipe_id'],
            'slug'      => (string)$row['slug'],
            'title'     => (string)$row['title'],
            'thumb'     => (string)$row['thumb'],
            'prep_time' => $row['prep_time'] !== null ? (string)$row['prep_time'] : null,
            'cook_time' => $row['cook_time'] !== null ? (string)$row['cook_time'] : null,
        ];
    }
    $stmt->close();

    echo json_encode($out, JSON_UNESCAPED_UNICODE);
}
