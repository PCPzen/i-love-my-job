<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include_once '../conn.php';

$data = json_decode(file_get_contents("php://input"));

if (!isset($data->infoid) || !isset($data->schedule)) {
    echo json_encode(['status' => 'error', 'message' => 'ข้อมูลไม่ครบถ้วน (infoid or schedule missing)']);
    exit;
}

$infoid = $data->infoid;
$schedule = $data->schedule; // Array of objects
$term = isset($data->term) ? $data->term : '';

try {
    $conn->beginTransaction();

    // 1. Clear existing schedule for this Plan (infoid)
    // We find all courseids belonging to this infoid and delete their schedule entries
    // This allows overwrite behavior for the "Save" function.
    
    // First, verify we can find courses for this infoid
    $sql_get_courses = "SELECT courseid FROM course_information WHERE infoid = :infoid";
    $stmt_get_courses = $conn->prepare($sql_get_courses);
    $stmt_get_courses->bindParam(':infoid', $infoid, PDO::PARAM_INT);
    $stmt_get_courses->execute();
    $course_ids = $stmt_get_courses->fetchAll(PDO::FETCH_COLUMN);

    if (!empty($course_ids)) {
        // Create parameter placeholders for IN clause
        $inQuery = implode(',', array_fill(0, count($course_ids), '?'));
        // Delete from create_study_table
        $sql_delete = "DELETE FROM create_study_table WHERE courseid IN ($inQuery)";
        $stmt_delete = $conn->prepare($sql_delete);
        foreach ($course_ids as $k => $id) {
            $stmt_delete->bindValue(($k+1), $id, PDO::PARAM_INT);
        }
        $stmt_delete->execute();
    }

    // 2. Insert new schedule items
    $sql_insert = "INSERT INTO create_study_table 
                   (courseid, teacher_id, room_id, `date`, start_time, end_time, term) 
                   VALUES (:courseid, :teacher_id, :room_id, :date, :start_time, :end_time, :term)";
    $stmt_insert = $conn->prepare($sql_insert);

    // Prepare statement for time lookup
    $sql_time = "SELECT start_time, end_time FROM timeslots WHERE id = :id";
    $stmt_time_start = $conn->prepare("SELECT start_time FROM timeslots WHERE id = :id");
    $stmt_time_end = $conn->prepare("SELECT end_time FROM timeslots WHERE id = :id");

    foreach ($schedule as $item) {
        // Skip invalid items
        if (empty($item->courseid)) continue;

        // Calculate Start Time (from start_period)
        $stmt_time_start->bindParam(':id', $item->start_period, PDO::PARAM_INT);
        $stmt_time_start->execute();
        $row_start = $stmt_time_start->fetch(PDO::FETCH_ASSOC);
        
        // Calculate End Time (from end_period)
        $stmt_time_end->bindParam(':id', $item->end_period, PDO::PARAM_INT);
        $stmt_time_end->execute();
        $row_end = $stmt_time_end->fetch(PDO::FETCH_ASSOC);

        if (!$row_start || !$row_end) {
            // If time not found, skip or error? Let's skip safely but log?
            continue; 
        }

        $s_time_str = $row_start['start_time']; // e.g. "08:30"
        $e_time_str = $row_end['end_time'];     // e.g. "09:30" (Note: We use End Period's End Time)

        // Convert to Int (e.g. 830, 930)
        $start_time_int = (int) str_replace(':', '', $s_time_str);
        $end_time_int = (int) str_replace(':', '', $e_time_str);

        // Bind and Execute Insert
        $courseid_val = $item->courseid;
        $teacher_id_val = !empty($item->teacher_id) ? $item->teacher_id : null; // Allow null teacher? Schema might require int. 
        // If teacher_id is empty string, make it 0 or NULL? DB likely INT. 
        // Let's assume 0 if empty for safety if DB is strict not null default 0
        if (empty($teacher_id_val)) $teacher_id_val = 0;

        $room_id_val = !empty($item->room_id) ? $item->room_id : 0;

        $stmt_insert->bindValue(':courseid', $courseid_val, PDO::PARAM_INT);
        $stmt_insert->bindValue(':teacher_id', $teacher_id_val, PDO::PARAM_INT);
        $stmt_insert->bindValue(':room_id', $room_id_val, PDO::PARAM_INT);
        $stmt_insert->bindValue(':date', $item->day, PDO::PARAM_STR);
        $stmt_insert->bindValue(':start_time', $start_time_int, PDO::PARAM_INT);
        $stmt_insert->bindValue(':end_time', $end_time_int, PDO::PARAM_INT);
        $stmt_insert->bindValue(':term', $term, PDO::PARAM_STR);
        
        $stmt_insert->execute();
    }

    $conn->commit();
    echo json_encode(['status' => 'success', 'message' => 'บันทึกข้อมูลตารางเรียนเรียบร้อยแล้ว']);

} catch (Exception $e) {
    if ($conn->inTransaction()) {
        $conn->rollBack();
    }
    echo json_encode(['status' => 'error', 'message' => 'เกิดข้อผิดพลาด: ' . $e->getMessage()]);
}
?>
