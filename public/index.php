<?php
$page_title = 'Simple Cooked - Home';
$active = 'home';

if (session_status() === PHP_SESSION_NONE) session_start();

include __DIR__ . '/../config/db.php';

// ===== [ADDED] small helper: only-admin =====
function require_admin_or_redirect(mysqli $conn) {
  if (empty($_SESSION['user_id'])) {
    header('Location: login.php');
    exit;
  }
  // Lấy role từ session nếu có, thiếu thì hỏi DB
  $role = $_SESSION['user']['role'] ?? null;
  if (!$role) {
    $uid = (int)$_SESSION['user_id'];
    if ($res = $conn->query("SELECT role FROM users WHERE user_id = {$uid} LIMIT 1")) {
      $row = $res->fetch_assoc();
      $role = $row['role'] ?? 'user';
      $_SESSION['user']['role'] = $role; // cache
    } else {
      $role = 'user';
    }
  }
  if ($role !== 'admin') {
    http_response_code(403);
    echo '<!doctype html><meta charset="utf-8"><title>403</title>
          <h1 style="font-family:system-ui;margin:24px">403 — Admin only</h1>';
    exit;
  }
}

// ===== existing ajax route =====
$route = $_GET['route'] ?? '';
if ($route === 'ajax.search') {
  require_once __DIR__ . '/../app/controller/search_controller.php';
  search_recipes_json($conn);
  exit;
}

// ===== [ADDED] tiny router for admin pages =====
$page = $_GET['page'] ?? 'home';

if ($page === 'admin_edit_recipes') {
  require_admin_or_redirect($conn);
  $page_title = 'Admin · Edit Recipes';
  include __DIR__ . '/../app/views/header.php';

  // Lấy danh sách recipe (tối đa 50 mới nhất)
  $rows = [];
  $sql = "SELECT r.recipe_id, r.title, r.slug, r.created_at, u.username
          FROM recipes r
          LEFT JOIN users u ON u.user_id = r.user_id
          ORDER BY r.created_at DESC
          LIMIT 50";
  if ($res = $conn->query($sql)) {
    while ($row = $res->fetch_assoc()) $rows[] = $row;
  }
  ?>
  <main class="container" style="padding:20px">
    <h1 style="margin:0 0 12px; font-family:var(--font-heading)">Edit Recipes (Admin)</h1>

    <?php if (empty($rows)): ?>
      <p style="color:#666">Chưa có recipe nào.</p>
    <?php else: ?>
      <div style="overflow:auto; border:1px solid #e2dfdb; border-radius:12px">
        <table style="width:100%; border-collapse:collapse; font-size:14px">
          <thead style="background:#faf8f6">
            <tr>
              <th style="text-align:left; padding:10px; border-bottom:1px solid #e2dfdb">ID</th>
              <th style="text-align:left; padding:10px; border-bottom:1px solid #e2dfdb">Title</th>
              <th style="text-align:left; padding:10px; border-bottom:1px solid #e2dfdb">Author</th>
              <th style="text-align:left; padding:10px; border-bottom:1px solid #e2dfdb">Created</th>
              <th style="text-align:left; padding:10px; border-bottom:1px solid #e2dfdb">Actions</th>
            </tr>
          </thead>
          <tbody>
          <?php foreach ($rows as $r): ?>
            <tr>
              <td style="padding:10px; border-bottom:1px solid #f0eeeb"><?= (int)$r['recipe_id'] ?></td>
              <td style="padding:10px; border-bottom:1px solid #f0eeeb">
                <?= htmlspecialchars($r['title'] ?? '') ?>
                <div style="color:#888; font-size:12px">/recipes/<?= htmlspecialchars($r['slug'] ?? '') ?></div>
              </td>
              <td style="padding:10px; border-bottom:1px solid #f0eeeb"><?= htmlspecialchars($r['username'] ?? '—') ?></td>
              <td style="padding:10px; border-bottom:1px solid #f0eeeb">
                <?= htmlspecialchars(substr((string)($r['created_at'] ?? ''), 0, 19)) ?>
              </td>
              <td style="padding:10px; border-bottom:1px solid #f0eeeb">
                <!-- Edit recipe (route sẽ làm ở lượt sau) -->
                <a class="btn" href="/Individual_website/project/public/index.php?page=admin_recipe_edit&id=<?= (int)$r['recipe_id'] ?>">Edit</a>
                <!-- Delete sẽ thêm sau để tránh nhầm tay -->
              </td>
            </tr>
          <?php endforeach; ?>
          </tbody>
        </table>
      </div>
    <?php endif; ?>
  </main>
  <?php
  include __DIR__ . '/../app/views/footer.php';
  exit;
}


