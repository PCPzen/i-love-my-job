<?php
// server/api/POST/InsertTeacher.php

// 1. ตั้งค่า Headers เพื่อรองรับ CORS และระบุ Content-Type เป็น JSON
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization, Origin, X-Requested-With");
header("Content-Type: application/json; charset=UTF-8");

// 2. จัดการกับ pre-flight request (OPTIONS)
// ส่วนนี้จำเป็นเพื่อให้ Browser รู้ว่าสามารถส่ง POST request มาได้
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit();
}

// 3. รวมไฟล์เชื่อมต่อฐานข้อมูล
// ใช้ require_once และ dirname(__FILE__) เพื่อความแม่นยำของ Path
require_once dirname(__FILE__) . '/../conn.php'; 

try {
    // 4. รับข้อมูล JSON ที่ส่งมาจาก React
    $data = json_decode(file_get_contents("php://input"));

    // 5. ตรวจสอบความถูกต้องของข้อมูล (Validation)
    // ต้องมี คำนำหน้า, ชื่อ, นามสกุล เป็นอย่างน้อย
    if (
        !isset($data->prefix) ||
        !isset($data->first_name) ||
        !isset($data->last_name) ||
        empty($data->first_name) ||
        empty($data->last_name)
    ) {
        http_response_code(400); // 400 Bad Request (ส่งข้อมูลมาไม่ครบ)
        echo json_encode(['status' => 'error', 'message' => 'ข้อมูลไม่ครบถ้วน (กรุณาระบุ คำนำหน้า, ชื่อ, นามสกุล)']);
        exit();
    }

    // 6. เตรียมคำสั่ง SQL (Prepared Statement)
    // เพื่อป้องกัน SQL Injection และเพิ่มประสิทธิภาพ
    $sql = "INSERT INTO teacher_info (prefix, first_name, last_name, department, email, phone) 
            VALUES (:prefix, :first_name, :last_name, :department, :email, :phone)";
    
    $stmt = $conn->prepare($sql);

    // 7. Bind ค่าตัวแปรเข้ากับ SQL parameters
    // จัดการค่าว่างให้เป็น NULL สำหรับฟิลด์ที่ไม่บังคับ
    $department = !empty($data->department) ? $data->department : null;
    $email = !empty($data->email) ? $data->email : null;
    $phone = !empty($data->phone) ? $data->phone : null;

    $stmt->bindParam(':prefix', $data->prefix);
    $stmt->bindParam(':first_name', $data->first_name);
    $stmt->bindParam(':last_name', $data->last_name);
    $stmt->bindParam(':department', $department);
    $stmt->bindParam(':email', $email);
    $stmt->bindParam(':phone', $phone);

    // 8. รันคำสั่ง SQL
    if ($stmt->execute()) {
        http_response_code(201); // 201 Created (สร้างข้อมูลสำเร็จ)
        echo json_encode(['status' => 'success', 'message' => 'บันทึกข้อมูลครูผู้สอนสำเร็จ']);
    } else {
        http_response_code(500); // 500 Internal Server Error
        echo json_encode(['status' => 'error', 'message' => 'ไม่สามารถบันทึกข้อมูลลงฐานข้อมูลได้']);
    }

} catch (PDOException $e) {
    // จัดการ Error ของฐานข้อมูล
    http_response_code(500); // 500 Internal Server Error
    echo json_encode(['status' => 'error', 'message' => 'Database error: ' . $e->getMessage()]);
} catch (Exception $e) {
    // จัดการ Error ทั่วไปอื่นๆ
    http_response_code(500);
    echo json_encode(['status' => 'error', 'message' => 'Error: ' . $e->getMessage()]);
}

// ปิดการเชื่อมต่อ
$conn = null;
?>