<?php
// server/api/UPDATE/UpdateTeacher.php

header("Content-Type: application/json; charset=UTF-8");

require_once dirname(__FILE__) . '/../conn.php';

try {
    // รองรับทั้ง PUT และ POST (จะใช้ axios.put ก็ได้ หรือ axios.post ก็ได้)
    if ($_SERVER['REQUEST_METHOD'] !== 'PUT' && $_SERVER['REQUEST_METHOD'] !== 'POST') {
        http_response_code(405);
        echo json_encode([
            'status' => 'error',
            'message' => 'Method not allowed'
        ]);
        exit();
    }

    $data = json_decode(file_get_contents("php://input"), true);

    $teacher_id = $data['teacher_id'] ?? null;
    $prefix     = $data['prefix']      ?? null;
    $first_name = $data['first_name']  ?? null;
    $last_name  = $data['last_name']   ?? null;
    $department = $data['department']  ?? null;
    $email      = $data['email']       ?? null;
    $phone      = $data['phone']       ?? null;

    // ตรวจข้อมูลบังคับ
    if (!$teacher_id || !$prefix || !$first_name || !$last_name) {
        http_response_code(400);
        echo json_encode([
            'status' => 'error',
            'message' => 'ข้อมูลไม่ครบถ้วน (ต้องมี teacher_id, คำนำหน้า, ชื่อ, นามสกุล)'
        ]);
        exit();
    }

    $sql = "UPDATE teacher_info
            SET prefix = :prefix,
                first_name = :first_name,
                last_name = :last_name,
                department = :department,
                email = :email,
                phone = :phone
            WHERE teacher_id = :teacher_id";

    $stmt = $conn->prepare($sql);
    $stmt->bindValue(':teacher_id', $teacher_id, PDO::PARAM_INT);
    $stmt->bindValue(':prefix', $prefix);
    $stmt->bindValue(':first_name', $first_name);
    $stmt->bindValue(':last_name', $last_name);
    $stmt->bindValue(':department', $department ?: null);
    $stmt->bindValue(':email', $email ?: null);
    $stmt->bindValue(':phone', $phone ?: null);

    $stmt->execute();

    if ($stmt->rowCount() > 0) {
        echo json_encode([
            'status' => 'success',
            'message' => 'อัปเดตข้อมูลครูผู้สอนสำเร็จ'
        ]);
    } else {
        // ไม่มีแถวถูกแก้ (อาจจะข้อมูลเหมือนเดิมอยู่แล้ว)
        echo json_encode([
            'status' => 'success',
            'message' => 'ไม่มีการเปลี่ยนแปลงข้อมูล หรือไม่พบครูผู้สอน'
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