if ($page === 'admin_edit_users') {
  require_admin_or_redirect($conn);
  $page_title = 'Admin · Edit Users';
  include __DIR__ . '/../app/views/header.php';

  // Lấy danh sách users (tối đa 50)
  $users = [];
  $sql = "SELECT user_id, username, email, role, created_at
          FROM users
          ORDER BY created_at DESC
          LIMIT 50";
  if ($res = $conn->query($sql)) {
    while ($row = $res->fetch_assoc()) $users[] = $row;
  }
  ?>
  <main class="container" style="padding:20px">
    <h1 style="margin:0 0 12px; font-family:var(--font-heading)">Edit Users (Admin)</h1>

    <?php if (empty($users)): ?>
      <p style="color:#666">Chưa có user nào.</p>
    <?php else: ?>
      <div style="overflow:auto; border:1px solid #e2dfdb; border-radius:12px">
        <table style="width:100%; border-collapse:collapse; font-size:14px">
          <thead style="background:#faf8f6">
            <tr>
              <th style="text-align:left; padding:10px; border-bottom:1px solid #e2dfdb">ID</th>
              <th style="text-align:left; padding:10px; border-bottom:1px solid #e2dfdb">Username</th>
              <th style="text-align:left; padding:10px; border-bottom:1px solid #e2dfdb">Email</th>
              <th style="text-align:left; padding:10px; border-bottom:1px solid #e2dfdb">Role</th>
              <th style="text-align:left; padding:10px; border-bottom:1px solid #e2dfdb">Created</th>
              <th style="text-align:left; padding:10px; border-bottom:1px solid #e2dfdb">Actions</th>
            </tr>
          </thead>
          <tbody>
          <?php foreach ($users as $u): ?>
            <tr>
              <td style="padding:10px; border-bottom:1px solid #f0eeeb"><?= (int)$u['user_id'] ?></td>
              <td style="padding:10px; border-bottom:1px solid #f0eeeb"><?= htmlspecialchars($u['username'] ?? '') ?></td>
              <td style="padding:10px; border-bottom:1px solid #f0eeeb"><?= htmlspecialchars($u['email'] ?? '') ?></td>
              <td style="padding:10px; border-bottom:1px solid #f0eeeb">
                <span style="display:inline-block;padding:2px 8px;border:1px solid #e2dfdb;border-radius:999px">
                  <?= htmlspecialchars($u['role'] ?? 'user') ?>
                </span>
              </td>
              <td style="padding:10px; border-bottom:1px solid #f0eeeb">
                <?= htmlspecialchars(substr((string)($u['created_at'] ?? ''), 0, 19)) ?>
              </td>
              <td style="padding:10px; border-bottom:1px solid #f0eeeb">
                <!-- Edit user (route sẽ làm ở lượt sau) -->
                <a class="btn" href="/Individual_website/project/public/index.php?page=admin_user_edit&id=<?= (int)$u['user_id'] ?>">Edit</a>
                <!-- Deactivate/Delete sẽ thêm sau -->
              </td>
            </tr>
          <?php endforeach; ?>
          </tbody>
        </table>
      </div>
    <?php endif; ?>
  </main>
  <?php
  include __DIR__ . '/../app/views/footer.php';
  exit;
}

