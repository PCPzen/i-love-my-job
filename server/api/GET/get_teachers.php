<?php
// server/api/GET/get_teachers.php

// 1. ตั้งค่า Headers (สำคัญมาก)
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization, Origin, X-Requested-With");
header("Content-Type: application/json; charset=UTF-8");

// 2. จัดการ OPTIONS request
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit();
}

// 3. รวมไฟล์เชื่อมต่อฐานข้อมูล
require_once dirname(__FILE__) . '/../conn.php'; 

try {
    // 4. ดึงข้อมูลครูทั้งหมด
    $sql = "SELECT * FROM teacher_info ORDER BY teacher_id DESC";
    $stmt = $conn->prepare($sql);
    $stmt->execute();
    $result = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // 5. ส่งข้อมูลกลับ
    echo json_encode($result);

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['status' => 'error', 'message' => $e->getMessage()]);
}
?>