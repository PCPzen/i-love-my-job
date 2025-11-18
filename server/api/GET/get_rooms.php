<?php
require('../conn.php');
header('Content-Type: application/json; charset=UTF-8');

try {
    $sql = "SELECT room_id, room_name, building, capacity FROM room ORDER BY room_name";
    $stmt = $conn->prepare($sql);
    if (!$stmt) throw new Exception('Prepare failed: ' . $conn->error);
    $stmt->execute();
    $res = $stmt->get_result();
    $rows = $res->fetch_all(MYSQLI_ASSOC);
    echo json_encode($rows);
} catch (Exception $e) {
    echo json_encode(['status' => 'error', 'message' => $e->getMessage()]);
}

?>
