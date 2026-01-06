<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include_once '../conn.php';

$infoid = isset($_GET['infoid']) ? $_GET['infoid'] : null;
$term = isset($_GET['term']) ? $_GET['term'] : null;

if (!$infoid || !$term) {
    echo json_encode(['error' => 'Missing infoid or term']);
    exit;
}

try {
    // Fetch schedule for the specific Group (infoid) and Term
    // Join tables to get readable names
    // Note: We use LEFT JOIN because teacher/room might be null/0
    $sql = "SELECT 
                t.*,
                c.course_code,
                c.course_name,
                c.theory_practice_l,
                c.theory_practice_s,
                c.credit,
                te.first_name as teacher_first_name,
                te.last_name as teacher_last_name,
                r.room_name
            FROM create_study_table t
            JOIN course_information c ON t.courseid = c.courseid
            LEFT JOIN teacher te ON t.teacher_id = te.teacher_id
            LEFT JOIN room r ON t.room_id = r.room_id
            WHERE c.infoid = :infoid AND t.term = :term
            ORDER BY FIELD(t.date, 'จันทร์', 'อังคาร', 'พุธ', 'พฤหัสบดี', 'ศุกร์'), t.start_time ASC";

    $stmt = $conn->prepare($sql);
    $stmt->bindParam(':infoid', $infoid, PDO::PARAM_INT);
    $stmt->bindParam(':term', $term, PDO::PARAM_STR);
    $stmt->execute();
    $result = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode($result);

} catch (PDOException $e) {
    echo json_encode(['error' => $e->getMessage()]);
}
?>