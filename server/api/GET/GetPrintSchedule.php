<?php
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');

include_once '../conn.php';

if (!isset($_GET['infoid']) || !isset($_GET['term']) || !isset($_GET['year'])) {
    echo json_encode(['status' => 'error', 'message' => 'ข้อมูลไม่ครบถ้วน (infoid, term, year)']);
    exit;
}

$infoid = $_GET['infoid'];
$term = $_GET['term'];
$year = $_GET['year'];

try {
    // Query หลัก: ดึงตารางเรียนตาม infoid (ผ่าน course_information), term, และ year
    $sql = "SELECT 
                cst.date, 
                cst.start_time, 
                cst.end_time,
                s.course_code, 
                s.course_name,
                t.first_name, 
                t.last_name,
                r.room_name
            FROM 
                create_study_table AS cst
            JOIN 
                course_information AS ci ON cst.courseid = ci.courseid
            JOIN 
                subject AS s ON ci.subject_id = s.subject_id
            JOIN 
                teacher_info AS t ON cst.teacher_id = t.teacher_id
            JOIN 
                room AS r ON cst.room_id = r.room_id
            WHERE 
                ci.infoid = ? 
                AND cst.term = ?  -- ใช้ term จาก create_study_table
                AND ci.year = ?"; // ใช้ year จาก course_information
    
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("iss", $infoid, $term, $year);
    $stmt->execute();
    $result = $stmt->get_result();
    
    $schedule = [];
    while ($row = $result->fetch_assoc()) {
        $schedule[] = $row;
    }
    
    echo json_encode($schedule);

} catch (Exception $e) {
    echo json_encode(['status' => 'error', 'message' => $e->getMessage()]);
}

$conn->close();
?>