<?php
require("../conn.php");

header("Content-Type: application/json; charset=UTF-8");

// รับค่าที่ส่งมาจาก React
$term = $_GET['term'] ?? '';
$year = $_GET['year'] ?? '';

// ตรวจสอบว่ากรอกครบหรือยัง
if (empty($term) || empty($year)) {
    echo json_encode(["status" => "error", "message" => "Missing term or year"]);
    exit;
}

try {
    // ดึงข้อมูลจากฐานข้อมูล (เช่น ตาราง course_information)
    $stmt = $conn->prepare("SELECT * FROM course_information WHERE term = :term AND year = :year");
    $stmt->bindParam(":term", $term);
    $stmt->bindParam(":year", $year);
    $stmt->execute();

    $result = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode($result);
} catch (Exception $e) {
    echo json_encode(["status" => "error", "message" => $e->getMessage()]);
}
?>
