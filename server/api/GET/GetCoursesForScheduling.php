<?php
header("Content-Type: application/json; charset=UTF-8");
require_once '../conn.php';

// Expected GET params: year, term, planids (JSON array encoded)
$year = isset($_GET['year']) ? trim($_GET['year']) : null;
$term = isset($_GET['term']) ? trim($_GET['term']) : null;
$planidsRaw = isset($_GET['planids']) ? $_GET['planids'] : null;

if (empty($planidsRaw)) {
    echo json_encode([]);
    exit;
}

$planids = json_decode($planidsRaw, true);
if (!is_array($planids) || count($planids) === 0) {
    echo json_encode([]);
    exit;
}

// sanitize plan ids to integers
$planIdsInt = array_values(array_filter(array_map(function($v){ return is_numeric($v) ? intval($v) : null; }, $planids), function($v){ return $v !== null; }));
if (count($planIdsInt) === 0) {
    echo json_encode([]);
    exit;
}

try {
    // Build placeholders for IN clause
    $placeholders = implode(',', array_fill(0, count($planIdsInt), '?'));

    // We'll join course_information -> group_information -> subject -> study_plans
    $sql = "SELECT ci.infoid, gi.planid, ci.courseid, ci.year, ci.term, s.subject_id, s.course_code, s.course_name, s.theory, s.comply, s.credit, sp.course AS study_plan_course, sp.student_id AS study_plan_student_id
            FROM course_information ci
            JOIN group_information gi ON ci.infoid = gi.infoid
            JOIN subject s ON ci.subject_id = s.subject_id
            LEFT JOIN study_plans sp ON gi.planid = sp.planid
            WHERE gi.planid IN ($placeholders)";

    $params = $planIdsInt;

    // Strictly filter by course_information (ci) year/term if provided
    // Use only ci.year and ci.term to avoid pulling rows from other years
    if ($year !== null && $year !== '') {
        $sql .= " AND ci.year = ?";
        $params[] = $year;
    }

    if ($term !== null && $term !== '') {
        $sql .= " AND ci.term = ?";
        $params[] = $term;
    }

    // Order by planid then subject
    $sql .= " ORDER BY gi.planid ASC, s.subject_id ASC";

    $stmt = $conn->prepare($sql);
    $stmt->execute($params);
    $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Return rows (may be empty array)
    echo json_encode($rows, JSON_UNESCAPED_UNICODE);
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["error" => "Database error: " . $e->getMessage()]);
}

?>


