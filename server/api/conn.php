<?php  
$servername = "localhost";
$username   = "root";
$password   = "";
$dbname     = "cpss-2";

try {
    $conn = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // ❌ ลบ 3 บรรทัดนี้ออก (เป็นต้นตอ Access-Control-Allow-Origin ซ้ำ)
    // header("Access-Control-Allow-Origin: *");
    // header("Access-Control-Allow-Headers: Content-Type");
    // header("Access-Control-Allow-Methods: DELETE, GET, POST,PUT");

    // จะเหลือแค่ Content-Type ก็พอ
    header("Content-Type: application/json; charset=utf-8");
} catch(PDOException $e) {
    echo "Connection failed: " . $e->getMessage();
}

return $conn;
?>
