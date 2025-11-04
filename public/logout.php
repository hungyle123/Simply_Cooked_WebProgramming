<?php
session_start();
session_unset();
session_destroy();

// Sau khi logout xong, quay về trang chủ
header('Location: index.php');
exit;
