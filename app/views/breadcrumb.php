<?php
if (!isset($breadcrumbs) || !is_array($breadcrumbs)) return;
$last = count($breadcrumbs) - 1;
?>
<nav class="breadcrumb" aria-label="Breadcrumb">
  <div class="container">
    <ul class="breadcrumb__list" role="list">
      <?php foreach ($breadcrumbs as $i => $c): ?>
        <li class="breadcrumb__item<?= $i === $last ? ' is-current' : '' ?>">
          <?php if ($i === $last || empty($c['url'])): ?>
            <span class="breadcrumb__current"><?= htmlspecialchars($c['label']) ?></span>
          <?php else: ?>
            <a class="breadcrumb__link" href="<?= htmlspecialchars($c['url']) ?>"><?= htmlspecialchars($c['label']) ?></a>
          <?php endif; ?>
        </li>
      <?php endforeach; ?>
    </ul>
  </div>
</nav>
