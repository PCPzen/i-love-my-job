<?php
// [FIX 4] สร้างไฟล์ API ที่ขาดหายไป
include_once '../conn.php'; // conn.php ควรจะตั้งค่า Header CORS ให้อยู่แล้ว

// ตั้งค่า Header CORS อีกครั้ง (เพื่อความปลอดภัย)
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

try {
    // สมมติว่าคุณได้สร้างตาราง 'timeslots' ตามที่ผมแนะนำในครั้งก่อน
    $stmt = $conn->prepare("SELECT id, start_time, end_time, label FROM timeslots ORDER BY start_time");
    $stmt->execute();
    
    $timeslots = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo json_encode($timeslots);

} catch (Exception $e) {
    echo json_encode(["status" => "error", "message" => "ไม่สามารถดึงข้อมูล timeslots: " . $e->getMessage()]);
}

$conn = null;
?>