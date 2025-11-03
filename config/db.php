<?php

define('DB_SERVER', 'localhost');
define('DB_USERNAME', 'root');
define('DB_PASSWORD', '');
define('DB_NAME', 'cooks_delight_db');
define('BASE_URL', '/');

$conn = new mysqli(DB_SERVER, DB_USERNAME, DB_PASSWORD, DB_NAME);

if ($conn->connect_error) {
    die("Database connection failed: " . $conn->connect_error);
}

function secure_input($data) {
    global $conn;
    if (is_array($data)) {
        return array_map('secure_input', $data);
    }
    
    $data = trim($data);
    $data = stripslashes($data);
    $data = $conn->real_escape_string($data); 
    
    return $data;
}
?>