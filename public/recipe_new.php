<?php
// /public/recipe_new.php
session_start();
require_once __DIR__ . '/../config/db.php';

if (empty($_SESSION['user_id'])) {
  header('Location: /Individual_website/project/public/login.php');
  exit;
}

// Lấy categories
$cats = [];
$res = $conn->query("SELECT category_id, name FROM categories ORDER BY name ASC");
while($row = $res->fetch_assoc()){ $cats[] = $row; }
?>
<?php
$active = '';
$page_title = "Add New Recipe - Cooks Delight";
include __DIR__ . '/../app/views/header.php';
?>

<main class="site-main container">
  <h1 style="font-family:var(--font-heading);margin-bottom:14px;">Add a New Recipe</h1>
  <form action="/Individual_website/project/app/controller/recipe_store.php" method="post" class="recipe-create-form" style="background:#fff;border:1px solid #e2dfdb;border-radius:18px;box-shadow:var(--shadow);padding:20px">
    <!-- CSRF đơn giản -->
    <?php $_SESSION['csrf'] = bin2hex(random_bytes(16)); ?>
    <input type="hidden" name="csrf" value="<?= $_SESSION['csrf'] ?>">

    <!-- Basics -->
    <div style="display:grid;grid-template-columns:1fr 1fr;gap:16px">
      <label>Title
        <input type="text" name="title" id="title" required style="width:100%;padding:10px;border:1px solid #e2dfdb;border-radius:10px">
      </label>
      <label>Slug (auto)
        <input type="text" name="slug" id="slug" required style="width:100%;padding:10px;border:1px solid #e2dfdb;border-radius:10px">
      </label>

      <label>Main Image URL
        <input type="text" name="main_image_url" placeholder="images/xxx.jpg" style="width:100%;padding:10px;border:1px solid #e2dfdb;border-radius:10px">
      </label>
      <label>Difficulty
        <select name="difficulty" style="width:100%;padding:10px;border:1px solid #e2dfdb;border-radius:10px">
          <option value="easy">easy</option>
          <option value="medium">medium</option>
          <option value="hard">hard</option>
        </select>
      </label>

      <label>Prep time <input name="prep_time" type="text" placeholder="10 min" style="width:100%;padding:10px;border:1px solid #e2dfdb;border-radius:10px"></label>
      <label>Cook time <input name="cook_time" type="text" placeholder="20 min" style="width:100%;padding:10px;border:1px solid #e2dfdb;border-radius:10px"></label>
      <label>Total time <input name="total_time" type="text" placeholder="30 min" style="width:100%;padding:10px;border:1px solid #e2dfdb;border-radius:10px"></label>
      <label>Is featured?
        <select name="is_featured" style="width:100%;padding:10px;border:1px solid #e2dfdb;border-radius:10px">
          <option value="0">No</option>
          <option value="1">Yes</option>
        </select>
      </label>

      <label>Meta Description
        <input type="text" name="meta_description" maxlength="255" style="width:100%;padding:10px;border:1px solid #e2dfdb;border-radius:10px">
      </label>
      <label>Keywords
        <input type="text" name="keywords" maxlength="255" placeholder="comma,separated" style="width:100%;padding:10px;border:1px solid #e2dfdb;border-radius:10px">
      </label>
    </div>

    <label style="display:block;margin-top:12px">Short Description
      <textarea name="description" rows="3" style="width:100%;padding:10px;border:1px solid #e2dfdb;border-radius:10px"></textarea>
    </label>

    <!-- Instructions blocks -->
    <div style="display:grid;grid-template-columns:1fr 1fr;gap:16px;margin-top:12px">
      <label>Instructions Intro
        <textarea name="instructions_intro" rows="3" style="width:100%;padding:10px;border:1px solid #e2dfdb;border-radius:10px"></textarea>
      </label>
      <label>Full Instructions
        <textarea name="instructions" rows="3" required style="width:100%;padding:10px;border:1px solid #e2dfdb;border-radius:10px"></textarea>
      </label>

      <label>Prep Instructions
        <textarea name="prep_instructions" rows="3" style="width:100%;padding:10px;border:1px solid #e2dfdb;border-radius:10px"></textarea>
      </label>
      <label>Cook Instructions
        <textarea name="cook_instructions" rows="3" style="width:100%;padding:10px;border:1px solid #e2dfdb;border-radius:10px"></textarea>
      </label>

      <label>Do Tips
        <textarea name="do_tips" rows="3" style="width:100%;padding:10px;border:1px solid #e2dfdb;border-radius:10px"></textarea>
        <small style="color:var(--muted);display:block;margin-top:6px">Support bullet by newline \n</small>
      </label>
      <label>Don't Tips
        <textarea name="dont_tips" rows="3" style="width:100%;padding:10px;border:1px solid #e2dfdb;border-radius:10px"></textarea>
        <small style="color:var(--muted);display:block;margin-top:6px">Support bullet by newline \n</small>
      </label>

      <label>Video URL
        <input type="text" name="video_url" placeholder="https://youtube..." style="width:100%;padding:10px;border:1px solid #e2dfdb;border-radius:10px">
      </label>

      <!-- Origin / map -->
      <div style="display:grid;grid-template-columns:1fr 1fr;gap:12px">
        <label>Origin Place <input name="origin_place" type="text" placeholder="Tuscany, Italy" style="width:100%;padding:10px;border:1px solid #e2dfdb;border-radius:10px"></label>
        <label>Origin Zoom <input name="origin_zoom" type="number" min="1" max="20" value="11" style="width:100%;padding:10px;border:1px solid #e2dfdb;border-radius:10px"></label>
        <label style="grid-column:1 / -1">Map Embed URL
          <input name="origin_map_embed_url" type="text" placeholder="https://www.google.com/maps/d/embed?mid=..." style="width:100%;padding:10px;border:1px solid #e2dfdb;border-radius:10px">
        </label>
      </div>
    </div>

    <!-- Categories -->
    <div style="margin-top:16px">
      <label>Categories (multi)
        <select name="category_ids[]" multiple size="3" style="width:100%;padding:10px;border:1px solid #e2dfdb;border-radius:10px">
          <?php foreach($cats as $c): ?>
            <option value="<?= (int)$c['category_id'] ?>"><?= htmlspecialchars($c['name']) ?></option>
          <?php endforeach; ?>
        </select>
      </label>
      <small style="color:var(--muted)">Keep Ctrl/Cmd to select multi.</small>
    </div>

    <!-- INGREDIENTS repeater -->
    <section style="margin-top:20px">
      <h3 style="margin:0 0 8px">Ingredients</h3>
      <div id="ingredients"></div>
      <button type="button" class="btn" onclick="addRow('ingredients','ing')">+ Add ingredient</button>
      <small style="color:var(--muted);display:block;margin-top:6px">Field: name, quantity, unit, note.</small>
    </section>

    <!-- EQUIPMENT -->
    <section style="margin-top:20px">
      <h3 style="margin:0 0 8px">Equipment</h3>
      <div id="equipment"></div>
      <button type="button" class="btn" onclick="addRow('equipment','eq','name')">+ Add equipment</button>
    </section>

    <!-- INSTRUCTION SECTIONS -->
    <section style="margin-top:20px">
      <h3 style="margin:0 0 8px">Instruction Sections</h3>
      <div id="sections"></div>
      <button type="button" class="btn" onclick="addSection()">+ Add section</button>
      <small style="color:var(--muted);display:block;margin-top:6px">Each section have title + body (body support bullet by newline \n).</small>
    </section>

    <div style="margin-top:22px;display:flex;gap:12px">
      <button class="btn-primary" type="submit">Save Recipe</button>
      <a href="/Individual_website/project/public/index.php" class="btn">Cancel</a>
    </div>
  </form>
