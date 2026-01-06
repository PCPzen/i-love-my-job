<?php
header("Content-Type: application/json; charset=UTF-8");
require_once '../conn.php';

try {
    $stmt = $conn->prepare("SELECT subject_id, course_code, course_name, planid FROM subject ORDER BY subject_id ASC LIMIT 100");
    $stmt->execute();
    $subjects = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode([
        'status' => 'success',
        'count' => count($subjects),
        'data' => $subjects
    ]);
} catch (PDOException $e) {
    echo json_encode(["status" => "error", "message" => $e->getMessage()]);
}
?>