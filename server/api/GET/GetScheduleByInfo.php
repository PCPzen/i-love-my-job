<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include_once '../conn.php';

$infoid = isset($_GET['infoid']) ? $_GET['infoid'] : null;
$term = isset($_GET['term']) ? $_GET['term'] : null;
$group = isset($_GET['group']) ? $_GET['group'] : ''; // Optional group filter

if (!$infoid || !$term) {
    echo json_encode(['error' => 'Missing infoid or term']);
    exit;
}

try {
    // 1. Fetch Header Info from group_information
    $sql_header = "SELECT gi.*, gi.student_id as student_count
                   FROM group_information gi 
                   WHERE gi.infoid = :infoid";
    $stmt_header = $conn->prepare($sql_header);
    $stmt_header->bindParam(':infoid', $infoid, PDO::PARAM_INT);
    $stmt_header->execute();
    $header_info = $stmt_header->fetch(PDO::FETCH_ASSOC);

    // 2. Fetch Schedule Data
    $sql = "SELECT 
                t.*,
                t.item_group,
                s.course_code,
                s.course_name,
                s.theory as theory_practice_l,
                s.comply as theory_practice_s,
                s.credit,
                te.member_firstname as teacher_first_name,
                te.member_lastname as teacher_last_name,
                r.room_name,
                cr.room_name as central_room_name
            FROM create_study_table t
            JOIN course_information c ON t.courseid = c.courseid
            LEFT JOIN subject s ON c.subject_id = s.subject_id
            LEFT JOIN tb_member te ON t.teacher_id = te.member_id
            LEFT JOIN room r ON t.room_id = r.room_id
            LEFT JOIN room cr ON t.central_room = cr.room_id
            WHERE c.infoid = :infoid AND t.term = :term";

    if ($group !== '') {
        $sql .= " AND t.group_section = :group";
    }

    $sql .= "
             ORDER BY FIELD(t.date, 'จันทร์', 'อังคาร', 'พุธ', 'พฤหัสบดี', 'ศุกร์'), t.start_time ASC";

    $stmt = $conn->prepare($sql);
    $stmt->bindParam(':infoid', $infoid, PDO::PARAM_INT);
    $stmt->bindParam(':term', $term, PDO::PARAM_STR);
    if ($group !== '') {
        $stmt->bindParam(':group', $group, PDO::PARAM_STR);
    }
    $stmt->execute();
    $schedule_data = $stmt->fetchAll(PDO::FETCH_ASSOC);

    $group_section = $group;
    if ($group_section === '' && !empty($schedule_data) && isset($schedule_data[0]['group_section'])) {
        $group_section = (string) $schedule_data[0]['group_section'];
    }

    if (!$header_info) {
        $header_info = [];
    }

    $header_info['term'] = $term;
    $header_info['group_section'] = $group_section;

    // Return combined result
    echo json_encode([
        'header_info' => $header_info,
        'schedule' => $schedule_data
    ]);

} catch (PDOException $e) {
    echo json_encode(['error' => $e->getMessage()]);
}