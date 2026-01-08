<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

require_once '../conn.php';

try {
    // Query to find distinct schedules (Year, Term, Infoid)
    // We join with group_information to get readable names (Level, Group)
    $sql = "SELECT DISTINCT 
                gi.year, 
                cst.term, 
                cst.group_section,
                ci.infoid,
                gi.sublevel,
                gi.group_name,
                gi.department,
                gi.student_id as student_count
            FROM create_study_table cst
            JOIN course_information ci ON cst.courseid = ci.courseid
            JOIN group_information gi ON ci.infoid = gi.infoid
            ORDER BY gi.year DESC, cst.term DESC, gi.sublevel ASC, cst.group_section ASC";

    $stmt = $conn->prepare($sql);
    $stmt->execute();
    $history = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode($history);

} catch (PDOException $e) {
    echo json_encode(['error' => $e->getMessage()]);
}
?>
