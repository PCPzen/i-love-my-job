<?php

require("../conn.php");
header("Content-Type: application/json; charset=UTF-8");


// Optional filters via GET: year (required for strict filtering), term (optional)
$year = isset($_GET['year']) ? trim($_GET['year']) : null;
$term = isset($_GET['term']) ? trim($_GET['term']) : null;

try {
    // Base query
    $sql = "SELECT * FROM study_plans";
    $params = [];

    // If year is provided, filter strictly on year
    if ($year !== null && $year !== '') {
        $sql .= " WHERE year = ?";
        $params[] = $year;
        // Note: study_plans table may not have a 'term' column; term filtering
        // for study plans is intentionally omitted. Term is used later when
        // fetching courses for selected plans.
    }

    // Ordering - keep original ordering where applicable
    $sql .= " ORDER BY year DESC, FIELD(course, 'หลักสูตรประกาศณียบัตรวิชาชีพ', 'หลักสูตรประกาศณียบัตรวิชาชีพขั้นสูง', 'หลักสูตรประกาศณียบัตรวิชาชีพขั้นสูง (ม.6)'), student_id DESC";

    $stmt = $conn->prepare($sql);
    $stmt->execute($params);
    $result = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode($result);
} catch (Exception $e) {
    echo json_encode(["status" => "error", "message" => $e->getMessage()]);
}

?>