// ===== Home (giữ nguyên) =====
if ($page === 'admin_recipe_edit') {
  require_admin_or_redirect($conn);
  $id = isset($_GET['id']) ? (int)$_GET['id'] : 0;
  if ($id <= 0) { http_response_code(400); echo "Invalid recipe id"; exit; }

  // Lấy dữ liệu recipe
  $stmt = $conn->prepare("SELECT recipe_id, user_id, title, slug, description, meta_description, difficulty, is_featured 
                          FROM recipes WHERE recipe_id = ? LIMIT 1");
  $stmt->bind_param('i', $id);
  $stmt->execute();
  $recipe = $stmt->get_result()->fetch_assoc();
  $stmt->close();

  if (!$recipe) { http_response_code(404); echo "Recipe not found"; exit; }

  $page_title = 'Admin · Edit Recipe';
  include __DIR__ . '/../app/views/header.php';
  ?>
  <main class="container" style="padding:20px">
    <h1>Edit recipe #<?= (int)$recipe['recipe_id'] ?></h1>

    <!-- Form tối giản, lần sau mới làm controller update -->
    <form method="post" action="/Individual_website/project/app/controller/recipe_update.php" style="background:#fff;padding:16px;border-radius:12px">
      <?php $_SESSION['csrf'] = $_SESSION['csrf'] ?? bin2hex(random_bytes(16)); ?>
      <input type="hidden" name="csrf" value="<?= $_SESSION['csrf'] ?>">
      <input type="hidden" name="recipe_id" value="<?= (int)$recipe['recipe_id'] ?>">

      <label style="display:block;margin:8px 0">Title
        <input type="text" name="title" value="<?= htmlspecialchars($recipe['title']) ?>" required style="width:100%">
      </label>

      <label style="display:block;margin:8px 0">Slug
        <input type="text" name="slug" value="<?= htmlspecialchars($recipe['slug']) ?>" required style="width:100%">
      </label>

      <label style="display:block;margin:8px 0">Description
        <textarea name="description" rows="4" style="width:100%"><?= htmlspecialchars($recipe['description'] ?? '') ?></textarea>
      </label>

      <label style="display:block;margin:8px 0">Meta description
        <input type="text" name="meta_description" value="<?= htmlspecialchars($recipe['meta_description'] ?? '') ?>" style="width:100%">
      </label>

      <label style="display:block;margin:8px 0">Difficulty
        <select name="difficulty">
          <option value="easy"   <?= $recipe['difficulty']==='easy'?'selected':'' ?>>easy</option>
          <option value="medium" <?= $recipe['difficulty']==='medium'?'selected':'' ?>>medium</option>
          <option value="hard"   <?= $recipe['difficulty']==='hard'?'selected':'' ?>>hard</option>
        </select>
      </label>

      <label style="display:block;margin:8px 0">Featured
        <select name="is_featured">
          <option value="0" <?= (int)$recipe['is_featured']===0?'selected':'' ?>>No</option>
          <option value="1" <?= (int)$recipe['is_featured']===1?'selected':'' ?>>Yes</option>
        </select>
      </label>

      <div style="margin-top:12px">
        <button type="submit" class="btn-primary">Save changes</button>
        <a href="index.php?page=admin_edit_recipes" class="btn">Back</a>
      </div>
    </form>
  </main>
  <?php
  include __DIR__ . '/../app/views/footer.php';
  exit;
}

if ($page === 'admin_user_edit') {
  require_admin_or_redirect($conn);
  $id = isset($_GET['id']) ? (int)$_GET['id'] : 0;
  if ($id <= 0) { http_response_code(400); echo "Invalid user id"; exit; }

  // Lấy thông tin user
  $stmt = $conn->prepare("SELECT user_id, username, email, full_name, role FROM users WHERE user_id = ? LIMIT 1");
  $stmt->bind_param('i', $id);
  $stmt->execute();
  $user = $stmt->get_result()->fetch_assoc();
  $stmt->close();

  if (!$user) { http_response_code(404); echo "User not found"; exit; }

  $page_title = 'Admin · Edit User';
  include __DIR__ . '/../app/views/header.php';
  ?>
  <main class="container" style="padding:20px">
    <h1>Edit user #<?= (int)$user['user_id'] ?> — <?= htmlspecialchars($user['username']) ?></h1>

    <!-- Lần này chỉ hiển thị form; bước sau mới code controller -->
    <form method="post" action="/Individual_website/project/app/controller/user_update.php" style="background:#fff;padding:16px;border-radius:12px">
      <?php $_SESSION['csrf'] = $_SESSION['csrf'] ?? bin2hex(random_bytes(16)); ?>
      <input type="hidden" name="csrf" value="<?= $_SESSION['csrf'] ?>">
      <input type="hidden" name="user_id" value="<?= (int)$user['user_id'] ?>">

      <label style="display:block;margin:8px 0">Username
        <input name="username" value="<?= htmlspecialchars($user['username']) ?>" required style="width:100%">
      </label>

      <label style="display:block;margin:8px 0">Email
        <input type="email" name="email" value="<?= htmlspecialchars($user['email']) ?>" required style="width:100%">
      </label>

      <label style="display:block;margin:8px 0">Full name
        <input name="full_name" value="<?= htmlspecialchars($user['full_name'] ?? '') ?>" style="width:100%">
      </label>

      <label style="display:block;margin:8px 0">Role
        <select name="role">
          <option value="user"  <?= ($user['role']==='user')?'selected':'' ?>>user</option>
          <option value="admin" <?= ($user['role']==='admin')?'selected':'' ?>>admin</option>
        </select>
      </label>

      <label style="display:block;margin:8px 0">New password (để trống nếu không đổi)
        <input type="password" name="new_password" autocomplete="new-password" style="width:100%">
      </label>

      <div style="margin-top:12px">
        <button type="submit" class="btn-primary">Save changes</button>
        <a href="index.php?page=admin_edit_users" class="btn">Back</a>
      </div>
    </form>
  </main>
  <?php
  include __DIR__ . '/../app/views/footer.php';
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
  <?php include __DIR__ . '/../app/views/receipt_section.php'; ?>
  <?php include __DIR__ . '/../app/views/about-section.php'; ?>
</div>

<?php include __DIR__ . '/../app/views/footer.php'; ?>
