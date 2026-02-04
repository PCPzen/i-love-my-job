<?php
require_once '../conn.php';

header('Content-Type: text/plain; charset=utf-8');

echo "=== tb_member Schema Check ===\n";

try {
    // Check if table exists
    $stmt = $conn->query("SHOW TABLES LIKE 'tb_member'");
    if ($stmt->rowCount() == 0) {
        echo "[ERROR] Table 'tb_member' does not exist!\n";
        exit;
    }
    
    // Get table structure
    $stmt = $conn->query("DESCRIBE tb_member");
    $columns = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo "Columns in tb_member:\n";
    foreach ($columns as $col) {
        echo "- {$col['Field']} | Type: {$col['Type']} | Null: {$col['Null']} | Key: {$col['Key']} | Default: " . ($col['Default'] ?: 'NULL') . "\n";
    }
    
    // Check for member_id column
    $hasMemberId = false;
    foreach ($columns as $col) {
        if ($col['Field'] === 'member_id') {
            $hasMemberId = true;
            break;
        }
    }
    
    if (!$hasMemberId) {
        echo "\n[PROBLEM] Column 'member_id' not found in tb_member!\n";
        echo "Available columns: " . implode(', ', array_column($columns, 'Field')) . "\n";
    } else {
        echo "\n[OK] Column 'member_id' exists in tb_member\n";
    }
    
    // Check for teachers
    $stmt = $conn->query("SELECT COUNT(*) FROM tb_member WHERE member_type = 'teacher'");
    $teacherCount = $stmt->fetchColumn();
    echo "Teachers in tb_member: $teacherCount\n";
    
} catch (PDOException $e) {
    echo "Error: " . $e->getMessage() . "\n";
}
?>