</main>

<script>
// slugify từ title
const titleEl = document.getElementById('title');
const slugEl = document.getElementById('slug');
function slugify(s){return s.toLowerCase().trim()
 .normalize('NFD').replace(/[\u0300-\u036f]/g,'')
 .replace(/[^a-z0-9]+/g,'-').replace(/^-+|-+$/g,'');}
titleEl.addEventListener('input',()=>{ if(!slugEl.dataset.touched) slugEl.value = slugify(titleEl.value);});
slugEl.addEventListener('input',()=>{ slugEl.dataset.touched = '1';});

// repeater helpers
function addRow(containerId, prefix, nameOnly){
  const wrap = document.getElementById(containerId);
  const idx = wrap.children.length;
  const row = document.createElement('div');
  row.style = "display:grid;grid-template-columns:2fr 1fr 1fr 1.5fr auto;gap:8px;margin-bottom:8px";
  if(nameOnly==='name'){
    row.innerHTML = `
      <input name="${prefix}[${idx}][name]" placeholder="name" required style="padding:10px;border:1px solid #e2dfdb;border-radius:10px">
      <input type="hidden" name="${prefix}[${idx}][sort_order]" value="${idx+1}">
      <div></div><div></div>
      <button type="button" class="btn-small" onclick="this.parentElement.remove()">Remove</button>`;
  }else{
    row.innerHTML = `
      <input name="${prefix}[${idx}][name]" placeholder="name" required style="padding:10px;border:1px solid #e2dfdb;border-radius:10px">
      <input name="${prefix}[${idx}][quantity]" placeholder="qty" style="padding:10px;border:1px solid #e2dfdb;border-radius:10px">
      <input name="${prefix}[${idx}][unit]" placeholder="unit" style="padding:10px;border:1px solid #e2dfdb;border-radius:10px">
      <input name="${prefix}[${idx}][note]" placeholder="note" style="padding:10px;border:1px solid #e2dfdb;border-radius:10px">
      <input type="hidden" name="${prefix}[${idx}][sort_order]" value="${idx+1}">
      <button type="button" class="btn-small" onclick="this.parentElement.remove()">Remove</button>`;
  }
  wrap.appendChild(row);
}
function addSection(){
  const wrap = document.getElementById('sections');
  const idx = wrap.children.length;
  const box = document.createElement('div');
  box.style = "border:1px solid #e2dfdb;border-radius:12px;padding:10px;margin-bottom:10px";
  box.innerHTML = `
    <label>Section title
      <input name="sec[${idx}][section_title]" required style="width:100%;padding:10px;border:1px solid #e2dfdb;border-radius:10px">
    </label>
    <label>Section body (each line = bullet)
      <textarea name="sec[${idx}][section_body]" rows="3" required style="width:100%;padding:10px;border:1px solid #e2dfdb;border-radius:10px"></textarea>
    </label>
    <input type="hidden" name="sec[${idx}][sort_order]" value="${idx+1}">
    <div><button type="button" class="btn-small" onclick="this.closest('div').parentElement.remove()">Remove section</button></div>
  `;
  wrap.appendChild(box);
}

// seed 1 hàng mặc định
addRow('ingredients','ing');
addRow('equipment','eq','name');
addSection();
</script>

<?php include __DIR__ . '/../app/views/footer.php'; ?>
