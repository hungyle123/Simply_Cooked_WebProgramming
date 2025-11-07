<?php
// /public/robots.php
require_once __DIR__ . '/../config/db.php'; // để lấy BASE_URL :contentReference[oaicite:3]{index=3}
header('Content-Type: text/plain; charset=utf-8');

$base = rtrim(BASE_URL, '/').'/';
echo "User-agent: *\n";
echo "Disallow: /app/\n";
echo "Disallow: /config/\n";
echo "Disallow: /resources/\n";
echo "Disallow: /storage/\n";
echo "Disallow: /vender/\n";
echo "Allow: /\n\n";
echo "Sitemap: {$base}sitemap.xml\n";
