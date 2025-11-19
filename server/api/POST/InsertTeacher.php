<?php
// server/api/POST/InsertTeacher.php

// (ลบ Header Access-Control-Allow-* ออกทั้งหมด)
// ให้ .htaccess จัดการเรื่อง CORS

// ระบุว่า response เป็น JSON
header("Content-Type: application/json; charset=UTF-8");

// (ลบส่วนเช็ค OPTIONS ออก เพราะ .htaccess จัดการ RewriteRule ให้แล้ว)

// เชื่อมต่อฐานข้อมูล
require_once dirname(__FILE__) . '/../conn.php'; 

try {
    // รับข้อมูล JSON
    $data = json_decode(file_get_contents("php://input"));

    // ตรวจสอบข้อมูล (Validation)
    if (
        !isset($data->prefix) ||
        !isset($data->first_name) ||
        !isset($data->last_name) ||
        empty($data->first_name) ||
        empty($data->last_name)
    ) {
        http_response_code(400);
        echo json_encode(['status' => 'error', 'message' => 'ข้อมูลไม่ครบถ้วน (กรุณาระบุ คำนำหน้า, ชื่อ, นามสกุล)']);
        exit();
    }

    // เตรียม SQL
    $sql = "INSERT INTO teacher_info (prefix, first_name, last_name, department, email, phone) 
            VALUES (:prefix, :first_name, :last_name, :department, :email, :phone)";
    
    $stmt = $conn->prepare($sql);

    // Bind ค่า (จัดการค่าว่างเป็น NULL)
    $department = !empty($data->department) ? $data->department : null;
    $email = !empty($data->email) ? $data->email : null;
    $phone = !empty($data->phone) ? $data->phone : null;

    $stmt->bindParam(':prefix', $data->prefix);
    $stmt->bindParam(':first_name', $data->first_name);
    $stmt->bindParam(':last_name', $data->last_name);
    $stmt->bindParam(':department', $department);
    $stmt->bindParam(':email', $email);
    $stmt->bindParam(':phone', $phone);

    // Execute
    if ($stmt->execute()) {
        http_response_code(201);
        echo json_encode(['status' => 'success', 'message' => 'บันทึกข้อมูลครูผู้สอนสำเร็จ']);
    } else {
        http_response_code(500);
        echo json_encode(['status' => 'error', 'message' => 'ไม่สามารถบันทึกข้อมูลได้']);
    }

} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(['status' => 'error', 'message' => 'Database error: ' . $e->getMessage()]);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['status' => 'error', 'message' => 'Error: ' . $e->getMessage()]);
}

$conn = null;
?>