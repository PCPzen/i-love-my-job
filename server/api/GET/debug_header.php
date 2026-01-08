<?php
header("Content-Type: application/json");
include_once '../conn.php';

$infoid = 506; // Hardcoded from user report
$sql = "SELECT * FROM group_information WHERE infoid = :infoid";
$stmt = $conn->prepare($sql);
$stmt->bindParam(':infoid', $infoid);
$stmt->execute();
$data = $stmt->fetch(PDO::FETCH_ASSOC);

echo json_encode([
    'infoid' => $infoid,
    'found' => $data ? true : false,
    'data' => $data
]);
?>
