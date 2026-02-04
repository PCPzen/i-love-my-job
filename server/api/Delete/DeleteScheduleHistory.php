<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include_once '../conn.php';

$data = json_decode(file_get_contents("php://input"));

if (!isset($data->infoid) || !isset($data->term)) {
    echo json_encode(['status' => 'error', 'message' => 'ข้อมูลไม่ครบถ้วน (infoid, term missing)']);
    exit;
}

$infoid = $data->infoid;
$term = $data->term;
$group = isset($data->group) ? $data->group : ''; 

try {
    $conn->beginTransaction();

    // 1. Get Course IDs associated with this Plan (infoid)
    $sql_get_courses = "SELECT courseid FROM course_information WHERE infoid = :infoid";
    $stmt_get_courses = $conn->prepare($sql_get_courses);
    $stmt_get_courses->bindParam(':infoid', $infoid, PDO::PARAM_INT);
    $stmt_get_courses->execute();
    $course_ids = $stmt_get_courses->fetchAll(PDO::FETCH_COLUMN);

    $deletedCount = 0;

    if (!empty($course_ids)) {
        // Create parameter placeholders
        $inQuery = implode(',', array_fill(0, count($course_ids), '?'));
        
        // Delete using CourseIDs AND Term AND Group (if provided)
        // If group is empty string, we might want to delete ALL for that term/infoid? 
        // Or strictly empty? Usually history has a specific group.
        
        // Let's use group condition strictly if it's passed, or handle empty?
        // SaveTotalSchedule uses group_section explicitly.
        
        $sql_delete = "DELETE FROM create_study_table WHERE courseid IN ($inQuery) AND term = ?";
        
        $params = [];
        foreach ($course_ids as $id) $params[] = $id;
        $params[] = $term;

        if ($group !== '') {
            $sql_delete .= " AND group_section = ?";
            $params[] = $group;
        }

        $stmt_delete = $conn->prepare($sql_delete);
        $stmt_delete->execute($params);
        $deletedCount = $stmt_delete->rowCount();
    }

    $conn->commit();

    if ($deletedCount > 0) {
        echo json_encode(['status' => 'success', 'message' => 'ลบข้อมูลตารางเรียนเรียบร้อยแล้ว']);
    } else {
        echo json_encode(['status' => 'success', 'message' => 'ไม่พบข้อมูลที่ต้องการลบ หรือข้อมูลถูกลบไปแล้ว']);
    }

} catch (Exception $e) {
    if ($conn->inTransaction()) {
        $conn->rollBack();
    }
    echo json_encode(['status' => 'error', 'message' => 'เกิดข้อผิดพลาด: ' . $e->getMessage()]);
}
?>
