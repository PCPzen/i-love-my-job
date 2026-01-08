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
$group = isset($data->group) ? $data->group : ''; // Get group info

try {
    $conn->beginTransaction();

    // 0. Update Student Count in group_information (if provided)
    $studentCount = isset($data->studentCount) ? $data->studentCount : null;
    if ($studentCount !== null) {
        $sql_update_count = "UPDATE group_information SET student_id = :count WHERE infoid = :infoid";
        $stmt_update = $conn->prepare($sql_update_count);
        $stmt_update->bindParam(':count', $studentCount, PDO::PARAM_STR);
        $stmt_update->bindParam(':infoid', $infoid, PDO::PARAM_INT);
        $stmt_update->execute();
    }

    // 1. Clear existing schedule for this Plan (infoid) AND Group Section
    $sql_get_courses = "SELECT courseid FROM course_information WHERE infoid = :infoid";
    $stmt_get_courses = $conn->prepare($sql_get_courses);
    $stmt_get_courses->bindParam(':infoid', $infoid, PDO::PARAM_INT);
    $stmt_get_courses->execute();
    $course_ids = $stmt_get_courses->fetchAll(PDO::FETCH_COLUMN);

    if (!empty($course_ids)) {
        // Create parameter placeholders for IN clause
        $inQuery = implode(',', array_fill(0, count($course_ids), '?'));
        // Delete from create_study_table
        // Scoped by courseid, term, AND group_section
        $sql_delete = "DELETE FROM create_study_table WHERE courseid IN ($inQuery) AND term = ? AND group_section = ?";
        $stmt_delete = $conn->prepare($sql_delete);
        
        // Bind Course IDs
        foreach ($course_ids as $k => $id) {
            $stmt_delete->bindValue(($k + 1), $id, PDO::PARAM_INT);
        }
        
        // Bind Term and Group
        $stmt_delete->bindValue(count($course_ids) + 1, $term, PDO::PARAM_STR);
        $stmt_delete->bindValue(count($course_ids) + 2, $group, PDO::PARAM_STR);
        
        $stmt_delete->execute();
    }

    // 2. Insert new schedule items
    $sql_insert = "INSERT INTO create_study_table 
                   (courseid, teacher_id, room_id, `date`, start_time, end_time, term, group_section) 
                   VALUES (:courseid, :teacher_id, :room_id, :date, :start_time, :end_time, :term, :group_section)";
    $stmt_insert = $conn->prepare($sql_insert);

    // Standard Time Mapping (Period -> StartTime, EndTime)
    // Format: Int (HHMM) - Hardcoded to avoid dependency on missing 'timeslots' table
    $timeMap = [
        1 => ['start' => 800, 'end' => 900],
        2 => ['start' => 900, 'end' => 1000],
        3 => ['start' => 1000, 'end' => 1100],
        4 => ['start' => 1100, 'end' => 1200],
        // Lunch 1200-1300 usually skipped or accounted for logic
        5 => ['start' => 1300, 'end' => 1400],
        6 => ['start' => 1400, 'end' => 1500],
        7 => ['start' => 1500, 'end' => 1600],
        8 => ['start' => 1600, 'end' => 1700],
        9 => ['start' => 1700, 'end' => 1800],
        10 => ['start' => 1800, 'end' => 1900],
    ];

    $skipped = 0;
    $debug_log = [];

    foreach ($schedule as $index => $item) {
        // Skip invalid items (No Course)
        if (empty($item->courseid)) {
            $debug_log[] = "Item $index: Skipped (No CourseID)";
            continue;
        }

        // Skip items without Teacher or Room
        if (empty($item->teacher_id) || empty($item->room_id)) {
            $skipped++;
            $debug_log[] = "Item $index: Skipped (Missing Teacher/Room) - Course: {$item->courseid}";
            continue;
        }

        // Calculate Start Time
        $s_period = $item->start_period;
        $start_time_int = isset($timeMap[$s_period]) ? $timeMap[$s_period]['start'] : 0;

        // Calculate End Time
        $e_period = $item->end_period;
        $end_time_int = isset($timeMap[$e_period]) ? $timeMap[$e_period]['end'] : 0;

        if ($start_time_int == 0 || $end_time_int == 0) {
            $debug_log[] = "Item $index: Skipped (Invalid Time) - Period: $s_period - $e_period";
             continue; 
        }

        // Bind and Execute Insert
        $courseid_val = $item->courseid;
        $teacher_id_val = $item->teacher_id; 
        $room_id_val = $item->room_id;

        $stmt_insert->bindValue(':courseid', $courseid_val, PDO::PARAM_INT);
        $stmt_insert->bindValue(':teacher_id', $teacher_id_val, PDO::PARAM_INT);
        $stmt_insert->bindValue(':room_id', $room_id_val, PDO::PARAM_INT);
        $stmt_insert->bindValue(':date', $item->day, PDO::PARAM_STR);
        $stmt_insert->bindValue(':start_time', $start_time_int, PDO::PARAM_INT);
        $stmt_insert->bindValue(':end_time', $end_time_int, PDO::PARAM_INT);
        $stmt_insert->bindValue(':term', $term, PDO::PARAM_STR);
        $stmt_insert->bindValue(':group_section', $group, PDO::PARAM_STR);
        
        if (!$stmt_insert->execute()) {
             $debug_log[] = "Item $index: Insert Failed - " . implode(" ", $stmt_insert->errorInfo());
        } else {
             $debug_log[] = "Item $index: Inserted successfully";
        }
    }

    $conn->commit();
    
    $msg = 'บันทึกข้อมูลตารางเรียนเรียบร้อยแล้ว';
    if ($skipped > 0) {
        $msg .= " (ข้าม $skipped รายการที่ไม่ได้ระบุ ครู/ห้อง)";
    }
    
    echo json_encode(['status' => 'success', 'message' => $msg, 'debug' => $debug_log]);

} catch (Exception $e) {
    if ($conn->inTransaction()) {
        $conn->rollBack();
    }
    // Check for "Unknown column 'group_section'"
    if (strpos($e->getMessage(), "Unknown column 'group_section'") !== false) {
        echo json_encode(['status' => 'error', 'message' => 'Database Error: Missing "group_section". Update DB.']);
    } 
    // Check for FK Constraint (1452)
    else if (strpos($e->getMessage(), "1452") !== false) {
         echo json_encode(['status' => 'error', 'message' => 'บันทึกไม่สำเร็จ: มีข้อมูล ครู หรือ ห้อง ที่ไม่ถูกต้อง (Foreign Key Error)']);
    }
    else {
        echo json_encode(['status' => 'error', 'message' => 'เกิดข้อผิดพลาด: ' . $e->getMessage()]);
    }
}
?>