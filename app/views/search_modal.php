<?php
// search_modal.php
// Place this in: app/views/partials/search_modal.php
?>
<div id="searchModal" class="modal-overlay" aria-hidden="true">
  <div class="modal-panel">
    <button id="searchClose" class="modal-close" aria-label="Close search">✕</button>
    <h3>Search Recipes</h3>
    <form id="searchForm" class="search-form" action="/search.php" method="get" autocomplete="off">
      <label for="searchInput" class="sr-only">Search</label>
      <input id="searchInput" name="q" placeholder="Try 'chicken', 'italian', or 'dessert'..." autofocus>
      <button type="submit" class="btn">Search</button>
    </form>

    <div id="searchResults" class="search-results" aria-live="polite"></div>
  </div>
</div>
