<?php
header("Access-Control-Allow-Origin: http://localhost:5173");
header('Content-Type: application/json');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Access-Control-Allow-Headers,Content-Type,Access-Control-Allow-Methods, Authorization, X-Requested-With');

include_once '../conn.php';


$data = json_decode(file_get_contents("php://input"));

// 1. ตรวจสอบข้อมูลที่ React ส่งมา
if (
    !isset($data->courseid) ||
    !isset($data->teacher_id) ||
    !isset($data->room_id) ||
    !isset($data->day_of_week) ||
    !isset($data->timeslot_id) ||
    !isset($data->term) ||
    !isset($data->year)
) {
    echo json_encode(['status' => 'error', 'message' => 'ข้อมูลไม่ครบถ้วน']);
    exit;
}

$courseid = $data->courseid;
$teacher_id = $data->teacher_id;
$room_id = $data->room_id;
$day_of_week = $data->day_of_week; // เช่น "จันทร์"
$timeslot_id = $data->timeslot_id; // เช่น 1, 2, 3
$term = $data->term;
$year = $data->year; // (ปี อาจจะไม่ต้องใช้ในตาราง create_study_table แต่ term อาจจะต้องใช้)

// 2. [สำคัญ] แปลง timeslot_id เป็น start_time และ end_time
// *** คุณต้องมีตาราง 'timeslots' ใน DB (ดูข้อ 3) ***
try {
    $sql_time = "SELECT start_time, end_time FROM timeslots WHERE id = ?";
    $stmt_time = $conn->prepare($sql_time);
    $stmt_time->bind_param("i", $timeslot_id);
    $stmt_time->execute();
    $result_time = $stmt_time->get_result();

    if ($result_time->num_rows == 0) {
        echo json_encode(['status' => 'error', 'message' => 'ไม่พบช่วงเวลา (timeslot) ที่ระบุ']);
        exit;
    }
    
    $time_row = $result_time->fetch_assoc();
    $start_time = $time_row['start_time']; // เช่น "08:00"
    $end_time = $time_row['end_time'];     // เช่น "09:00"

    // [แก้ไข] เปลี่ยน start_time, end_time เป็น int ตาม DB
    // เช่น "08:00" -> 800, "13:30" -> 1330
    $start_time_int = (int) str_replace(':', '', $start_time);
    $end_time_int = (int) str_replace(':', '', $end_time);


} catch (Exception $e) {
    echo json_encode(['status' => 'error', 'message' => 'เกิดข้อผิดพลาดในการดึงข้อมูลเวลา: ' . $e->getMessage()]);
    exit;
}

// 3. ตรรกะการตรวจสอบการชน (Conflict Check)
// (ใช้ $day_of_week, $start_time_int, $end_time_int)

// 3.1 ตรวจสอบ "ครู" ชน
$sql_check_teacher = "SELECT * FROM create_study_table 
                      WHERE teacher_id = ? AND date = ? 
                      AND (? < end_time AND ? > start_time)";
$stmt_check_teacher = $conn->prepare($sql_check_teacher);
$stmt_check_teacher->bind_param("isii", $teacher_id, $day_of_week, $start_time_int, $end_time_int);
$stmt_check_teacher->execute();
if ($stmt_check_teacher->get_result()->num_rows > 0) {
    echo json_encode(['status' => 'error', 'message' => 'ตารางชน: ครูท่านนี้มีสอนในเวลานี้แล้ว']);
    exit;
}

// 3.2 ตรวจสอบ "ห้อง" ชน
$sql_check_room = "SELECT * FROM create_study_table 
                   WHERE room_id = ? AND date = ? 
                   AND (? < end_time AND ? > start_time)";
$stmt_check_room = $conn->prepare($sql_check_room);
$stmt_check_room->bind_param("isii", $room_id, $day_of_week, $start_time_int, $end_time_int);
$stmt_check_room->execute();
if ($stmt_check_room->get_result()->num_rows > 0) {
    echo json_encode(['status' => 'error', 'message' => 'ตารางชน: ห้องนี้ถูกใช้ในเวลานี้แล้ว']);
    exit;
}

// 3.3 ตรวจสอบ "กลุ่มเรียน" ชน (หา infoid จาก courseid)
$sql_get_group = "SELECT infoid FROM course_information WHERE courseid = ?";
$stmt_get_group = $conn->prepare($sql_get_group);
$stmt_get_group->bind_param("i", $courseid);
$stmt_get_group->execute();
$res_group = $stmt_get_group->get_result();
if ($res_group->num_rows == 0) {
    echo json_encode(['status' => 'error', 'message' => 'ไม่พบข้อมูลกลุ่มสำหรับ courseid ที่ระบุ']);
    exit;
}
$info_row = $res_group->fetch_assoc();
$infoid = $info_row['infoid'];

$sql_check_group = "SELECT cst.* FROM create_study_table AS cst
                    JOIN course_information AS ci ON cst.courseid = ci.courseid
                    WHERE ci.infoid = ? AND cst.date = ?
                    AND (? < cst.end_time AND ? > cst.start_time)";
$stmt_check_group = $conn->prepare($sql_check_group);
$stmt_check_group->bind_param("isii", $infoid, $day_of_week, $start_time_int, $end_time_int);
$stmt_check_group->execute();
if ($stmt_check_group->get_result()->num_rows > 0) {
    echo json_encode(['status' => 'error', 'message' => 'ตารางชน: กลุ่มเรียนนี้มีเรียนวิชาอื่นในเวลานี้แล้ว']);
    exit;
}

// 4. ถ้าไม่ชน: บันทึกข้อมูล
try {
    // [แก้ไข] field ใน DB ของคุณคือ date, start_time, end_time, term
    $sql_insert = "INSERT INTO create_study_table 
                   (courseid, teacher_id, room_id, `date`, start_time, end_time, term) 
                   VALUES (?, ?, ?, ?, ?, ?, ?)";
    $stmt_insert = $conn->prepare($sql_insert);
    // ประเภทข้อมูล: int, int, int, string(date), int, int, string(term)
    $stmt_insert->bind_param("iiisiis", $courseid, $teacher_id, $room_id, $day_of_week, $start_time_int, $end_time_int, $term);

    if ($stmt_insert->execute()) {
        echo json_encode(['status' => 'success', 'message' => 'บันทึกตารางเรียนสำเร็จ']);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'เกิดข้อผิดพลาดในการบันทึก: ' . $stmt_insert->error]);
    }
} catch (Exception $e) {
    echo json_encode(['status' => 'error', 'message' => 'เกิดข้อผิดพลาด: ' . $e->getMessage()]);
}

$conn->close();
?>