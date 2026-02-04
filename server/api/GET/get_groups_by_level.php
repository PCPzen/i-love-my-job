<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include_once '../conn.php';

$planid = isset($_GET['planid']) ? $_GET['planid'] : null;
$sublevel = isset($_GET['sublevel']) ? $_GET['sublevel'] : null;

if (!$planid || !$sublevel) {
    echo json_encode([]);
    exit;
}

try {
    // Select unique groups for the given plan and sublevel
    $sql = "SELECT DISTINCT infoid, group_name 
            FROM group_information 
            WHERE planid = :planid AND sublevel = :sublevel
            ORDER BY group_name ASC";
            
    $stmt = $conn->prepare($sql);
    $stmt->bindParam(':planid', $planid, PDO::PARAM_INT);
    $stmt->bindParam(':sublevel', $sublevel, PDO::PARAM_STR);
    $stmt->execute();
    
    $groups = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo json_encode($groups);

} catch (PDOException $e) {
    echo json_encode(['error' => $e->getMessage()]);
}
?>
