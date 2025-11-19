<?php

header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');
include_once '../conn.php';

if (!isset($_GET['planid'])) {
    echo json_encode([]);
    exit;
}
$planid = $_GET['planid'];

// ดึง sublevel ที่ไม่ซ้ำกัน
$sql = "SELECT DISTINCT sublevel FROM group_information WHERE planid = ? AND sublevel IS NOT NULL ORDER BY sublevel";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $planid);
$stmt->execute();
$result = $stmt->get_result();
$levels = [];
while ($row = $result->fetch_assoc()) {
    $levels[] = $row;
}
echo json_encode($levels);
$conn->close();
?>