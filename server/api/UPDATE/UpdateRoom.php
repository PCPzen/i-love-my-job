<?php
// server/api/UPDATE/UpdateRoom.php
require_once dirname(__FILE__) . '/../conn.php';
header("Content-Type: application/json; charset=UTF-8");

try {
    $data = json_decode(file_get_contents("php://input"), true);

    if (!$data) {
        http_response_code(400);
        echo json_encode(['status' => 'error', 'message' => 'รูปแบบข้อมูลไม่ถูกต้อง']);
        exit;
    }

    $room_id   = isset($data['room_id']) ? (int)$data['room_id'] : 0;
    $room_name = trim($data['room_name'] ?? '');
    $building  = trim($data['building']  ?? '');
    $capacity  = isset($data['capacity']) ? (int)$data['capacity'] : 0;
    $room_type = trim($data['room_type'] ?? 'Lecture');

    if ($room_id <= 0 || $room_name === '') {
        http_response_code(400);
        echo json_encode(['status' => 'error', 'message' => 'ข้อมูลไม่ครบถ้วน (room_id / ชื่อห้อง)']);
        exit;
    }

    $sql = "UPDATE room
            SET room_name = :room_name,
                building  = :building,
                capacity  = :capacity,
                room_type = :room_type
            WHERE room_id = :room_id";

    $stmt = $conn->prepare($sql);
    $stmt->bindParam(':room_name', $room_name);
    $stmt->bindParam(':building',  $building);
    $stmt->bindParam(':capacity',  $capacity, PDO::PARAM_INT);
    $stmt->bindParam(':room_type', $room_type);
    $stmt->bindParam(':room_id',   $room_id,   PDO::PARAM_INT);

    if ($stmt->execute()) {
        echo json_encode(['status' => 'success', 'message' => 'อัปเดตข้อมูลห้องเรียนสำเร็จ']);
    } else {
        http_response_code(500);
        echo json_encode(['status' => 'error', 'message' => 'ไม่สามารถอัปเดตข้อมูลได้']);
    }
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(['status' => 'error', 'message' => 'Database error: ' . $e->getMessage()]);
}

$conn = null;
