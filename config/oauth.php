<?php
// config/oauth.php
// NOTE: KHÔNG commit file này nếu repo public.
// API Key đã bỏ nên không chỉnh file này.
return [
  'google' => [
    'client_id'     => '939388920985-aar212509qhd4us5fh606to97snghg3b.apps.googleusercontent.com',
    'client_secret' => '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',
    // Trỏ TỚI callback (không phải start):
    'redirect_uri'  => 'http://localhost/Individual_website/project/public/auth/google_callback.php',
    // Nếu app của bạn chạy ở path khác, sửa đúng base URL ở trên.
  ],
];
