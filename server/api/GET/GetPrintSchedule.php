<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include_once '../conn.php';

$infoid = isset($_GET['infoid']) ? $_GET['infoid'] : null;
$term = isset($_GET['term']) ? $_GET['term'] : null;
$year = isset($_GET['year']) ? $_GET['year'] : null;

if (!$infoid || !$term || !$year) {
    echo json_encode(['status' => 'error', 'message' => 'ข้อมูลไม่ครบถ้วน (infoid, term, year)']);
    exit;
}

try {
    $sql = "SELECT 
                cst.date, 
                cst.start_time, 
                cst.end_time,
                s.course_code, 
                s.course_name,
                te.member_firstname as first_name, 
                te.member_lastname as last_name,
                r.room_name
            FROM 
                create_study_table AS cst
            JOIN 
                course_information AS ci ON cst.courseid = ci.courseid
            LEFT JOIN 
                subject AS s ON ci.subject_id = s.subject_id
            LEFT JOIN 
                tb_member AS te ON cst.teacher_id = te.member_id
            LEFT JOIN 
                room AS r ON cst.room_id = r.room_id
            WHERE 
                ci.infoid = :infoid 
                AND cst.term = :term
                AND ci.year = :year";

    $stmt = $conn->prepare($sql);
    $stmt->bindParam(':infoid', $infoid, PDO::PARAM_INT);
    $stmt->bindParam(':term', $term, PDO::PARAM_STR);
    $stmt->bindParam(':year', $year, PDO::PARAM_STR);
    $stmt->execute();
    $schedule = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode($schedule);

} catch (PDOException $e) {
    echo json_encode(['status' => 'error', 'message' => $e->getMessage()]);
}
?>