<?php
require_once '../conn.php';

header('Content-Type: text/plain; charset=utf-8');

echo "=== Debug Database Content ===\n";

try {
    // 1. Check total rows in create_study_table
    $stmt = $conn->query("SELECT COUNT(*) FROM create_study_table");
    $count = $stmt->fetchColumn();
    echo "Total rows in create_study_table: $count\n";

    if ($count > 0) {
        // 2. Check latest 5 rows
        echo "\n--- Latest 5 entries in create_study_table ---\n";
        $stmt = $conn->query("SELECT * FROM create_study_table ORDER BY field_id DESC LIMIT 5");
        $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
        foreach ($rows as $r) {
            print_r($r);
        }

        // 3. Check a Join Test
        echo "\n--- Testing Join Logic (History Query) ---\n";
        $sql = "SELECT DISTINCT 
                    cst.term, 
                    cst.group_section,
                    ci.infoid,
                    ci.year as course_year,
                    gi.sublevel,
                    gi.group_name
                FROM create_study_table cst
                LEFT JOIN course_information ci ON cst.courseid = ci.courseid
                LEFT JOIN group_information gi ON ci.infoid = gi.infoid
                ORDER BY cst.field_id DESC LIMIT 5";
        
        $stmt = $conn->query($sql);
        $joinRows = $stmt->fetchAll(PDO::FETCH_ASSOC);
        foreach ($joinRows as $r) {
            echo "Row: Term={$r['term']}, Group={$r['group_section']}, InfoID=" . ($r['infoid'] ?? 'NULL') . "\n";
            echo "     -> Linked Course Year: " . ($r['course_year'] ?? 'NULL') . "\n";
            echo "     -> Linked Group Name: " . ($r['group_name'] ?? 'NULL') . "\n";
            if (empty($r['infoid'])) echo "     [ERROR] No Course Info found for this courseid!\n";
            if (!empty($r['infoid']) && empty($r['group_name'])) echo "     [ERROR] InfoID {$r['infoid']} found, but no Group Info!\n";
            echo "----------------\n";
        }

    } else {
        echo "\n[WARNING] Table is empty! Save failed or data was deleted.\n";
    }

} catch (PDOException $e) {
    echo "Database Error: " . $e->getMessage();
}
?>
