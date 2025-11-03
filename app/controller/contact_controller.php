<?php
require_once '../../config/db.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  $name    = trim($_POST['name'] ?? '');
  $email   = trim($_POST['email'] ?? '');
  $subject = trim($_POST['subject'] ?? '');
  $message = trim($_POST['message'] ?? '');

  if ($name === '' || $email === '' || $message === '') {
    header('Location: /Individual_Website/project/public/contact.php?error=1');
    exit;
  }

  $stmt = $conn->prepare("INSERT INTO contact_messages (name, email, subject, message) VALUES (?, ?, ?, ?)");
  $stmt->bind_param("ssss", $name, $email, $subject, $message);
  $ok = $stmt->execute();
  $stmt->close();

  if ($ok) {
    header('Location: /Individual_Website/project/public/contact.php?success=1');
  } else {
    header('Location: /Individual_Website/project/public/contact.php?error=2');
  }
  exit;
}
?>
