<?php
include_once '../conn.php';

try {
    $sql = "ALTER TABLE create_study_table ADD COLUMN central_room VARCHAR(50) DEFAULT NULL";
    $conn->exec($sql);
    echo "Column 'central_room' added successfully.";
} catch(PDOException $e) {
    echo "Error: " . $e->getMessage();
}
?>
