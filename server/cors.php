<?php
$origin = 'http://localhost:5173'; // ตรงกับที่เปิด Vite

header_remove("Access-Control-Allow-Origin");
// header("Access-Control-Allow-Origin: $origin");
// header("Vary: Origin");
// header("Access-Control-Allow-Credentials: false");
// header("Access-Control-Allow-Methods: GET, POST, PUT, PATCH, DELETE, OPTIONS");
// header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With");

// ถ้าเป็น preflight ให้ตอบและจบ
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
  http_response_code(204);
  exit();
}
