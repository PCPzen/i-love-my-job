<?php
header("Content-Type: application/json; charset=UTF-8");
require_once '../conn.php';

$planid = isset($_GET['planid']) ? $_GET['planid'] : null;

if (!$planid) {
    echo json_encode([]);
    exit;
}

try {
    $stmt = $conn->prepare("SELECT course_code, course_name FROM subject WHERE planid = :planid ORDER BY course_code ASC");
    $stmt->bindParam(':planid', $planid, PDO::PARAM_INT);
    $stmt->execute();
    $subjects = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode($subjects);
} catch (PDOException $e) {
    echo json_encode(["error" => $e->getMessage()]);
}
?>
