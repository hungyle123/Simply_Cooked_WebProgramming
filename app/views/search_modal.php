<?php
// app/views/search_modal.php
?>
<div id="searchModal" class="modal-overlay" aria-hidden="true">
  <div class="modal-panel" role="dialog" aria-modal="true" aria-labelledby="searchHeading">
    <button id="searchClose" class="modal-close" aria-label="Close search">✕</button>

    <h3 id="searchHeading" style="margin:0 0 12px; font-family:var(--font-heading); color:#111;">Search Recipes</h3>

    <!-- Form tìm kiếm (compact). Dropdown bám theo input, chỉ hiện tên -->
    <form id="searchForm" class="search-form" action="javascript:void(0)" autocomplete="off"
          style="display:flex; gap:10px; align-items:center; position:relative;">
      <label for="searchInput" class="sr-only">Search</label>
      <input
        id="searchInput"
        name="q"
        placeholder="Try 'chicken', 'italian', or 'dessert'..."
        style="flex:1; padding:12px 14px; border:1px solid #cfc8bf; border-radius:10px; font-size:14px;"
        autofocus
      >
      <button type="submit" class="header-auth-btn dark">Search</button>

      <!-- Dropdown gợi ý nhỏ gọn (không ảnh) -->
      <ul id="searchSuggestList" class="suggest-compact" style="display:none;"></ul>
    </form>

    <!-- Chỗ để sau này show kết quả đầy đủ (nếu cần) -->
    <div id="searchResults" class="search-results" aria-live="polite" style="margin-top:14px;"></div>
  </div>
</div>

<script>
// ===== Toggle mở/đóng modal =====
(function(){
  var modal = document.getElementById('searchModal');
  var btn   = document.getElementById('searchToggle'); // trong header
  var close = document.getElementById('searchClose');
  var input = document.getElementById('searchInput');
  if(!modal) return;

  function openModal(){
    modal.classList.add('show');
    modal.setAttribute('aria-hidden','false');
    setTimeout(function(){ if (input) input.focus(); }, 50);
  }
  function closeModal(){
    modal.classList.remove('show');
    modal.setAttribute('aria-hidden','true');
  }

  if (btn)   btn.addEventListener('click', openModal);
  if (close) close.addEventListener('click', closeModal);
  modal.addEventListener('click', function(e){
    if (e.target === modal) closeModal();
  });
  document.addEventListener('keydown', function(e){
    if (e.key === 'Escape') closeModal();
  });
})();

// ===== AJAX gợi ý (compact list, không ảnh) =====
(function(){
  var input = document.getElementById('searchInput');
  var list  = document.getElementById('searchSuggestList');
  var form  = document.getElementById('searchForm');
  if(!input || !list || !form) return;

  // Submit: nếu có gợi ý thì đi tới item đầu
  form.addEventListener('submit', function(e){
    e.preventDefault();
    const first = list.querySelector('li a');
    if (first) window.location.href = first.getAttribute('href');
  });

  function debounce(fn, ms){ let t; return (...a)=>{ clearTimeout(t); t=setTimeout(()=>fn(...a), ms); }; }

  async function run(){
    const q = input.value.trim();
    if (!q){ list.innerHTML=''; list.style.display='none'; return; }

    try{
      const url = 'index.php?route=ajax.search&q=' + encodeURIComponent(q) + '&limit=6';
      const res = await fetch(url);
      if (!res.ok) throw new Error('HTTP '+res.status);

      let data;
      try { data = await res.json(); }
      catch(e){
        const txt = await res.text();
        console.error('Search AJAX non-JSON:', res.status, txt.slice(0,300));
        throw e;
      }

      if (!Array.isArray(data) || data.length === 0){
        list.innerHTML = '<li class="muted">No results</li>';
        list.style.display = 'block';
        return;
      }

      // Chỉ hiện tên + meta nhỏ
      list.innerHTML = data.map(function(it){
        const href = it.slug ? ('recipe.php?slug=' + encodeURIComponent(it.slug))
                             : ('recipe.php?id=' + encodeURIComponent(it.recipe_id || ''));
        const meta = [it.prep_time ? ('Prep ' + it.prep_time) : null,
                      it.cook_time ? ('Cook ' + it.cook_time) : null]
                      .filter(Boolean).join(' • ');
        return `<li><a href="${href}" tabindex="0">
                  <span class="t">${(it.title||'Untitled')}</span>
                  ${meta ? `<span class="m">${meta}</span>` : ''}
                </a></li>`;
      }).join('');
      list.style.display = 'block';
    } catch(err){
      list.innerHTML = '<li class="muted">Error</li>';
      list.style.display = 'block';
      console.error(err);
    }
  }

  const runDebounced = debounce(run, 200);
  input.addEventListener('input', runDebounced);
  input.addEventListener('focus', runDebounced);

  // Ẩn dropdown khi click ra ngoài
  document.addEventListener('click', function(e){
    if (!list.contains(e.target) && e.target !== input){ list.style.display='none'; }
  });

  // Điều hướng bằng phím ↑ ↓ Enter trên list
  input.addEventListener('keydown', function(e){
    const items = Array.from(list.querySelectorAll('li a'));
    if (!items.length) return;

    const idx = items.findIndex(a => a === document.activeElement);
    if (e.key === 'ArrowDown'){
      e.preventDefault();
      (items[idx+1] || items[0]).focus();
    }
    if (e.key === 'ArrowUp'){
      e.preventDefault();
      (items[idx-1] || items[items.length-1]).focus();
    }
    if (e.key === 'Enter' && document.activeElement !== input){
      // để <a> thực thi điều hướng mặc định
    }
  });
})();
</script>

<style>
/* ===== Compact suggest under header search input ===== */
.suggest-compact{
  position:absolute; left:0; right:120px; top:100%;
  z-index:9999;
  margin:8px 0 0; padding:6px 0;
  list-style:none; background:#fff;
  border:1px solid #e0d8d0; border-radius:10px;
  box-shadow:0 10px 24px rgba(14,14,14,0.12);
  max-height:240px; overflow:auto;
}
.suggest-compact li + li{ border-top:1px solid #f0ece7; }
.suggest-compact a{
  display:flex; justify-content:space-between; align-items:center;
  gap:12px; padding:8px 12px; text-decoration:none; color:#222;
  font-size:14px; line-height:1.2;
  outline: none;
}
.suggest-compact a:hover,
.suggest-compact a:focus{ background:#faf7f3; }
.suggest-compact .t{ font-weight:600; }
.suggest-compact .m{ font-size:12px; color:#777; }
.suggest-compact .muted{ color:#777; padding:8px 12px; }
@media (max-width: 540px){
  .suggest-compact{ right:0; } /* trên mobile: full chiều rộng form */
}
</style>
