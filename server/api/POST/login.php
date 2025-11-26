<?php
$conn = include "../conn.php"; // โหลด database connection

// รับข้อมูล JSON จาก React
$data = json_decode(file_get_contents("php://input"));

if (!empty($data->username) && !empty($data->password)) {
    $username = $data->username;
    $password = $data->password;

    // ค้นหาผู้ใช้จากฐานข้อมูล
    $query = "SELECT member_id, member_code, member_password FROM tb_member WHERE member_code = :username LIMIT 1";
    $stmt = $conn->prepare($query);
    $stmt->bindParam(":username", $username);
    $stmt->execute();

    if ($stmt->rowCount() > 0) {
        $row = $stmt->fetch(PDO::FETCH_ASSOC);
        if (password_verify($password, $row["member_password"])) {
            // สร้าง Token (ตัวอย่าง)
            $token = bin2hex(random_bytes(32));

            // ตอบกลับไปยัง React
            echo json_encode(["success" => true, "token" => $token, "user" => $row["member_code"]]);
        } else {
            echo json_encode(["success" => false, "message" => "รหัสผ่านไม่ถูกต้อง"]);
        }
    } else {
        echo json_encode(["success" => false, "message" => "ไม่พบชื่อผู้ใช้"]);
    }
} else {
    echo json_encode(["success" => false, "message" => "กรุณากรอกข้อมูลให้ครบถ้วน"]);
}
?>
