<?php
// breadcrumb.php
// Place this in: app/views/partials/breadcrumb.php
// Expect $breadcrumbs = [ ['label'=>'Home','url'=>'/'], ['label'=>'Recipes','url'=>'/recipes.php'], ... ]

if (!isset($breadcrumbs) || !is_array($breadcrumbs)) {
    return;
}
?>
<nav class="breadcrumb" aria-label="Breadcrumb">
  <div class="container">
    <ul>
      <?php foreach($breadcrumbs as $i => $crumb): ?>
        <li class="<?php echo $i === count($breadcrumbs)-1 ? 'current' : ''; ?>">
          <?php if ($i === count($breadcrumbs)-1): ?>
            <span><?php echo htmlspecialchars($crumb['label']); ?></span>
          <?php else: ?>
            <a href="<?php echo htmlspecialchars($crumb['url']); ?>"><?php echo htmlspecialchars($crumb['label']); ?></a>
          <?php endif; ?>
        </li>
      <?php endforeach; ?>
    </ul>
  </div>
</nav>
