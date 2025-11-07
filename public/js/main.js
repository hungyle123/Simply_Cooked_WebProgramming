document.addEventListener('DOMContentLoaded', function () {
  const mobileToggle = document.getElementById('mobileMenuToggle');
  const mobileMenu = document.getElementById('mobileMenu');
  const mobileClose = document.getElementById('mobileMenuClose');
  const mobileSearchOpen = document.getElementById('mobileSearchOpen');

  const searchModal = document.getElementById('searchModal');
  const searchToggle = document.getElementById('searchToggle');
  const searchClose = document.getElementById('searchClose');
  const searchForm = document.getElementById('searchForm');
  const searchInput = document.getElementById('searchInput');
  const searchResults = document.getElementById('searchResults');

  function openMobileMenu() {
    mobileMenu.classList.add('show');
    mobileMenu.setAttribute('aria-hidden', 'false');
    document.body.style.overflow = 'hidden';
  }

  function closeMobileMenu() {
    mobileMenu.classList.remove('show');
    mobileMenu.setAttribute('aria-hidden', 'true');
    document.body.style.overflow = '';
  }

  if (mobileToggle) mobileToggle.addEventListener('click', openMobileMenu);
  if (mobileClose) mobileClose.addEventListener('click', closeMobileMenu);

  function openSearch() {
    if (!searchModal) return;
    searchModal.classList.add('show');
    searchModal.setAttribute('aria-hidden', 'false');
    if (searchInput) searchInput.focus();
    document.body.style.overflow = 'hidden';
  }

  function closeSearch() {
    if (!searchModal) return;
    searchModal.classList.remove('show');
    searchModal.setAttribute('aria-hidden', 'true');
    document.body.style.overflow = '';
    if (searchResults) searchResults.innerHTML = '';
  }

  if (searchToggle) searchToggle.addEventListener('click', openSearch);
  if (searchClose) searchClose.addEventListener('click', closeSearch);

  if (mobileSearchOpen) {
    mobileSearchOpen.addEventListener('click', function () {
      closeMobileMenu();
      setTimeout(openSearch, 220);
    });
  }

  document.addEventListener('click', function (e) {
    if (e.target === searchModal) closeSearch();
    if (e.target === mobileMenu) closeMobileMenu();
  });

  function handleSearchSubmit(ev) {
    ev.preventDefault();
    const q = (searchInput && searchInput.value.trim()) || '';
    if (!q) {
      if (searchResults) searchResults.innerHTML = '<p class="muted">Please enter a search term.</p>';
      return;
    }

    if (searchResults) searchResults.innerHTML = '<p class="muted">Searching…</p>';

    fetch('/search.php?q=' + encodeURIComponent(q))
      .then(r => r.json())
      .then(data => {
        if (!Array.isArray(data) || data.length === 0) {
          searchResults.innerHTML = '<p class="muted">No results found.</p>';
          return;
        }

        const list = document.createElement('div');
        list.className = 'search-list';

        data.slice(0, 8).forEach(item => {
          const el = document.createElement('a');
          el.href = '/recipe.php?id=' + encodeURIComponent(item.id);
          el.className = 'search-item';
          el.innerHTML =
            '<strong>' + (item.title || 'Untitled') + '</strong>' +
            '<div class="muted">' + (item.excerpt || '') + '</div>';
          list.appendChild(el);
        });

        searchResults.innerHTML = '';
        searchResults.appendChild(list);
      })
      .catch(err => {
        console.error(err);
        searchResults.innerHTML = '<p class="muted">Search failed. Try again later.</p>';
      });
  }

  if (searchForm) {
    searchForm.addEventListener('submit', handleSearchSubmit);
  }
});
