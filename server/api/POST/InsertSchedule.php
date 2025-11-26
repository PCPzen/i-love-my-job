<?php
header("Access-Control-Allow-Origin: http://localhost:5173");
header('Content-Type: application/json');
header('Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With');

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
$year = $data->year;

// 2. [สำคัญ] แปลง timeslot_id เป็น start_time และ end_time
try {
    $sql_time = "SELECT start_time, end_time FROM timeslots WHERE id = :id";
    $stmt_time = $conn->prepare($sql_time);
    $stmt_time->bindParam(':id', $timeslot_id, PDO::PARAM_INT);
    $stmt_time->execute();

    if ($stmt_time->rowCount() == 0) {
        echo json_encode(['status' => 'error', 'message' => 'ไม่พบช่วงเวลา (timeslot) ที่ระบุ']);
        exit;
    }

    $time_row = $stmt_time->fetch(PDO::FETCH_ASSOC);
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

// 3.1 ตรวจสอบ "ครู" ชน
$sql_check_teacher = "SELECT * FROM create_study_table 
                      WHERE teacher_id = :teacher_id AND date = :date 
                      AND (:start_time < end_time AND :end_time > start_time)";
$stmt_check_teacher = $conn->prepare($sql_check_teacher);
$stmt_check_teacher->bindParam(':teacher_id', $teacher_id, PDO::PARAM_INT);
$stmt_check_teacher->bindParam(':date', $day_of_week, PDO::PARAM_STR);
$stmt_check_teacher->bindParam(':start_time', $start_time_int, PDO::PARAM_INT);
$stmt_check_teacher->bindParam(':end_time', $end_time_int, PDO::PARAM_INT);
$stmt_check_teacher->execute();

if ($stmt_check_teacher->rowCount() > 0) {
    echo json_encode(['status' => 'error', 'message' => 'ตารางชน: ครูท่านนี้มีสอนในเวลานี้แล้ว']);
    exit;
}

// 3.2 ตรวจสอบ "ห้อง" ชน
$sql_check_room = "SELECT * FROM create_study_table 
                   WHERE room_id = :room_id AND date = :date 
                   AND (:start_time < end_time AND :end_time > start_time)";
$stmt_check_room = $conn->prepare($sql_check_room);
$stmt_check_room->bindParam(':room_id', $room_id, PDO::PARAM_INT);
$stmt_check_room->bindParam(':date', $day_of_week, PDO::PARAM_STR);
$stmt_check_room->bindParam(':start_time', $start_time_int, PDO::PARAM_INT);
$stmt_check_room->bindParam(':end_time', $end_time_int, PDO::PARAM_INT);
$stmt_check_room->execute();

if ($stmt_check_room->rowCount() > 0) {
    echo json_encode(['status' => 'error', 'message' => 'ตารางชน: ห้องนี้ถูกใช้ในเวลานี้แล้ว']);
    exit;
}

// 3.3 ตรวจสอบ "กลุ่มเรียน" ชน (หา infoid จาก courseid)
$sql_get_group = "SELECT infoid FROM course_information WHERE courseid = :courseid";
$stmt_get_group = $conn->prepare($sql_get_group);
$stmt_get_group->bindParam(':courseid', $courseid, PDO::PARAM_INT);
$stmt_get_group->execute();

if ($stmt_get_group->rowCount() == 0) {
    echo json_encode(['status' => 'error', 'message' => 'ไม่พบข้อมูลกลุ่มสำหรับ courseid ที่ระบุ']);
    exit;
}
$info_row = $stmt_get_group->fetch(PDO::FETCH_ASSOC);
$infoid = $info_row['infoid'];

$sql_check_group = "SELECT cst.* FROM create_study_table AS cst
                    JOIN course_information AS ci ON cst.courseid = ci.courseid
                    WHERE ci.infoid = :infoid AND cst.date = :date
                    AND (:start_time < cst.end_time AND :end_time > cst.start_time)";
$stmt_check_group = $conn->prepare($sql_check_group);
$stmt_check_group->bindParam(':infoid', $infoid, PDO::PARAM_INT);
$stmt_check_group->bindParam(':date', $day_of_week, PDO::PARAM_STR);
$stmt_check_group->bindParam(':start_time', $start_time_int, PDO::PARAM_INT);
$stmt_check_group->bindParam(':end_time', $end_time_int, PDO::PARAM_INT);
$stmt_check_group->execute();

if ($stmt_check_group->rowCount() > 0) {
    echo json_encode(['status' => 'error', 'message' => 'ตารางชน: กลุ่มเรียนนี้มีเรียนวิชาอื่นในเวลานี้แล้ว']);
    exit;
}

// 4. ถ้าไม่ชน: บันทึกข้อมูล
try {
    $sql_insert = "INSERT INTO create_study_table 
                   (courseid, teacher_id, room_id, `date`, start_time, end_time, term) 
                   VALUES (:courseid, :teacher_id, :room_id, :date, :start_time, :end_time, :term)";
    $stmt_insert = $conn->prepare($sql_insert);
    $stmt_insert->bindParam(':courseid', $courseid, PDO::PARAM_INT);
    $stmt_insert->bindParam(':teacher_id', $teacher_id, PDO::PARAM_INT);
    $stmt_insert->bindParam(':room_id', $room_id, PDO::PARAM_INT);
    $stmt_insert->bindParam(':date', $day_of_week, PDO::PARAM_STR);
    $stmt_insert->bindParam(':start_time', $start_time_int, PDO::PARAM_INT);
    $stmt_insert->bindParam(':end_time', $end_time_int, PDO::PARAM_INT);
    $stmt_insert->bindParam(':term', $term, PDO::PARAM_STR);

    if ($stmt_insert->execute()) {
        echo json_encode(['status' => 'success', 'message' => 'บันทึกตารางเรียนสำเร็จ']);
    } else {
        // PDO throws exception on error usually, but just in case
        echo json_encode(['status' => 'error', 'message' => 'เกิดข้อผิดพลาดในการบันทึก']);
    }
} catch (Exception $e) {
    echo json_encode(['status' => 'error', 'message' => 'เกิดข้อผิดพลาด: ' . $e->getMessage()]);
}

$conn = null;
?>