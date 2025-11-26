<?php
header("Access-Control-Allow-Origin: http://localhost:5173");
header('Content-Type: application/json');
header('Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With');

include_once '../conn.php';

if (!isset($_GET['planid'])) {
    echo json_encode([]);
    exit;
}
$planid = $_GET['planid'];

try {
    // ดึง sublevel ที่ไม่ซ้ำกัน
    $sql = "SELECT DISTINCT sublevel FROM group_information WHERE planid = :planid AND sublevel IS NOT NULL ORDER BY sublevel";
    $stmt = $conn->prepare($sql);
    $stmt->bindParam(':planid', $planid, PDO::PARAM_INT);
    $stmt->execute();

    $levels = $stmt->fetchAll(PDO::FETCH_ASSOC);
    echo json_encode($levels);
} catch (Exception $e) {
    echo json_encode(['error' => $e->getMessage()]);
}

$conn = null;
?>