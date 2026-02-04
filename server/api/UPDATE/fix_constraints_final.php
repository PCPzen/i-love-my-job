<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: text/plain; charset=utf-8");

require_once '../conn.php';

echo "=== FIXING DATABASE CONSTRAINTS ===\n";

function dropFK($conn, $fkName) {
    echo "Attempting to drop $fkName... ";
    try {
        $conn->exec("ALTER TABLE create_study_table DROP FOREIGN KEY $fkName");
        echo "SUCCESS.\n";
    } catch (Exception $e) {
        $msg = $e->getMessage();
        if (strpos($msg, '1091') !== false) {
             echo "SKIPPED (Does not exist).\n";
        } else {
             echo "FAILED: $msg\n";
        }
    }
}

// 1. Drop Teacher FK (fix 1452 error)
dropFK($conn, 'FK_teacher_info_TO_create_study_table');

// 2. Drop Room FK (Prevent future error)
dropFK($conn, 'FK_room_TO_create_study_table');

echo "\n=== CURRENT SCHEMA ===\n";
try {
    $stmt = $conn->query("SHOW CREATE TABLE create_study_table");
    $row = $stmt->fetch(PDO::FETCH_ASSOC);
    echo $row['Create Table'];
} catch (Exception $e) { echo $e->getMessage(); }

?>
