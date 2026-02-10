<?php
/**
 * @var PDO $conn
 */
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include_once '../conn.php';

// Start Logging
error_log('SaveTotalSchedule.php - เริ่มทำงาน');

/** @var object|null $data */
$data = json_decode(file_get_contents("php://input"));
error_log('ได้รับข้อมูล JSON: ' . json_encode([
    'has_infoid' => isset($data->infoid),
    'has_schedule' => isset($data->schedule),
    'infoid' => isset($data->infoid) ? $data->infoid : 'NULL',
    'term' => isset($data->term) ? $data->term : 'NULL',
    'group' => isset($data->group) ? $data->group : 'NULL',
    'schedule_count' => isset($data->schedule) ? count($data->schedule) : 0,
    'raw_input_length' => strlen(file_get_contents("php://input"))
]));

if (!isset($data->infoid) || !isset($data->schedule)) {
    echo json_encode(['status' => 'error', 'message' => 'ข้อมูลไม่ครบถ้วน (infoid or schedule missing)']);
    exit;
}

$infoid = $data->infoid;
$schedule = $data->schedule; // Array of objects
$term = isset($data->term) ? $data->term : '';
$group = isset($data->group) ? $data->group : ''; // Get group info

try {
    /** @var PDO $conn */
    $conn->beginTransaction();

    // 0. Update Group Information (Student Count, Year, Term, Group Name)
    $studentCount = isset($data->studentCount) ? $data->studentCount : null;
    $newYear = isset($data->year) ? $data->year : null;
    $newLevel = isset($data->sublevel) ? $data->sublevel : null;
    $newGroupName = isset($data->group) ? $data->group : null;

    if ($studentCount !== null || $newYear || $newLevel) {
        // Build dynamic update
        $fields = [];
        $params = [':infoid' => $infoid];

        if ($studentCount !== null) {
            $fields[] = "student_id = :count";
            $params[':count'] = $studentCount;
        }
        if ($newYear) {
            $fields[] = "year = :year";
            $params[':year'] = $newYear;
        }
        if ($newLevel) {
            $fields[] = "sublevel = :level";
            $params[':level'] = $newLevel;
        }
        if ($newGroupName) {
            $fields[] = "group_name = :gname";
            $params[':gname'] = $newGroupName;
        }

        if (!empty($fields)) {
            $sql_update_info = "UPDATE group_information SET " . implode(', ', $fields) . " WHERE infoid = :infoid";
            /** @var PDOStatement $stmt_update */
            $stmt_update = $conn->prepare($sql_update_info);
            foreach ($params as $k => $v) {
                $stmt_update->bindValue($k, $v);
            }
            $stmt_update->execute();
        }
    }

    // 1. Clear existing schedule for this Plan (infoid) AND Group Section
    $sql_get_courses = "SELECT courseid FROM course_information WHERE infoid = :infoid";
    /** @var PDOStatement $stmt_get_courses */
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
                   (courseid, teacher_id, room_id, `date`, start_time, end_time, term, group_section, item_group, central_room) 
                   VALUES (:courseid, :teacher_id, :room_id, :date, :start_time, :end_time, :term, :group_section, :item_group, :central_room)";
    /** @var PDOStatement $stmt_insert */
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
    $skipped_course = 0;
    $debug_log = [];

    // ===== OPTIMIZATION: Batch Validate All Teachers BEFORE Loop =====
    // Collect all unique teacher IDs from schedule
    $teacherIds = [];
    foreach ($schedule as $item) {
        if (!empty($item->teacher_id)) {
            $teacherIds[] = (int) $item->teacher_id;
        }
    }
    $teacherIds = array_unique($teacherIds);

    // Batch query: Validate all teachers in one query
    $validTeacherSet = [];
    if (!empty($teacherIds)) {
        $placeholders = implode(',', array_fill(0, count($teacherIds), '?'));
        /** @var PDOStatement $stmt_batch_teachers */
        $stmt_batch_teachers = $conn->prepare(
            "SELECT member_id FROM tb_member 
             WHERE member_id IN ($placeholders) AND member_type = 'teacher'"
        );
        $stmt_batch_teachers->execute($teacherIds);
        $validTeachers = $stmt_batch_teachers->fetchAll(PDO::FETCH_COLUMN);

        // Create hashmap for O(1) lookup
        $validTeacherSet = array_flip($validTeachers);
    }
    // ===== END OPTIMIZATION =====

    foreach ($schedule as $index => $item) {
        // Skip invalid items (No Course)
        if (empty($item->courseid)) {
            $skipped++;
            $skipped_course++;
            $debug_log[] = "Item $index: Skipped (No CourseID) - Please select subject from list";
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

        // ✅ OPTIMIZED: O(1) lookup instead of query
        $teacher_id_val = (int) $item->teacher_id;
        if (!isset($validTeacherSet[$teacher_id_val])) {
            $skipped++;
            $debug_log[] = "Item $index: Skipped (Invalid Teacher) - Teacher ID: $teacher_id_val";
            continue;
        }

        // Bind and Execute Insert
        $courseid_val = $item->courseid;
        $room_id_val = $item->room_id;

        $stmt_insert->bindValue(':courseid', $courseid_val, PDO::PARAM_INT);
        $stmt_insert->bindValue(':teacher_id', $teacher_id_val, PDO::PARAM_INT);
        $stmt_insert->bindValue(':room_id', $room_id_val, PDO::PARAM_INT);
        $stmt_insert->bindValue(':date', $item->day, PDO::PARAM_STR);
        $stmt_insert->bindValue(':start_time', $start_time_int, PDO::PARAM_INT);
        $stmt_insert->bindValue(':end_time', $end_time_int, PDO::PARAM_INT);
        $stmt_insert->bindValue(':term', $term, PDO::PARAM_STR);

        // CRITICAL FIX: Always bind group_section to the GLOBAL Header Group
        // This ensures they all end up in the same History Entry.
        $stmt_insert->bindValue(':group_section', $group, PDO::PARAM_STR);

        // Bind item_group for valid item-specific group data
        $itemGroup = isset($item->group_section) && !empty($item->group_section) ? $item->group_section : null;
        $stmt_insert->bindValue(':item_group', $itemGroup, PDO::PARAM_STR);

        // Bind central_room (can be null/empty)
        $centralRoom = isset($item->central_room) ? $item->central_room : null;
        $stmt_insert->bindValue(':central_room', $centralRoom, PDO::PARAM_INT);

        if (!$stmt_insert->execute()) {
            $err = implode(" ", $stmt_insert->errorInfo());
            $debug_log[] = "Item $index: Insert Failed - " . $err;
            file_put_contents("debug_last_save_log.txt", "Item $index Failed: $err\n", FILE_APPEND);
            error_log("SaveTotalSchedule Item $index Failed: $err");
        } else {
            $debug_log[] = "Item $index: Inserted successfully";
            error_log("SaveTotalSchedule Item $index Inserted successfully");
        }
    }

    $conn->commit();

    $msg = 'บันทึกข้อมูลตารางเรียนเรียบร้อยแล้ว';
    if ($skipped_course > 0) {
        $msg .= "\n(แจ้งเตือน: มี $skipped_course รายการไม่ถูกบันทึก เนื่องจากไม่พบรหัสวิชา กรุณาเลือกวิชาจากรายการเท่านั้น)";
    } elseif ($skipped > 0) {
        $msg .= " (ข้าม $skipped รายการที่ไม่ได้ระบุ ครู/ห้อง)";
    }

    echo json_encode(['status' => 'success', 'message' => $msg, 'debug' => $debug_log]);

} catch (Exception $e) {
    /** @var PDO $conn */
    error_log("SaveTotalSchedule EXCEPTION: " . $e->getMessage());
    if ($conn->inTransaction()) {
        $conn->rollBack();
        error_log("SaveTotalSchedule Transaction Rolled Back");
    }
    // Check for "Unknown column 'group_section'"
    if (strpos($e->getMessage(), "Unknown column 'group_section'") !== false) {
        echo json_encode(['status' => 'error', 'message' => 'Database Error: Missing "group_section". Update DB.']);
    }
    // Check for FK Constraint (1452)
    else if (strpos($e->getMessage(), "1452") !== false) {
        echo json_encode(['status' => 'error', 'message' => 'บันทึกไม่สำเร็จ: มีข้อมูล ครู หรือ ห้อง ที่ไม่ถูกต้อง (Foreign Key Error)']);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'เกิดข้อผิดพลาด: ' . $e->getMessage()]);
    }
}
?>