<?php
include_once '../conn.php';

try {
    // Add item_group column if it doesn't exist
    $sql = "ALTER TABLE create_study_table ADD COLUMN item_group VARCHAR(100) NULL DEFAULT NULL AFTER group_section";
    $conn->exec($sql);
    echo "Successfully added 'item_group' column to create_study_table.";
} catch(PDOException $e) {
    if (strpos($e->getMessage(), "Duplicate column") !== false) {
        echo "Column 'item_group' already exists.";
    } else {
        echo "Error: " . $e->getMessage();
    }
}
?>
