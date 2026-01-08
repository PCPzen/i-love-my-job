<?php
// server/api/GET/get_teachers.php

// ไม่ต้อง set Access-Control-Allow-Origin ตรงนี้แล้ว ให้ .htaccess จัดการ

require_once dirname(__FILE__) . '/../conn.php';

try {
    $sql = "SELECT member_id as teacher_id, member_title as prefix, member_firstname as first_name, member_lastname as last_name, 'Department' as department
            FROM tb_member
            WHERE member_type = 'teacher'
            ORDER BY member_firstname ASC";
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
