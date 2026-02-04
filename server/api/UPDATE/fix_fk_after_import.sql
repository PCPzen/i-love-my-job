-- รันหลังจาก import ไฟล์ cpss-2.sql เสร็จแล้ว
-- คำสั่งนี้จะแก้ไข FK ให้ถูกต้องโดยไม่กระทบข้อมูลเก่า

USE `cpss-2`;

-- 1. ลบ FK เก่าที่ชี้ไป teacher_info (ถ้ามี)
ALTER TABLE `create_study_table` 
DROP FOREIGN KEY IF EXISTS `FK_teacher_info_TO_create_study_table`;

-- 2. สร้าง FK ใหม่ที่ชี้ไป tb_member (ตรงกับที่โค้ดตรวจสอบ)
ALTER TABLE `create_study_table` 
ADD CONSTRAINT `FK_tb_member_TO_create_study_table` 
FOREIGN KEY (`teacher_id`) 
REFERENCES `tb_member` (`member_id`) 
ON DELETE RESTRICT 
ON UPDATE CASCADE;

-- 3. ตรวจสอบว่า FK ถูกต้องแล้ว
SELECT 
    CONSTRAINT_NAME, 
    COLUMN_NAME, 
    REFERENCED_TABLE_NAME, 
    REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE 
WHERE TABLE_SCHEMA = 'cpss-2' 
  AND TABLE_NAME = 'create_study_table' 
  AND REFERENCED_TABLE_NAME IS NOT NULL;
