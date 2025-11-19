<?php
// server/api/GET/get_teachers.php

// ไม่ต้อง set Access-Control-Allow-Origin ตรงนี้แล้ว ให้ .htaccess จัดการ
header("Content-Type: application/json; charset=UTF-8");

require_once dirname(__FILE__) . '/../conn.php';

try {
    $sql = "SELECT teacher_id, prefix, first_name, last_name, department, email, phone
            FROM teacher_info
            ORDER BY teacher_id DESC";
    $stmt = $conn->prepare($sql);
    $stmt->execute();
    $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode($rows ?: []);
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode([
        'status' => 'error',
        'message' => 'Database error: ' . $e->getMessage()
    ]);
}

$conn = null;
