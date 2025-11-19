<?php
// server/api/Delete/DeleteTeacher.php

header("Content-Type: application/json; charset=UTF-8");

require_once dirname(__FILE__) . '/../conn.php';

try {
    // รองรับทั้ง DELETE และ POST
    if ($_SERVER['REQUEST_METHOD'] !== 'DELETE' && $_SERVER['REQUEST_METHOD'] !== 'POST') {
        http_response_code(405);
        echo json_encode([
            'status' => 'error',
            'message' => 'Method not allowed'
        ]);
        exit();
    }

    $data = json_decode(file_get_contents("php://input"), true);
    $teacher_id = $data['teacher_id'] ?? null;

    if (!$teacher_id) {
        http_response_code(400);
        echo json_encode([
            'status' => 'error',
            'message' => 'ไม่พบค่า teacher_id'
        ]);
        exit();
    }

    $sql = "DELETE FROM teacher_info WHERE teacher_id = :teacher_id";
    $stmt = $conn->prepare($sql);
    $stmt->bindValue(':teacher_id', $teacher_id, PDO::PARAM_INT);
    $stmt->execute();

    if ($stmt->rowCount() > 0) {
        echo json_encode([
            'status' => 'success',
            'message' => 'ลบข้อมูลครูผู้สอนสำเร็จ'
        ]);
    } else {
        http_response_code(404);
        echo json_encode([
            'status' => 'error',
            'message' => 'ไม่พบครูผู้สอนที่ต้องการลบ'
        ]);
    }

} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode([
        'status' => 'error',
        'message' => 'Database error: ' . $e->getMessage()
    ]);
}

$conn = null;
