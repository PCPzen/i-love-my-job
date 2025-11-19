<?php
require('../conn.php');
header('Content-Type: application/json; charset=UTF-8');

try {
    // ถ้ามี field room_type ในตาราง ให้ select มาด้วยเลย
    $sql = "SELECT room_id, room_name, building, capacity, room_type 
            FROM room 
            ORDER BY room_name";

    $stmt = $conn->prepare($sql);
    $stmt->execute();

    // ใช้ PDO::FETCH_ASSOC แทน get_result() / fetch_all ของ mysqli
    $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode($rows, JSON_UNESCAPED_UNICODE);
} catch (PDOException $e) {
    http_response_code(500); // ส่ง status 500 เวลา error
    echo json_encode([
        'status'  => 'error',
        'message' => $e->getMessage()
    ], JSON_UNESCAPED_UNICODE);
}
