<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include_once '../conn.php';

try {
    // Select distinct groups that have at least one schedule entry
    // We join group_info -> course_info -> create_study_table
    // This ensures we only list groups that actually have saved schedule data.
    $sql = "SELECT DISTINCT 
                g.infoid, 
                g.group_name, 
                g.sublevel, 
                g.year, 
                t.term
            FROM group_information g
            JOIN course_information c ON g.infoid = c.infoid
            JOIN create_study_table t ON c.courseid = t.courseid
            ORDER BY g.year DESC, t.term DESC, g.sublevel ASC, g.group_name ASC";

    $stmt = $conn->prepare($sql);
    $stmt->execute();
    $result = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode($result);

} catch (PDOException $e) {
    echo json_encode(['error' => $e->getMessage()]);
}
?>