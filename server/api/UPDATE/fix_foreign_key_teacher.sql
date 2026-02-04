-- ============================================
-- แก้ไข Foreign Key ของตาราง create_study_table
-- ให้อ้างอิงไปที่ tb_member แทน teacher_info
-- ============================================

USE `cpss-2`;

-- 1. ลบ Foreign Key เก่าที่อ้างอิงไป teacher_info
ALTER TABLE `create_study_table` 
DROP FOREIGN KEY IF EXISTS `FK_teacher_info_TO_create_study_table`;

-- 2. สร้าง Foreign Key ใหม่ที่อ้างอิงไปที่ tb_member
ALTER TABLE `create_study_table` 
ADD CONSTRAINT `FK_tb_member_TO_create_study_table` 
FOREIGN KEY (`teacher_id`) 
REFERENCES `tb_member` (`member_id`) 
ON DELETE RESTRICT 
ON UPDATE CASCADE;

-- 3. ตรวจสอบว่า Foreign Key สำหรับ room ยังใช้งานได้หรือไม่
-- (ถ้ามี FK สำหรับ room_id อยู่แล้ว ไม่ต้องทำอะไร)
-- ALTER TABLE `create_study_table` 
-- ADD CONSTRAINT `FK_room_TO_create_study_table` 
-- FOREIGN KEY (`room_id`) 
-- REFERENCES `room` (`room_id`) 
-- ON DELETE RESTRICT 
-- ON UPDATE CASCADE;

-- เสร็จสิ้น
SELECT 'Foreign Key แก้ไขเรียบร้อยแล้ว' AS Status;
