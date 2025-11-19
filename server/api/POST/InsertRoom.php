<?php
// server/api/POST/InsertRoom.php

require_once dirname(__FILE__) . '/../conn.php';

header("Content-Type: application/json; charset=UTF-8");

try {
    $data = json_decode(file_get_contents("php://input"), true);

    if (!$data) {
        http_response_code(400);
        echo json_encode(['status' => 'error', 'message' => 'รูปแบบข้อมูลไม่ถูกต้อง']);
        exit;
    }

    $room_name = trim($data['room_name'] ?? '');
    $building  = trim($data['building']  ?? '');
    $capacity  = isset($data['capacity']) ? (int)$data['capacity'] : 0;
    $room_type = trim($data['room_type'] ?? 'Lecture');

    if ($room_name === '') {
        http_response_code(400);
        echo json_encode(['status' => 'error', 'message' => 'กรุณาระบุชื่อห้องเรียน']);
        exit;
    }

    $sql = "INSERT INTO room (room_name, building, capacity, room_type)
            VALUES (:room_name, :building, :capacity, :room_type)";
    $stmt = $conn->prepare($sql);

    $stmt->bindParam(':room_name', $room_name);
    $stmt->bindParam(':building',  $building);
    $stmt->bindParam(':capacity',  $capacity, PDO::PARAM_INT);
    $stmt->bindParam(':room_type', $room_type);

    if ($stmt->execute()) {
        http_response_code(201);
        echo json_encode(['status' => 'success', 'message' => 'บันทึกข้อมูลห้องเรียนสำเร็จ']);
    } else {
        http_response_code(500);
        echo json_encode(['status' => 'error', 'message' => 'ไม่สามารถบันทึกข้อมูลได้']);
    }
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(['status' => 'error', 'message' => 'Database error: ' . $e->getMessage()]);
}

$conn = null;
