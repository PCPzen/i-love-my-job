-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 05, 2025 at 08:14 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `cpss-2`
--

-- --------------------------------------------------------

--
-- Table structure for table `course_information`
--

CREATE TABLE `course_information` (
  `courseid` int(11) NOT NULL,
  `planid` int(11) NOT NULL,
  `infoid` int(11) DEFAULT NULL,
  `subject_id` int(11) NOT NULL,
  `year` varchar(10) DEFAULT NULL,
  `term` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='แผนการเรียน';

--
-- Dumping data for table `course_information`
--

INSERT INTO `course_information` (`courseid`, `planid`, `infoid`, `subject_id`, `year`, `term`) VALUES
(353, 0, 504, 419, '2556', '1'),
(354, 0, 506, 420, '2567', '1'),
(355, 0, 506, 421, '2567', '1'),
(356, 0, 506, 422, '2567', '1'),
(357, 0, 506, 423, '2567', '1'),
(358, 0, 506, 424, '2567', '1'),
(359, 0, 506, 425, '2567', '1'),
(360, 0, 506, 426, '2567', '1');

-- --------------------------------------------------------

--
-- Table structure for table `create_study_table`
--

CREATE TABLE `create_study_table` (
  `field_id` int(11) NOT NULL,
  `teacher_id` int(11) NOT NULL,
  `courseid` int(11) NOT NULL,
  `room_id` int(11) NOT NULL,
  `planid` int(11) NOT NULL,
  `date` varchar(20) DEFAULT NULL,
  `start_time` int(11) DEFAULT NULL,
  `end_time` int(11) DEFAULT NULL,
  `status_category` tinyint(1) DEFAULT NULL,
  `status_carry_out` tinyint(1) DEFAULT NULL,
  `group_name` varchar(50) DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  `term` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='เก็บข้อมูลตารางเรียน';

-- --------------------------------------------------------

--
-- Table structure for table `group_information`
--

CREATE TABLE `group_information` (
  `infoid` int(11) NOT NULL,
  `planid` int(11) NOT NULL,
  `sublevel` varchar(11) DEFAULT NULL,
  `group_name` varchar(50) DEFAULT NULL,
  `term` int(11) DEFAULT NULL,
  `subterm` varchar(10) NOT NULL,
  `summer` int(11) DEFAULT NULL,
  `year` varchar(10) DEFAULT NULL,
  `student_id` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='เก็บกลุ่มการเรียน';

--
-- Dumping data for table `group_information`
--

INSERT INTO `group_information` (`infoid`, `planid`, `sublevel`, `group_name`, `term`, `subterm`, `summer`, `year`, `student_id`) VALUES
(504, 100, 'ปวส.1', '1', 2, '1-2', NULL, '2556', NULL),
(505, 100, NULL, '1', 2, '1-2', 2, '2', NULL),
(506, 101, 'ปวช.1', '1-2', 2, '1-2', NULL, '2567', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `more_plan`
--

CREATE TABLE `more_plan` (
  `more_id` int(11) NOT NULL,
  `planid` int(11) NOT NULL,
  `infoid` int(11) NOT NULL,
  `descriptionterm1` varchar(255) NOT NULL,
  `descriptionterm2` varchar(255) NOT NULL,
  `Headofdepartment` varchar(255) NOT NULL,
  `HeadofCurriculum` varchar(255) NOT NULL,
  `DeputyDirector` varchar(255) NOT NULL,
  `Director` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `room`
--

CREATE TABLE `room` (
  `room_id` int(11) NOT NULL,
  `room_name` varchar(50) DEFAULT NULL,
  `room_type` varchar(50) DEFAULT NULL,
  `capacity` int(11) DEFAULT NULL,
  `building` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='เก็บข้อมูลห้อง';

-- --------------------------------------------------------

--
-- Table structure for table `study_plans`
--

CREATE TABLE `study_plans` (
  `planid` int(11) NOT NULL,
  `course` varchar(255) DEFAULT NULL,
  `year` varchar(10) DEFAULT NULL,
  `student_id` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='เก็บปีการศึกษา';

--
-- Dumping data for table `study_plans`
--

INSERT INTO `study_plans` (`planid`, `course`, `year`, `student_id`) VALUES
(100, 'หลักสูตรประกาศณียบัตรวิชาชีพขั้นสูง', '2567', '68'),
(101, 'หลักสูตรประกาศณียบัตรวิชาชีพ', '2567', '65'),
(102, 'หลักสูตรประกาศณียบัตรวิชาชีพขั้นสูง (ม.6)', '2567', '67'),
(103, 'หลักสูตรประกาศณียบัตรวิชาชีพขั้นสูง', '2565', '65'),
(104, 'หลักสูตรประกาศณียบัตรวิชาชีพ', '2565', '68'),
(105, 'หลักสูตรประกาศณียบัตรวิชาชีพ', '2566', '66');

-- --------------------------------------------------------

--
-- Table structure for table `subject`
--

CREATE TABLE `subject` (
  `subject_id` int(11) NOT NULL,
  `course_code` varchar(50) DEFAULT NULL,
  `course_name` varchar(255) DEFAULT NULL,
  `theory` int(11) DEFAULT NULL,
  `comply` int(11) DEFAULT NULL,
  `credit` int(11) DEFAULT NULL,
  `subject_category` varchar(50) DEFAULT NULL,
  `subject_groups` varchar(50) DEFAULT NULL,
  `planid` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='เก็บตัววิชา';

--
-- Dumping data for table `subject`
--

INSERT INTO `subject` (`subject_id`, `course_code`, `course_name`, `theory`, `comply`, `credit`, `subject_category`, `subject_groups`, `planid`) VALUES
(419, '15123--', 'หฟก-/ๅ-/ๅหกหฟก', 1, 1, 2, '1.หมวดวิชาสมรรถนะแกนกลาง', '1.1 กลุ่มสมรรถนะภาษาและการสื่อสาร', 100),
(420, '20012-233', 'โครงการ', 1, 1, 2, '1.หมวดวิชาสมรรถนะแกนกลาง', '1.1 กลุ่มสมรรถนะภาษาและการสื่อสาร', 101),
(421, '15123-2321', 'idk', 1, 3, 2, '1.หมวดวิชาสมรรถนะแกนกลาง', '1.2 กลุ่มสมรรถนะการคิดและการแก้ปัญหา', 101),
(422, '21312-3213', '1kaoa', 2, 3, 1, '1.หมวดวิชาสมรรถนะแกนกลาง', '1.3 กลุ่มสมรรถนะสังคมและการดำรงชีวิต', 101),
(423, '21321-3213', 'sadsa', 3, 1, 1, '2.หมวดวิชาสมรรถนะวิชาชีพ', '2.1 กลุ่มสมรรถนะวิชาชีพพื้นฐาน', 101),
(424, '15123', '3213123', 3, 2, 2, '2.หมวดวิชาสมรรถนะวิชาชีพ', '2.2 กลุ่มสมรรถนะวิชาชีพเฉพาะ', 101),
(425, '32131-2321', '1221321', 1, 1, 1, '3.หมวดวิชาเลือกเสรี', '', 101),
(426, '23212-132', '321331', 2, 1, 1, '4.กิจกรรมเสริมหลักสูตร', '', 101);

-- --------------------------------------------------------

--
-- Table structure for table `tb_member`
--

CREATE TABLE `tb_member` (
  `member_id` int(11) NOT NULL,
  `member_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `member_password` varchar(255) DEFAULT NULL,
  `member_title` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `member_firstname` varchar(200) DEFAULT NULL,
  `member_lastname` varchar(200) NOT NULL,
  `member_gender` enum('1','2') DEFAULT NULL,
  `member_email` varchar(100) DEFAULT NULL,
  `member_tel` varchar(20) DEFAULT NULL,
  `member_mobile` varchar(20) NOT NULL,
  `member_fax` varchar(20) DEFAULT NULL,
  `member_address` varchar(255) DEFAULT NULL,
  `member_district` varchar(50) DEFAULT NULL,
  `province_id` int(5) NOT NULL,
  `member_zipcode` varchar(45) DEFAULT NULL,
  `member_registerdate` date DEFAULT NULL,
  `member_company` varchar(100) NOT NULL,
  `member_company_no` int(13) NOT NULL,
  `member_level` varchar(200) NOT NULL,
  `member_approve` enum('1','2') NOT NULL COMMENT 'อนุมัติ/ปฏิเสธ',
  `member_last_login` date NOT NULL,
  `member_note` text NOT NULL,
  `member_line_token` varchar(255) NOT NULL,
  `member_line_token2` varchar(255) NOT NULL,
  `member_line_token3` varchar(255) NOT NULL,
  `member_line_token4` varchar(255) NOT NULL,
  `member_line_token5` varchar(255) NOT NULL,
  `member_type` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `student_id` int(11) NOT NULL,
  `member_img` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `tb_member`
--

INSERT INTO `tb_member` (`member_id`, `member_code`, `member_password`, `member_title`, `member_firstname`, `member_lastname`, `member_gender`, `member_email`, `member_tel`, `member_mobile`, `member_fax`, `member_address`, `member_district`, `province_id`, `member_zipcode`, `member_registerdate`, `member_company`, `member_company_no`, `member_level`, `member_approve`, `member_last_login`, `member_note`, `member_line_token`, `member_line_token2`, `member_line_token3`, `member_line_token4`, `member_line_token5`, `member_type`, `student_id`, `member_img`) VALUES
(27, 'dangtoy', 'admin', 'นาย', 'แดงต้อย', 'คนธรรพ์', NULL, 'dang_toy@hotmail.com', NULL, '081-6028519', NULL, '134 หมู่ 4 ต.ร่องฟอง อ.เมือง จ.แพร่ 54000', NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', 'Ymsr0cPqQFvK4Ktx46PlPc5C5K4LmlNmX708kCx7tvJ', 'YQNGlU0IEcnv0iOTMdgQGB1Nx1EUYNlDPjPzUrz2pkR', 'QMJqtynaqpHI5FJkLs7aBnX6PonZOr2Fb8iDaNfhfvU', '', '', 'teacher', 0, ''),
(28, 'kitti', 'kitti', 'นาย', 'กิตติ', 'ไตรทิพยากร', NULL, NULL, NULL, '081-5312944', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', 'vez8A7Sv7Hux8vVt2ZOfkqI2Q0wYuyjYjrE2ywZCMm4', 'QYQUx7vxzH0T8R1NRTqof4x0Yr0Hftsy4dct1f4n7rq', '', '', '', 'teacher', 0, ''),
(29, 'teeraphong', '90b9aa7e25f80cf4f64e990b78a9fc5ebd6cecad', 'ว่าที่ ร.ต.', 'ธีระพงศ์', 'วงค์ตวัน', NULL, NULL, NULL, '087-5427052', NULL, '125/1 หมู่ 1 ต.บ้านปง อ.สูงเม่น จ.แพร่', NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '9PmF3KmubRjZyADbAXiAKHO8aSit1WXwuC003pbA4YM', 'SmVh7Qa5xv6wYRXKlRIVf4M57fr2WgEguXYpiCSknRT', '', '', '', 'teacher', 0, ''),
(30, 'pishaya', '90b9aa7e25f80cf4f64e990b78a9fc5ebd6cecad', 'นาย', 'พิชยะ', 'อุ่นอก', NULL, 'fancer1549900310725@gmail.com', NULL, '062-0267652', NULL, 'https://web.facebook.com/pishaya.aunaok', NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', 'TH24SJnIrZ9F0QkIoJTPIyJcNlDs8otPtzVHp3lhMXV', '', '', '', '', 'teacher', 0, ''),
(1765, 'orapan', '$2y$10$Yl0XepsATI9TBCUYMCkhfONxt85Fn9GCiJd2jXYlh8w3go/ujPiZS', 'นางสาว', 'อรพรรณ', 'มีศิลป์', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', 'R9ZxXTlUTVDFGzRRW5aGvELv2V8VSdYxFfl8UnNOANS', '2byn9UTyrD2lPZCLj4KcaHVSgFPhLkn1Umy1j3JgLyz', 'iRxcASHEkvh8QuCH8A1BzOavNM9tDXnrc8mwnQjOJd8', 'PNrV6ZDdItI0fcFKy0jybX2wOUC9WXNG2OTLA4j3gjz', '', 'teacher', 0, ''),
(1066, '6121280006', '32189cf2be2f33b47cbb90ec752b50e17390ebd4', 'นางสาว', 'ชลธิชา', 'ขันคำ', NULL, '', NULL, '', NULL, '283/1 ม.1 ต.ร่องกาศ อ.สูงเม่น จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1064, '6121280004', '281e145cfaf33b2365cc8f82356a6f3cf484b90c', 'นางสาว', 'จุฬาลักษณ์', 'แสนขัด', NULL, 'Julaluk3617@gmail.com', NULL, '0636627134', NULL, '36/1ม.7 ต.เวียงต้า อ.ลอง จ.แพร่', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1065, '6121280005', '75aabb4c286557068d8fe91c05792d7fd489f4c3', 'นาย', 'เทวัญ', 'จะเฮิง', NULL, 'off3216@hotmail.co.th', NULL, '0979974910', NULL, '109 ม.1 ต.บ้านเวียง อ.ร้องกวาง. จ.เเพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1063, '6121280003', '396c4992cef5229c45d7f712209c7ed1a9a163b6', 'นางสาว', 'ชญานิศ', 'ประเทศ', NULL, '', NULL, '0990845121', NULL, '111/8 ม.8 ต.ไทรย้อย อ.เด่นชัย จ.แพร่', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1061, '6121280001', 'eb68adf1717bb10a47368d2d626ac23f91bf1687', 'นางสาว', 'สุภัสสร', 'หงษ์เหาะ', NULL, 'tottarew00@gmail.com', NULL, '0638937679', NULL, '157 ม.10 ต.แม่จั๊วะ อ.เด่นชัย จ.แพร่', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1062, '6121280002', 'c1459219f3acd37ec8aca97bae22a7fc7b885fae', 'นางสาว', 'วัชราภรณ์', 'เนตรนำ', NULL, 'watcharaphonnetnam@gnail.com', NULL, '0622874343', NULL, '227 หมู่10 ต.นาพูน อ.วังชิ้น\nจ.แพร่', NULL, 175, '54160', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1059, '6131280032', '63982e54a7aeb0d89910475ba6dbd3ca6dd4e5a1', 'นาย', 'นพดล', 'ทองสุขแก้ว', NULL, 'noppadon69.mw@gmail.com', NULL, '0846494487', NULL, '126/1 ม.5 ต.เด่นชัย อ.เด่นชัย จ.แพร่ ', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1060, '6131280033', '904a6a0c9a9bc9f4f33c82da033ad6f3237cab6c', 'นาย', 'กฤษฎา', 'กันทะกะ', NULL, 'tonton_2542@hotmail.com', NULL, '0954967504', NULL, '54/1 ม.1 ต.ไทรย้อย อ.เด่นชัย จ.แพร่', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1058, '6131280031', '066240faec7adeb859034b91ce3deb017189504e', 'นาย', 'กฤตภาส', 'กลิ่นจันทร์', NULL, 'nunopro010@gmail.com', NULL, '0949241130', NULL, '248/7 ยันตรกิจโกศล  อ.เมือง ต.เวียง ', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1056, '6131280029', '7e89537a8dce9da8803a575da74bd136b0cc4627', 'นาย', 'ธีรเมธ', 'กันยะมูล', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1057, '6131280030', '67a74306b06d0c01624fe0d0249a570f4d093747', 'นาย', 'ชนกชนม์', 'เนตรทิพย์', NULL, 'fgfvg66@hotmail.com', NULL, '0918483185', NULL, '', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1054, '6131280027', '7fa362cf2f0357f5de24ce2c572b5609d04b2aa0', 'นางสาว', 'จิราภรณ์', 'วงศ์สิงห์', NULL, 'Neemzaza@gmail.com', NULL, '0987470630', NULL, '134 ม.1 ต.นาจักร อ.เมือง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1055, '6131280028', '67a74306b06d0c01624fe0d0249a570f4d093747', 'นาย', 'นันทวัฒน์', 'ปิงยศ', NULL, 'Mylovrs_104@hotmail.com', NULL, '0622782391', NULL, '34/2 ม.1 ต.หัวทุ่ง อ.ลอง จ.แพร่', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1053, '6131280026', '63982e54a7aeb0d89910475ba6dbd3ca6dd4e5a1', 'นาย', 'วงศกร', 'วงค์ฉายา', NULL, '', NULL, '0908931648', NULL, '400/494 ต.นาจักร อ.เมือง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1051, '6131280024', 'ae6a56269470cce121c1ee9fba0165e2e1b998aa', 'นาย', 'สรวิชญ์ ', 'เขื่อนแข', NULL, 'llnjlnw2030@gmail.com', NULL, '096-8911756', NULL, '44/3 บ.หนองแขม\nต.ป่าแดง อ.เมือง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1052, '6131280025', '7497c882b92481019d323cb611fa3bb095cea651', 'นาย', 'พงศ์ภัค', 'ทับทิมอ่อน', NULL, 'Folkfolkza1234@hotmail.com', NULL, '0956879711', NULL, '26/2 ถ.เหมืองหิต ต.ในเวียง อ.เมือง จ.เเพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1050, '6131280023', '83a9aad83e72344d13d54195d332c507caf734e7', 'นาย', 'ชุติพนธ์', 'ชุติภากุล', NULL, 'noteza1230@gmail.com', NULL, '0945188725', NULL, '51/1 หมู่ 2 ต.หัวฝาย อ.สูงเม่น', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1048, '6131280021', '9a1b67e6c32838e644db7621c120281a3894b1eb', 'นาย', 'ศตวรรษ', 'วันดี', NULL, 'satawatwandi@gmail.com', NULL, '0992934123', NULL, '221/1 ม.9 ต.ป่าแดง อ.เมือง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1049, '6131280022', '63982e54a7aeb0d89910475ba6dbd3ca6dd4e5a1', 'นาย', 'ณัฐดนัย', 'รุ่งเรือง', NULL, '', NULL, '', NULL, '', NULL, 175, '', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1046, '6131280019', '67a74306b06d0c01624fe0d0249a570f4d093747', 'นาย', 'อธิป', 'ธินวน', NULL, ' athip282@hotmail.com', NULL, '0945145280', NULL, '124/2 บ้านไผ่ล้อม อ.ลอง จ.แพร่ ต.หัวทุ่ง', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1047, '6131280020', '67a74306b06d0c01624fe0d0249a570f4d093747', 'นาย', 'นรากร', 'หงษ์ทอง', NULL, 'Bankkcom2541@gmail.con', NULL, '0846165168', NULL, '79/1 หมู่11 บ้านวังฟ่อน ต.หัวเมือง อ.สอง จ.แพร่', NULL, 175, '54120', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1045, '6131280018', '67a74306b06d0c01624fe0d0249a570f4d093747', 'นาย', 'สมาพล', 'ภูมิสถาน', NULL, 'samapolzaza@gmail.com', NULL, '0965420027', NULL, '123/1 หมู่.7 ตำบล.ไทรย้อย อำเภอ.เด่นชัย จังหวัด.เเพร่ ', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1043, '6131280016', '67a74306b06d0c01624fe0d0249a570f4d093747', 'นางสาว', 'รัชฎา', 'แสงคำมา', NULL, 'Ratchada.sangcomma@gmail.com ', NULL, '0951257856', NULL, '178 ม.1 ต.แม่ยม อ.เมือง\nจ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1044, '6131280017', '2209cc8f43bccdc613bdf9a5ae89d291f34054cd', 'นาย', 'ณัฐพล ', 'สันป่าแก้ว', NULL, 'bas54140205123@gmail.com', NULL, '0958383994', NULL, '65/3', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1041, '6131280014', '27a433edc0dbd95441094166d11ea1788bcf9a65', 'นาย', 'ณัฐดนัย', 'แสงทอง', NULL, 'Natdanai185@gmail.com', NULL, '0613130418', NULL, '111 ม.8 ต.ต้าผามอก อ.ลอง จ.แพร่', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1042, '6131280015', '67a74306b06d0c01624fe0d0249a570f4d093747', 'นาย', 'อนุวัฒน์', 'สุขอาษา', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1040, '6131280013', 'e543e091c5cd444b613d5fe18be74af8bbf7ba15', 'นาย', 'จตุรภัทร', 'แสงทวี', NULL, 'hotzamol2@gmail.com', NULL, '0929239693', NULL, '78/2 ม.5 ต.ป่าแมต อ.เมือง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1038, '6131280011', '63982e54a7aeb0d89910475ba6dbd3ca6dd4e5a1', 'นาย', 'หรรษวัต ', 'สงวนศักดิ์', NULL, 'husawat046@gmail.com', NULL, '0910769188', NULL, '20​ หมู่.1 ต.สูงเม่น​ อ.สูงเม่น​ ', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1039, '6131280012', 'bb551f1e7861c3cac4183b38d11ac0c1f106a5f8', 'นาย', 'ชัยวิชญ์', 'ทานัด', NULL, 'chaiyawichthanat@gmail.com', NULL, '0903231488', NULL, '5/1 เหมืองหิต ในเวียง เมืองแพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1036, '6131280009', '92e2394c83a1a796d94f37f3181a1b470958a7f9', 'นาย', 'นพรัตน์', 'สืบส่ง', NULL, 'book-212-25@outlook.com', NULL, '0992724775', NULL, '39 หมู่ที่ 10 ต.ป่าแดง อ.เมือง', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1037, '6131280010', '10470c3b4b1fed12c3baac014be15fac67c6e815', 'นาย', 'กฤตนัย', 'สุยานะ', NULL, 'Kittanai4427@gmail.com', NULL, '0617154427', NULL, '97ม.6ต.นาจักร อ.เมือง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1028, '6131280001', '5069095b52c1feb7422ce6b12cb7654032ff9485', 'นาย', 'ศวกร', 'ร่มโพธิเงิน', NULL, 'fonnyboy43@gmail.com', NULL, '0954504221', NULL, '134/1 ม.7 ต.สูงเม่น อ.สูงเม่น จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1029, '6131280002', '7c9791d3df37cd3045a7bc8b6a2624b8bfa32c41', 'นาย', 'ปราชญ์', 'ดีประดวง', NULL, 'pradlovegig_za2009@hotmail.com', NULL, '0981368659', NULL, '187/1 ม.5 บ้านใน ต.บ้านปิน อ.ลอง จ.แพร่', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1030, '6131280003', '08bb11ae5b4889a2c4237f9bc489ae6b9ab390bd', 'นาย', 'ณัฐกิตต์', 'หงษ์สิบแปด', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1031, '6131280004', '67a74306b06d0c01624fe0d0249a570f4d093747', 'นาย', 'สิริวัฒน์', 'ทิมา', NULL, 'ntocomloveza383@gmail.com', NULL, '0993162405', NULL, '6 ม.2 ต.ร้องเข็ม อ.ร้องกวาง', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1032, '6131280005', '90b9aa7e25f80cf4f64e990b78a9fc5ebd6cecad', 'นาย', 'ภูมิภัทร', 'แสนบูราญ', NULL, 'pp09_cosmos@hotmail.com', NULL, '0959609116', NULL, '175 หมู่12 ตำบลหัวฝาย อำเภอสูงเม่น จังหวัดแพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1033, '6131280006', '67a74306b06d0c01624fe0d0249a570f4d093747', 'นางสาว', 'จารุวรรณ', 'ปราบปราม', NULL, 'bes_oom_1999@hotmail.com', NULL, '0888072761', NULL, '34หมู่1ต.ปงป่าหวายอ.เด่นชัยจ.แพร่', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1034, '6131280007', '67a74306b06d0c01624fe0d0249a570f4d093747', 'นาย', 'ศุภกร', 'กันหา', NULL, 'Wim123you@hotmail.com', NULL, '0953247813', NULL, '118/2 บ้านแม่ลานพัฒนา หมู่14 ต.ห้วยอ้อ อ.ลอง จ.แพร่', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1035, '6131280008', '9133b70fe3fb302f53b7ae9bd99e50022545a18b', 'นาย', 'กฤตภาส', 'ฟุ่มเฟือย', NULL, 'potakak30@gmail.com', NULL, '0931386356', NULL, '156/2 หมู่4 ต.เหมืองหม้อ เมือง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1150, '6131280114', '44675f70c9fb308291145e0e8c6b0568f271638c', 'นาย', 'นครินทร์', 'กลิ่นเกตุ', NULL, '', NULL, '0808061727', NULL, '75 หมู่5 ต.แม่ป้าก อ.วังชิ้น จ.แพร่', NULL, 175, '54160', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1110, '6121280049', 'af81588839d9b137e1c4785fa724f33adcc85903', 'นาย', 'ธนพล  ', 'ผายาว', NULL, 'notebew1@gmail.com', NULL, '0613712181', NULL, '1/3 ม.3 ต.ทุ่งโฮ้ง อ.เมือง จ.แพร่ ', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1104, '6121280044', '0b68785dc0b7780384d117ba1c0420c3cb59565e', 'นาย', 'ณัฐนนท์', 'หอมจันทร์', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1105, '6121280045', 'ce7b2a86ba152fadaba969650d728965168e25a1', 'นาย', 'ศุภวิชญ์', 'แหวนหลวง', NULL, 'suphawit.3493@gmail.com', NULL, '0865623493', NULL, '', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1106, '6121280046', '7473eaca027e278cc53f1c516eb3e0cda3b837eb', 'นาย', 'โยธิน', 'มั่งคั่ง', NULL, 'flukeyotin@gmail.com', NULL, '0619368475', NULL, '200 หมู่ 3 ต.พระหลวง อ.สูงเม่น จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1107, '6121280047', '9d821d715b1f3cead3facfd0ac7d0eb2221f0125', 'นางสาว', 'รวิชา', 'ด้วงอินทร์', NULL, 'baicharilakch@gmail.com', NULL, '0932199967', NULL, '6 ม.3 ต.น้ำชำ อ.สูงเม่น แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1103, '6121280043', 'ab1247bf6fe1af33a15638dbeb00e89427f562a6', 'นาย', 'นนทวัฒน์', 'จันทร์สุข', NULL, 'nontawatchansuk857@gmail.com', NULL, '0888069710', NULL, '127 หมู่9 ตำบลเวียงทอง อำเภอสูงเม่น จังหวัดแพร่ ', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1101, '6121280041', 'f0c395dbefce87345c7f6ec9d4980ec2c6a527ff', 'นาย', 'พิชญะ', 'พองาม', NULL, '', NULL, '0650145983', NULL, '102 หมู่1 ต.นาพูน อ.วังชิ้น จ.แพร่', NULL, 175, '54160', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1102, '6121280042', 'bf652cd90ddaefcf4e4e37e2b0ff1601aba8dbcf', 'นาย', 'กฤตภัค', 'ตั้งตระกูลรัตนกร', NULL, 'krittapak1112@gmail.com', NULL, '0969259192', NULL, '92/2 ม.5 ต.แม่จั๊วะ อ.เด่นชัย จ.แพร่', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1100, '6121280040', 'e81ac48592d58d8fc810e5b78df49524a0498f30', 'นาย', 'ปกรณ์', 'ภู่ ปรางค์', NULL, 'pon116710@gmail.com', NULL, '0951293641', NULL, '152 ต.บ เตาปูน อ.ภ สอง\n \nจ.วเเพร่', NULL, 175, '54120', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1098, '6121280038', '787d06d074e979896340dfb6491b3177ed442535', 'นาย', 'พงศธร', 'สงวนเชื้อ', NULL, 'liljames@gmail.com', NULL, '0946311661', NULL, '151/6 บ.บวกโป่ง ต.น้ำชำ อ.สูงเม่น จ.แพร่ 54130', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1099, '6121280039', '410c872fa4120ad361665578d4e0edd6ebca112d', 'นาย', 'นันทิพัฒน์', 'สมบัติวงศ์', NULL, 'lebeno211059@gmail.com', NULL, '0991260098', NULL, '99 ม.3 ต.นาจักร อ.เมือง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(791, '6031280002', 'a346bc80408d9b2a5063fd1bddb20e2d5586ec30', 'นาย', 'นนทกานต์', 'เต็มใจ', NULL, 'nontakan_2541@hotmail.com', NULL, '082-4805136', NULL, '21/1 ม.4 ต.เวียงทอง อ.สูงเม่น จ.แพร่ 54000', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(792, '6031280003', 'eb51e8d5f7832dda80be1baef97c8f8c3034407e', 'นาย', 'พิเชษฐ์', 'สุกสีทอง', NULL, '', NULL, '0947342398', NULL, '113 หมู่4 ตำบล ทุ่งโฮ้ง อำเภอเมือง จังหวัดแพร่ ', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1151, '6131280115', 'c76c45598f63dec9f3fe723e489c4cd46e616402', 'นาย', 'ธนวัฒน์', 'พลแหลม', NULL, 'Thanawatpollma@gmail.com', NULL, '0948436795', NULL, '92/1 หมู่6 ทุ่งโฮ้ง \nอำเภอเมือง จังหวัดเเพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1134, '6121280072', 'e5f3d2b95d353bf3c11fd73166ef3df9f7c80641', 'นางสาว', 'วธูสิริ  ', 'กาศสนุก', NULL, 'Kogtom9674635535467@gmail.com', NULL, '0979590713', NULL, '181/1 ม.5 ต.บ้านเหล่า อ.สูงเม่น จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1132, '6121280070', '9e696c690fe8ad88ddab65a6e5a11d92187130e4', 'นางสาว', 'อังคณา ', '  อ่อนใจ', NULL, '', NULL, '0613147036', NULL, '', NULL, 160, '', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1133, '6121280071', '024f589e2c127f795d11da417f7c8059c0030662', 'นางสาว', 'นริศรา ', ' ศิริลักษณ์', NULL, '-', NULL, '0877266461', NULL, '56/1หมู่4 ต.ต้าผามอก อ.ลอง จ.แพร่', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1131, '6121280069', '0057b0e8cfdd5749c5c22c4bec793b4c9c4a4e25', 'นาย', 'อัศวิน  ', ' กฤษดาวณิชย์', NULL, '', NULL, '064343829', NULL, '', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1129, '6121280067', 'b59c0ca292be6d8cc072ae1654b6651039f47ee2', 'นางสาว', 'เกษฎาภรณ์  ', 'ขีดเหมาะ', NULL, NULL, NULL, '0931350125', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1130, '6121280068', '84bf9344e8ab9c49f85a0f5c9dc3bd65dde4b420', 'นางสาว', 'ทิพย์ฑิฌา ', 'ดวงดาว', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1091, '6121280031', '3e7bca803a5f9e2ffc413d4be9b1722a74d7a906', 'นาย', 'วิทวัส', 'ภิระบรรณ์', NULL, 'boomkung2560@gmail.com', NULL, '0830274739', NULL, '123/1 บ้านวังเลียง หมู่7 ต.ทุุ่งแล้ง อ.ลอง จ.แพร่', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1092, '6121280032', '98fbf46240e7c674832da0c71ebb3b7c4260d4a3', 'นางสาว', 'สุรีวรรณ', 'ฐาปะนา', NULL, 'surrwan456@gmail.com', NULL, '0645070768', NULL, '33 หมู่4 ต.บ้านถิ่น อ.เมือง จ.แพร่\n', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1094, '6121280034', '9ae6091d4985775af033afe3fe6300aec208fd22', 'นาย', 'พัสกร', 'บทศรี', NULL, 'pblove-t10@hotmail.com', NULL, '0828944088', NULL, '116 หมู่5 ต.กาจญนา อ.เมือง จ.เเพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1095, '6121280035', 'c4f4b3049ef923fb0c17926eadf94aa233db9ee3', 'นาย', 'ฐิติพันธิ์', 'มณีอินทร์', NULL, '', NULL, '0637595395', NULL, '', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1096, '6121280036', 'd1d2632251fce889654dbefc4fa9cce57c481cc9', 'นาย', 'สิทธินนท์', 'นะภิใจ', NULL, '', NULL, '0960162268', NULL, '\n', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1097, '6121280037', '606757a88e46a9fb41bd492ec240e0f093a6607b', 'นาย', 'สุรพัศ', 'สุภาพ', NULL, '', NULL, '0987480792', NULL, 'tgmt4445@gmail.com\n\n64/1 หมู่3 ต.ร่องกาศ อ.สูงเม่น จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1127, '6121280065', 'b30934ca9a6d8e91fb1d77b6010bdcda15d05f74', 'นาย', 'ณัฐพล  ', 'เวียงนิล ', NULL, 'nutthapolwiengnin@gmail.com', NULL, '0992720545', NULL, '39/2 หมูุ่ ตำบลเวียงทอง', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1128, '6121280066', 'c4e770e5c1d9d84f8694731f23974005be3cc0e8', 'นาย', 'วสิษฐ์พล   ', 'แสนกือ', NULL, '', NULL, '0647478241', NULL, '100 ม.13  ต.บ้านเวียง อ.ร้องกวาง จ.แพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1126, '6121280064', 'b598e87a2e7fb1f99413f6fa7bdb6d16b511c88a', 'นาย', 'วรวุฒิ  ', 'หล่ายแปด', NULL, NULL, NULL, '0650643393', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1124, '6121280062', '4dbe93b2e5b4aad0d7aec641f30e3077931b5aa3', 'นาย', 'จิรภัทร  ', 'วงค์มณี', NULL, 'first19503@gmail.com', NULL, '09823558335', NULL, '234/1 หมู่ 5 ต.บ้านเหล่า อ.สูงเม่น จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1125, '6121280063', '7284ea8fe9eeca7e8ace4449646e229c15c9c56d', 'นาย', 'ศรศิลป์   ', 'อินทรรุจิกุล', NULL, NULL, NULL, '0952306979', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1123, '6121280061', '8370e368fdbcc7207b12dd7b031fd85f6d23e436', 'นาย', 'จักรกฤษ  ', 'ชุมแสน', NULL, NULL, NULL, '0985074013', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1122, '6121280060', '7ea880ecb7c3b2c72ce94c3eb1a475dacc4aab5c', 'นาย', 'วีรภัทร   ', 'ฉัตรสงวนชัย', NULL, '', NULL, '0931401623', NULL, '19/5  ม.2  ต.ป่าแมต\nอ.เมืองแพร่  จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1087, '6121280027', 'aae634fbc222bc6701cb5df1ff4e502b30f0e8f9', 'นาย', 'ศุภกิตติ์', 'กุกอง', NULL, 'firsthonlol@gmail.com', NULL, '0902389025', NULL, '123  หมู่4 ต.บ้านปง อ.สูงเม่น\nจ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1089, '6121280029', '3a58e201251eb30de1598394e2247fd2032760bb', 'นาย', 'ธีรภัทร', 'สันป่าแก้ว', NULL, 'Treerapong19722@gmail.com', NULL, '084610783', NULL, '145 ถ.เหม่องแดง ต.ในเวียง อ.เมืองแพร่ จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1090, '6121280030', '832e80979b150ca9e471327097a71df3861786d1', 'นาย', 'นราธิป', 'ทาคำ', NULL, 'Narathiptakam@gmail.com', NULL, '0924617473', NULL, '169 หมู่1 ต.นาพูน อ.วังชิ้น จ.แพร่', NULL, 175, '54160', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1118, '6121280056', 'cfb4179be59e397127758aa8876a599c7a7cbd14', 'นาย', 'พีรทัต', ' พรมศักดิ์', NULL, '', NULL, '0645801553', NULL, '27. ม.4', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1116, '6121280055', 'ec069f1995760ba42a201966f11b2473e2c1779b', 'นาย', 'จิรวัฒน์', 'ขุนเงิน', NULL, 'zajirawat@gmail.com', NULL, '0949512637', NULL, 'บ.ท้าล้อ อ.สูงเม่น ต.หัวฟาย ม.13\nจ.แพร่ 143', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1086, '6121280026', 'e12f90f94418a299dc63746329aa65bee9fb7861', 'นาย', 'พลพัต', 'ทรวงหิรัญ', NULL, 'MandalinZ@hotmail.com', NULL, '0997135383', NULL, '52/1 หมู่ 1 ต.ทุ่งกวาว อ.เมืองแพร่ จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1070, '6121280010', 'e2bbac810c4c0713125603ffbb65f02f5ecbf15f', 'นางสาว', 'รุ่งทิวา', 'ดวงจันทร์', NULL, '', NULL, '0951266331', NULL, '28/4 หมู่10 ต.ไทรย้อย อ.เด่นชัย จ.แพร่', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1071, '6121280011', '6957245d39bc33fe17975949520d765e1a490c02', 'นาย', 'เจษฎา', 'แสนสุภา', NULL, 'killza3505@gmail.com', NULL, '0613162043', NULL, '16/1 ม.4 ต.น้ำเลา อ.ร้องกวาง จ.แพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1072, '6121280012', '301e766c0f392f8c2f7829f0f8dc2b3b237d993f', 'นาย', 'จีรัชญ์', 'เอี่ยมวิจารญ์', NULL, 'phoochirat@gmail.com', NULL, '0806733083', NULL, '166/102 ถ.ยันตรกิจโกศล ต.ในเวียง อ.เมือง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1073, '6121280013', '7f78dbf32ac6cd7795c1aa8738750da035b08cb8', 'นางสาว', 'ศิริวรรณ ', 'กอบกำ', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1074, '6121280014', '5eae91f8aa9acacb6b801d708f42d406beba2239', 'นาย', 'อนุรัตน์', 'สมใจ', NULL, 'Penpieapple014@gmail.com', NULL, '0957753259', NULL, '195/1 หมู่5 ต.วังหงส์\nอ.เมือง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1075, '6121280015', 'bc2c59f3400eb80aae9ba33a6facb200e38746eb', 'นาย', 'ไชยวุฒิ', 'ธิฟู', NULL, '', NULL, '0620244838', NULL, '73หมู่7ต.เวียงต้าอ.ลองจ.แพร่', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1076, '6121280016', '11c0c9490b759af85de705ac972b8f3a3e77e51a', 'นาย', 'วงศ์กร ', 'คำวง', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1077, '6121280017', '9586b3ada69fc1e0c89c7b6b9baa40fe2ad2b7b1', 'นางสาว', 'พอฤทัย', 'ชมภูมิ่ง', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1078, '6121280018', '25b3e97c43159ccd1e5dd20f6c6855e638bbe78f', 'นาย', 'กิตติพงศ์', 'ยะทะนะ', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1079, '6121280019', '7238394a9504108917284fe994a343a53681258c', 'นาย', 'ชยางกูร', 'อุจัจฉทราภรณ์', NULL, 'arttrade0066@gmail.com', NULL, '0640498047', NULL, '171 หมู่5 ต.เเม่ยางร้อง อ.ร้องกวาง จ.เเพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1080, '6121280020', '70ebf0a986d8cb5194e204d2af7f0a44739fa06d', 'นาย', 'ปกรณ์เกียรติ', 'สุวรรณกาศ', NULL, '', NULL, '0800542257', NULL, '165', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1081, '6121280021', 'b2ab845d5c6e2a893bad617fa14da8bb4611071c', 'นาย', 'นนทวัฒน์', 'คันที', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1082, '6121280022', '4345dfed20c292334dffb0bf0c0770daae2b6690', 'นาย', 'ฐานทัพ', 'สิงสา', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1083, '6121280023', '5c9b3af82b5e354e5dd0a26b598f5109833787ee', 'นาย', 'รัชานนท์', 'บุญมาภิ', NULL, '', NULL, '0808538143', NULL, '18​ หมู่3​ต.แท่ทราย​ อ.ร้องกวาง​ จ.แพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1084, '6121280024', '1b61e9ced1620512afdc0cf06975e2cb4a6219c5', 'นาย', 'ภูวดล', 'จันทร์ใจ', NULL, 'ballgohome0123@gmail.com', NULL, '0987942804', NULL, '80 หมู่11 ต.บ้านเวียง อ.ร้องกวาง จ.แพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1085, '6121280025', 'fd16b355a6dfb5633ff3b3a4d42777a075c364e6', 'นาย', 'อรรคพัทธ์', 'คำปินตา', NULL, 'flam__005flam@hotmail.com', NULL, '0931476898', NULL, '52หมู่3 ต.บ้านเวียง อ.ร้องกวาง จ.แพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1114, '6121280053', '000e74959bc11fe7df8cf12e9c6a38d55e80dc1f', 'นาย', 'ธนาวุฒิ ', 'คงขำ', NULL, '25arrow25ch@gmail.com', NULL, '0636635278', NULL, '1/26 หมู่6 ต.เหมืองหม้อ อ.เมือง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1115, '6121280054', '1a4aa113123392d4a8748fa63feacc0dc232a052', 'นางสาว', 'สุริวิภา  ', 'เชียวชูศักดิ์', NULL, 'dee1234950@gmail.com', NULL, '0980932818', NULL, '233 หมู่ 4 ตำบล.บ้านปง  อำเภอ.สูงเม่น จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1111, '6121280074', 'e63c0b49cf941b8b4fa39be87c4f549dd679dad6', 'นางสาว', 'เปรมญดา ', ' ชื่นสมบัติ', NULL, 'beamoriginal78@gmail.com', NULL, '0969019330', NULL, '', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1112, '6121280051', 'b2f7f076fe03d5aa5c08698c282920976b847fec', 'นาย', 'ภูมิพัฒน์ ', 'จันชุ่ม', NULL, 'phumiphat186@gmail.com', NULL, '965306783', NULL, '165/4 ม.1 อ.สูงเม่น จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1067, '6121280007', '72a2a9b47dfca7d2ecb0f845c26bd918bcb08cd5', 'นาย', 'ณัฐวุฒิ', 'ภูจีวร', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(790, '6031280001', 'c14a251b38c41f52e6a2e924d789326a194ec3a6', 'นาย', 'พิชยุทธ', 'ตามูล', NULL, 'stillblackheart@hotmail.com', NULL, '0882280121', NULL, '15/4 หมู่ 4 บ้านเกี๋ยงพา ต.ต้าผามอก อ.ลอง จ.แพร่', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(793, '6031280004', '29d1634182f76c8df50d773b88123157bf09dda7', 'นาย', 'นพรัตน์', 'พัฒนจันทร์', NULL, 'boatexia9@gmail.com', NULL, '0612182768', NULL, '163 หมู่ที่ 5 ตำบล ทุ่งกวาว\nอำเภอเมือง จังหวัด แพร่ ', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(794, '6031280005', '16f127bc8101c34dca587706df1c822696f5e225', 'นาย', 'วิทวัส', 'ยะปะนันท์', NULL, 'witthawatyapa@gmail.com', NULL, '0909122608', NULL, '271 ม.6 ต.ห้วยอ้อ อ.ลอง จ.แพร่', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(795, '6031280006', '10802d732fcb481f58a476857031d04b529b7869', 'นางสาว', 'กัลย์สุดา', 'โลกคำลือ', NULL, 'ikansuda1998@gmail.com', NULL, '0816767960', NULL, 'บ้านเลขที่ 144 ม.3 ต.หัวเมือง อ.สอง จ.แพร่ ', NULL, 175, '54120', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(796, '6031280007', 'edbe1ffe3423f96292194ba6e8dc411d893331c5', 'นางสาว', 'ทาริกา', 'สมบูรณ์', NULL, 'tarika.5756@gmail.com', NULL, '0641866917', NULL, '106 หมู่6 ตำบล เหมืองหม้อ อำเภอ เมือง จังหวัด แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(797, '6031280008', '48ef818ad8c9e4bc201863a7c89a6a524d834ce2', 'นาย', 'เชิดชัย', 'วันลังกา', NULL, 'jangvanlangka@hotmail.com', NULL, '0645065424', NULL, '202/1หมู่ 3 ตำบล ป่าแมต อำเภอ เมือง จังหวัด แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(798, '6031280009', 'c6c23032cd96605c15463de513cac5b9babc52b9', 'นางสาว', 'จารุวรรณ', 'ชมเชย', NULL, 'Jaruwun004@hotmail.com', NULL, '0949730272', NULL, '39 ม.4 ต.สบสาย อ.สูงเม่น จ.แพร่ ', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(799, '6031280010', '90b9aa7e25f80cf4f64e990b78a9fc5ebd6cecad', 'นาย', 'นนทชัย', 'ศักดิ์ศรี', NULL, 'Nontachai13@hotmail.com', NULL, '062-097-8743', NULL, '6หมู่1 บ้านอ้อย ต.บ้านเวียง อ.ร้องวาง จ.แพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(800, '6031280011', 'd12aeaf8a4b25302b94e347e54486e98b3985825', 'นาย', 'ณัฐกร', 'เสนานุรักษ์วรกุล', NULL, 'Gameindy06@gmail.com', NULL, '086-3061647', NULL, '31/1 หมู่1 ตำบลเหมืองหม้อ\nอำเภอเมือง จังหวัดแพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(801, '6031280012', '55bf81e23f278eaba60a78320d970148a946096b', 'นาย', 'จิตรภาณุ', 'หงษ์หนึ่ง', NULL, 'rakusuntundo@gmail.com', NULL, '0648628679', NULL, '223 ม.3 ต.วังหงส์ อ.เมือง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(802, '6031280013', '3dfad40cf2ce2251dba16b4e2eb5400305c5e1ef', 'นางสาว', 'ธนัญญา', 'ต๊อดแก้ว', NULL, 'thanunya078@gmail.com', NULL, '080-4425075', NULL, '37 หมู่10 ตำบลสูงเม่น\nอำเภอสูงเม่น จังหวัดแพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(803, '6031280014', '90b9aa7e25f80cf4f64e990b78a9fc5ebd6cecad', 'นาย', 'สุริยา', 'ชาวลี้แสน', NULL, '', NULL, '0941870797', NULL, '137 ม.6 ต.ต้าผามอก อ.ลอง จ.แพร่ ', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(804, '6031280015', 'd63425c5a4b48c6bb2b921723e2ee1066c137c9e', 'นางสาว', 'เบญจมาศ', 'คำหลวงเติม', NULL, 'ben_jamas09@hotmail.com', NULL, '0811695482', NULL, '284/8 หมู่10 ต.แม่จั๊วะ อ.เด่นชัย\nจ.แพร่', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(805, '6031280016', '3e91fd1bb73a4b539a1d50f94c3be692c0a55617', 'นาย', 'ธีรุตม์', 'เหมืองหม้อ', NULL, 'Jeff_thirut@hotmail.com', NULL, '0938752438', NULL, '99/2 หมู่ 2 ต.น้ำชำ อ.เมือง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(806, '6031280017', '86abbd43eb837c452a318ab00c7108cbae1195ce', 'นางสาว', 'มาวารินทร์', 'อินต๊ะแสน', NULL, '', NULL, '0646968331', NULL, '71/3 ม.8 ต.ไทรย้อย อ.เด่นชัย จ.แพร่', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(807, '6031280018', 'b38a6bc67e16b42a1af73a716afaea63f15b6ee9', 'นาย', 'กฤษณพล', 'ติแก้ว', NULL, 'bigzaphrae4@gmail.com', NULL, '0949703997', NULL, '3 หมู่7', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(808, '6031280019', '585e6bdd4bd1db7a5ee516f674b72b23ac53f02a', 'นาย', 'ธนากร', 'เทียมตา', NULL, 'kook.kai29072541@gmail.com', NULL, '0654298422', NULL, '132/1 ม.2 ต.น้ำชำ อ.เมือง แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(809, '6031280035', 'b647a687449e48a6397d8a9726d7e7ece7566a75', 'นาย', 'สรรพวัต', 'วิยะ', NULL, 'sapphawat_wiya@hotmail.com', NULL, '063-721-7935', NULL, '43 หมู่ 10 บ้านอ้อย ต.บ้านเวียง อ.ร้องกวาง จ.แพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(810, '6031280021', '2c4ff39fb651f110cba75ca25f852778a410de08', 'นาย', 'พชร', 'วงศ์หน่อ', NULL, 'ping_pingza604@hotmail.com', NULL, '0863841265', NULL, '88 หมู่ 11 ต.บ้านหนุนใต้ อ.สอง จ.แพร่', NULL, 175, '54120', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(811, '6031280022', '52a39eeec29bff3e0223d802978c6c717a67c0bf', 'นาย', 'กิตติชัย', 'จากภัย', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(812, '6031280023', '90b9aa7e25f80cf4f64e990b78a9fc5ebd6cecad', 'นาย', 'ณัฐวุฒิ', 'พระคำลือ', NULL, 'Asdzeer_1230@hotmail.com', NULL, '0994351024', NULL, '20ม.1ต.บ้านปงอ.สูงเม่นจ.เเพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(813, '6031280036', 'c09e1bd6f9ed6f41e76d199a36cf20fbbaad867f', 'นาย', 'ธนพล', 'จินดาคำ', NULL, '', NULL, '0980421677', NULL, '', NULL, 175, '', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(814, '6031280025', 'e3e8b436ba76676137b18e6c58b1ed006ee5d900', 'นาย', 'สุทธิภัทร', 'ใจมาคำ', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(815, '6031280026', '90b9aa7e25f80cf4f64e990b78a9fc5ebd6cecad', 'นาย', 'วัชรพงษ์', 'คำเวียงสา', NULL, '', NULL, '0827809061', NULL, '85/1 ม.1 อ. ลอง จ. แพร่', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(816, '6031280027', '90b9aa7e25f80cf4f64e990b78a9fc5ebd6cecad', 'นาย', 'จิราพัชร', 'สบายวงค์', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(819, '6031280037', '9b9de4dc4d3592bcc19f155be13a1afd6ec77d58', 'นาย', 'จิรวัฒน์', 'บัลลังก์นาค', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(818, '6031280028', 'c7e913ecb1bfa9fa272057da190c1ba1d1614f22', 'นาย', 'ธนกร', 'แก้วน้อย', NULL, 'first87826@hotmail.com', NULL, '', NULL, '240 ม.8 ต.แม่จั๊วะ อ.เด่นชัย จ.แพร่ ', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(820, '6031280030', 'a9c9c61adda65a77cd5b31565c579f23e4d12bd0', 'นางสาว', 'ลลิดา', 'หมูนิล', NULL, 'lalidamuay23@gmail.com', NULL, '0613218462', NULL, '202/3 ม.6 ต.หัวฝาย อ.สูงเม่น จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(821, '6031280031', '90b9aa7e25f80cf4f64e990b78a9fc5ebd6cecad', 'นาย', 'คฑาเดช', 'หงษ์ยศ', NULL, 'katadate5467@gmail.com', NULL, '064-401-6730', NULL, '92/5 หมู่4 ต.วังหงส์ อ.เมือง จ.แพร่ ', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(822, '6031280032', 'c021cff481fbdb3a4fd4e248e66bdbc3095227a3', 'นาย', 'ฐาปกรณ์', 'พาสระน้อย', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(823, '6031280033', '1254c13ccdb8a1be8991adade187cd5c8e6ba671', 'นาย', 'ธนศิลป์', 'สุรจิตต์', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(824, '6031280034', '9efb8707396ff8941a37b2e21b0f4fde1d9214ec', 'นาย', 'ปฎิภาน', 'พะยะราช', NULL, 'mon6789967@gmail.com', NULL, '0966521660', NULL, '300 หมู่4 อ.เมือง จ.แพร่ ', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(825, '6021280001', 'de54a26aa6f87e301f9225c37bebf90f97ddfaa6', 'นางสาว', 'กมลทิพย์', 'นพพันธ์', NULL, '', NULL, '0933063788', NULL, '50/8 หมู่ 4 ตำบลเด่นชัย อำเภอเด่นชัย จังหวัดแพร่', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(826, '6021280002', '7f078fb1c0f430694d6bd08d6d4dda24acf21e05', 'นาย', 'ณัฐพงศ์', 'หน่อแก้ว', NULL, 'nosmokingccv@hotmail.com', NULL, '0848855084', NULL, 'หมู่3 บ้านห้วยขึม ซอย 2 บ้านเลขที่ 149 ต.นำ้เลา  อ.ร้องกวาง จ.แพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(827, '6021280003', 'bfb55b3ba966e69d53f144d638176e47aa5fffb7', 'นาย', 'พุฒิพงศ์', 'หลีแก้วสาย', NULL, 'aun0695@gmail.com', NULL, '0979410695', NULL, '62/2 ม.1 ซอย6 ต.สวนเขื่อน อ.เมือง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(828, '6021280004', '729420c41e3877817c564ea139d770d4cc5e0613', 'นาย', 'ยุทธศักดิ์', 'สลับศรี', NULL, '-', NULL, '0924184459', NULL, '121/3 หมู่2 บ้านแม่ทราย ตำบล แม่ทราย อำเภอ ร้องกวาง จังหวัด แพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(829, '6021280005', 'be9722f04a6a58dc80d350f3c2667d990b42a502', 'นางสาว', 'วิภาดา', 'ติปัญโย', NULL, 'wipada0964@gmail.com', NULL, '0947011367', NULL, '17 หมู่ 9 บ้านอ้อย ตำบลบ้านเวียง อำเภอร้องกวาง จังหวัดแพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(830, '6021280006', '59165565d3a6c7e2d74ee6538e5ec76517c39e59', 'นาย', 'อดิศักดิ์', 'ผูกจิต', NULL, 'oomloveoomzxc@gmail.com', NULL, '0642561039', NULL, '118/3 ต.บ้านปง อ.สูงเม่น จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(831, '6021280007', '7f6e4877a05f2a16370f82f5bed562d648a5f9b6', 'นางสาว', 'สุดารัตน์', 'จำปาจี', NULL, 'tarsudarat_5555@gmail.com', NULL, '0944168020', NULL, '223/1 หมู่ 4 ซอย 2 ต.ตำหนักธรรม อ.หนองม่วงไข่ จ.แพร่', NULL, 175, '54170', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(832, '6021280008', '98e780adb0b63af939351de7f2833e97c6278a01', 'นางสาว', 'กนกวรรณ', 'กระสวย', NULL, 'Kanokwan29600@gmail.com', NULL, '0654020820', NULL, '149 หมู่12 บ้านไทรย้อย อ.เด่นชัย จ.แพร่', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(833, '6021280009', 'eba28461ea6f2d445fed6f78af4bc7a8baad7b52', 'นาย', 'วรันธร', 'บุญเรืองรอด', NULL, 'warantorn3501@gmail.com', NULL, '0886292838', NULL, '119 หมู่ 10 ต.บ้านเวียง อ.ร้องกวาง จ.แพร่ ', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(834, '6021280010', '5efd25013e460fe9fd64f6f98a743aa97b1266a8', 'นางสาว', 'สุทธิดา', 'บุญหลง', NULL, 'sutidaza2701@gmail.com', NULL, '0616322701', NULL, '29 บ้านไทรย้อย หมู่ 12 ต.ไทรย้อย อ.เด่นชัย จ.แพร่', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(835, '6021280011', 'b733c056a1b829517f5884ffb666f65215d56b87', 'นางสาว', 'มณทิชา', 'โพธิกุล', NULL, '', NULL, '0622961290', NULL, '4/5 หมู่4 ต.เด่นชัย อ.เด่นชัย จ.แพร่', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(836, '6021280012', 'f378b333451161cb371c809681c7e03fe62c8bc2', 'นาย', 'สัทพงศ์', 'หิรัญวงศ์', NULL, '', NULL, '0930395770', NULL, '187/2 หมู่3 บ้านสุพรรณ ต.ป่าแมต อ.เมือง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(837, '6021280013', '4d715559664d2e3942d7b643033ddb57a19bea9c', 'นาย', 'ธนากร', 'สินธุวงค์', NULL, 'basotakoo@gmail.com', NULL, '0641893305', NULL, '14 หมู่3 บ้านแม่ทราย ตำบลเเม่ทราย อำเภอร้องกวาง จังหวัดแพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(838, '6021280014', '16c864620160d3d89de035108a93e4c89339e29d', 'นาย', 'นันทวัฒน์', 'กุศลส่ง', NULL, 'dearzaing080@gmail.com', NULL, '0951166762', NULL, '154 บ.บ้านดอนแก้ว ต.กา\n\nญจนา อ.เมือง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(839, '6021280015', 'b0c17919156215a2627e915d1c0f884a01eda686', 'นางสาว', 'อรุโณทัย', 'กองศรี', NULL, '', NULL, '0625588305', NULL, '50/2 หมู่2 ตำบล เหมืองหม้อ อำเภอเมือง จังหวัดเเเพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(840, '6021280016', '9df6a10f0f9c8648ef212d6e8861e881642376d5', 'นาย', 'ธนาธิป', 'ดวงจันทร์', NULL, 'thanatip0362@gmail.com', NULL, '0930500362', NULL, '225/2 บ้านช่องลม ม.8 ต.หัวฝาย อ.สูงเม่น จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(841, '6021280017', '0c1f5eb72315e1f5ceb6f14760c0c5242bac98e8', 'นาย', 'ศิลา', 'นาเมืองรักษ์', NULL, 'sirzaz_123@hotmail.com', NULL, '0966748516', NULL, '94 หมู่ที่4 บ้านปง ต.ห้วยม้า อ.เมือง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(842, '6021280018', '897a2186e9f4087241cc5c3d1201d21f75cc882c', 'นาย', 'ธีรเดช', 'มิ่งขวัญ', NULL, 'teeradetaa789@gmail.com', NULL, '0987706772', NULL, '20/3 ม.1 ต.ห้วยไร่ อ.เด่นชัย จ.เเพร่ ', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1148, '6131280112', '817b4cad0765413efb7f1504b046884f23aa15b5', 'นาย', 'ไตรรงค์', 'ถิ่นหลวง', NULL, '', NULL, '0644819874', NULL, 'บ้านเลขที่93 หมู่4 ต.บ้านถิ่น อ.เมือง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1149, '6131280113', '1c93061a593c28322dda4c27de6456a774b9a16a', 'นางสาว', 'พัชราภรณ์', 'อินถา', NULL, 'Patcharaporn15342@gmail.com ', NULL, '0882549524', NULL, '346/1 ม.1 ต.เตาปูน อ.สอง จ.แพร่', NULL, 175, '54120', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1147, '6131280111', '0ac01137633e29f1a0cdfb483be837ff05e90a26', 'นาย', 'ปาราเมศ ', 'เรืองฤทธิ์', NULL, 'parametcub@gmail.com', NULL, '0989834599', NULL, 'บ้านเลขที่ 31 หมู่ 5 ต.บ้านหนุน', NULL, 175, '54120', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(845, '6021280021', '60f84cdc674bba9e742adefad54dd57849d514d8', 'นาย', 'ธีรภัทร', 'แก้วกัลยา', NULL, 'poiuulove2834@hotmail.com', NULL, '0613280473', NULL, 'บ้านหางนา หมู่ที่7  ซอย 6  บ้านเลขที่ 106 ต.น้ำเลา อ.ร้องกวาง จ.แพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(846, '6021280022', '0f118ded21410f00b0dadf8ba1b59678bcd2df44', 'นางสาว', 'สิริกร', 'คำลือ', NULL, '', NULL, '0979852067', NULL, '7/6 ม.8 ต.กาญจนา อ.เมือง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(847, '6021280023', 'e571c450dd2488914e26380e6ecb91be6911399e', 'นาย', 'สิทธิชัย', 'กาศคำสุข', NULL, 'aumbaka98@gmail.com', NULL, '0620488745', NULL, '34/2หมู่8 ตำบลไทรย้อย อำเภอเด่นชัย จังหวัดแพร่', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(982, '6021280024', '54b5952d9617a04be3b49d56961edd94b01729d9', 'นาย', 'พชธกร', 'ปูนกลาง', NULL, '', NULL, '0622923459', NULL, '364 ม.5 ต.แม่หล่าย อ.เมือง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(849, '6021280025', '9f018cbf7c2f6b0a3d8e33e543eda512947a054f', 'นาย', 'อรรถกร', 'ญาณปัญญา', NULL, 'armarmtyuio@outlook.co.th', NULL, '0910450527', NULL, '60/2 หมู่ที่1 บ้านสบเกิ๋ง ตำบลแม่เกิ๋ง อำเภอวังชิ้น จังหวัดแพร่', NULL, 175, '54160', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(850, '6021280026', '2b005f37b966a78ac8cb8cd108af048c9f4690fa', 'นางสาว', 'อภิชาภรณ์', 'เกียรติอำพนธ์', NULL, 'at.apichaporn24@gmail.com', NULL, '0864568206', NULL, '169 หมู่1 บ้านน้ำโค้ง ต.ป่าแมต อ.เมือง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(851, '6021280027', '9db1fe506613c11b4c1f7454065454b7c4c16d2e', 'นาย', 'เจษฎา', 'ถาโถม', NULL, 'gtaman258@gmail.com', NULL, '0800977083', NULL, '58/3 ม.1 ต.ป่าแมต อ.เมืองแพร่ จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(852, '6021280028', '61376f72bf94f7429aa650070f86da52ae025924', 'นางสาว', 'ธนัชญา', 'เพาะเจาะ', NULL, 'thanatchaya1021@gmail.com', NULL, '0956811021', NULL, '8หมู่6ตำบลกาญจนาอำเภอเมืองแพร่ จังหวัดแพร่ ', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(853, '6021280029', '4501ea4eaa3bafda793ce0f3ae2a923a3e42b4b3', 'นาย', 'อมรเทพ', 'ท้วมอ้น', NULL, 'amonthap.0989673846@gmail.com', NULL, '0989673846', NULL, '77หมู่1 บ้านแม่แปง ตำบลนาพูน อำเภอวังชิ้น จังหวัดแพร่', NULL, 175, '54160', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(854, '6021280030', '3f163ddcdf15bead7a2431039cb291d5956e9c8a', 'นาย', 'สุรชัย', 'พันธุ์มี', NULL, '0992755573', NULL, '0620488995', NULL, '190/4ต.ไทรย้อย อ.เด่นชัย จ.แพร่', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(855, '6021280031', 'b62b3c7bb0a742c5bb50f974a627a1846ee59b7f', 'นาย', 'ภนาวัฒน์', 'กุลประสงค์', NULL, 'domzaasxs01@hotmail.com', NULL, '0948376407', NULL, 'บ้านเลขที่59 หมู่ 6 ต.ทุ่งโฮ้ง อ.เมือง จ.แพร่  ', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(856, '6021280032', '86e4f5e92825cd138b042749b5e865805cf89227', 'นาย', 'ศุภกานต์', 'กาวีละ', NULL, 'kay298657@gmail.com', NULL, '0982761520', NULL, '51 หมู่10 ต.ไทรย้อย อ.เด่นชัย จ.แพร่', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(857, '6021280033', '9be1a592e9872b96bc8767770f799cb6ea035139', 'นาย', 'ภาคภูมิ', 'ชุ่มเย็น', NULL, 'Ppoom422@gmail.com', NULL, '0987049958', NULL, '51/2 หมู่3 ต.หัวฝาย อ.สูงเม่น จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(858, '6021280034', '49fb155d3194d5ac22e89c557328f43f6374f1ee', 'นาย', 'ธิติพัทธ์', 'แกล้วกล้า', NULL, 'thitipatklawkla2544@gmail.com', NULL, '0958106123', NULL, '121/1 ต.ดอนมูล อ.สูงเม่น จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(859, '6021280035', '555318d1417848d779bf73d26fb17c440237ccd8', 'นาย', 'คริสต์มาส', 'วุฒิ', NULL, 'turboboyrider@gmail.com ', NULL, '0646706415', NULL, '12 หมู่3 บ้านแม่หล่ายกาซ้อง \nต.แม่หล่าย     อ.เมือง ', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(860, '6021280036', '21dce5ef86c200ade3e0d6fde0b85b956827c881', 'นาย', 'ณัฐพล', 'อุตราช', NULL, 'oom.0925609906@gmail.com', NULL, '0925609906', NULL, '149/1 บ้านแม่แปง หมู่1 ตำบลนาพูน อำเภอวังชิ้น จังหลัดแพร่', NULL, 175, '54160', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(861, '6021280037', '33c2ea5a8ba30a2a0ac9b0d4278d54b3a165c099', 'นาย', 'จีรพัฒน์', 'กาบจันทร์', NULL, 'the_boy13oat@hotmail.com', NULL, '0947238836', NULL, '101/7 หมู่ 3 ต.บ้านปง อ.สูงเม่น จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(862, '6021280038', 'aa2281cc2c4cf49236a048db38fc9a68020cdd89', 'นาย', 'โอภาสพันธ์', 'กลิ่นชื่นจิต', NULL, 'Impan_1611_2544@Hotmail.com', NULL, '098-416-7736', NULL, '69/4 บ้านสำเภา หมู่1 ถนน นาแหลม-โป่งศรี ต.เหมืองหม้อ อ.เมือง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, '');
INSERT INTO `tb_member` (`member_id`, `member_code`, `member_password`, `member_title`, `member_firstname`, `member_lastname`, `member_gender`, `member_email`, `member_tel`, `member_mobile`, `member_fax`, `member_address`, `member_district`, `province_id`, `member_zipcode`, `member_registerdate`, `member_company`, `member_company_no`, `member_level`, `member_approve`, `member_last_login`, `member_note`, `member_line_token`, `member_line_token2`, `member_line_token3`, `member_line_token4`, `member_line_token5`, `member_type`, `student_id`, `member_img`) VALUES
(863, '6021280039', 'daf69e5fefe84f52aa37f9470b1bd0c479ac108a', 'นาย', 'ณัฐชนน', 'สังข์ทอง', NULL, 'nadchanon11@gmail.com', NULL, '0874805639', NULL, '42 ม.7 ต.ห้วยอ้อ อ.ลอง จ.แพร่', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(864, '6021280040', '1a5eae583ebcbbd426d8d9336d403e59ab386d9f', 'นาย', 'ณัฐภัทร', 'เจริญกิจหัตถกร', NULL, 'fixnattapat@gmail.com', NULL, '0857197997', NULL, '27/2-27/3ถ.ราษฎร์ดำเนินต.ในเวียงอ.เมืองจ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(865, '6021280041', '4f800f0b1a7efdd0925ced279c83eb4b7d9608d9', 'นางสาว', 'เยาวพา', 'แซ่โค้ว', NULL, '', NULL, '0944430761', NULL, '173 หมู่10 ตำบลร่องกาศ อำเภอสูงเม่น ', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(866, '6021280042', '67467bae6fa8ab721701b6b8079148f8895689ca', 'นาย', 'จารุวัฒน์', 'มีศิลป์', NULL, '', NULL, '0966077973', NULL, '77/1 หมู่ 3 ต.แม่ยางตาล อ.ร้องกวาง จ.แพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(867, '6021280043', '64b6577bf54863cadfd4488e36cf4a6b103239b4', 'นาย', 'อนุพัฒน์​', 'ขอร้อง', NULL, '', NULL, '', NULL, 'อำเภอสูง ตำบลสูงเม่น หมู่10\nจังหวัดเเพร่ บ้านเลขที่3/4\n', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1143, '6131280107', 'd793fd077d83991a41c8f059129b8af87b90e773', 'นางสาว', 'กนิษฐา', 'ทองคำ', NULL, '', NULL, '0932704050', NULL, '33/3 ม.1 ต.ห้วยไร่ อ.เด่นชัย จ.แพร่', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1144, '6131280108', 'b66fc15cd0cae31c025781921606e3ae57ead8e0', 'นางสาว', 'มินตรา', 'สุธรรม', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(869, '6021280045', '7ea44cb150ddacb6940d37176f633724d3275681', 'นางสาว', 'ฐิดาพร', 'สำรองพันธ์ุ', NULL, '-', NULL, '0643623839', NULL, '79 ม.9 อ.เมือง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(870, '6021280046', '3991f7cf4b22e7d8fbb239f414265c40eb6d462a', 'นางสาว', 'พัชรพร', 'จันทร์คำ', NULL, 'patchaporn.2001@gmail.com', NULL, '0617925204', NULL, '52/1  หมู่ 2  ต.แม่ยม  อ.เมือง  จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(871, '6021280047', '5f663aa1b35faf3505ac9874de15bb2a5bfe7d28', 'นาย', 'ธนวัฒน์', 'เทพิกัน', NULL, '', NULL, '0863968947', NULL, '40', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(872, '6021280048', 'be1030e4a4e5e12ddd7aa31772d5a57c601839f5', 'นางสาว', 'บุญสิตา', 'สิทธิตาคำ', NULL, 'pocky.new@outlook.co.th', NULL, '0932648992', NULL, '79 ม.12 บ้านวังฟ่อน ต.หัวเมือง อ.สอง จ.แพร่', NULL, 175, '54120', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(873, '6021280049', '44ddcae27713d06bde776ba058731089c4d5f7b1', 'นาย', 'ชนาธิป', 'ปันปวง', NULL, 'lovewa1122544@gmail.com', NULL, '0620285309', NULL, '26/2 ม.3 บ้าน หัวทุ้ง          ต หัวทุ้ง อ ลอง จ แพร่', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1140, '6131280104', 'a17c7c21633b7c67378509cb36dbcb2777372622', 'นาย', 'วัชรากร', 'ประดิษฐ์พุ่ม', NULL, 'watcharakornkrap@gmail.com', NULL, '0967677929', NULL, '', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(875, '6021280051', '5797a94320de30c3be3411475e906ed5fd9d806c', 'นาย', 'อธิป', 'มโนกูลอนันต์', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1139, '6131280103', '5dc9b840ea9bf901a5b39435c01c25eb705bd5b5', 'นาย', 'จักรกฤษณ์', 'อุตรพงศ์', NULL, 'jakgrit_utrapong@hotmail.com', NULL, '0876565684', NULL, '10 ม.6 ต.นาจักร  อ.เมือง  จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1138, '6131280102', '1783adb0db5259346a115d24a3582c15e7ceb8b6', 'นาย', 'ภานุพันธุ์', 'ธิน่าน', NULL, 'puppet7511@gmail.com', NULL, '0621257659', NULL, '11 ม.1 ต.แม่เกิ๋ง อ.วังชิ้น \n จ.แพร่', NULL, 175, '54160', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(878, '6021280054', '516338b3de4f2d382736961dad6497716e113ccf', 'นาย', 'ณัฐกิตต์', 'ต๊ะคำ', NULL, '', NULL, '0622813504', NULL, '96 หมู่10 ต.บ้านเวียง อ.ร้องกวาง จ.แพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(879, '6021280055', '7161e7e3f63dc0e933cf4bb4113a9d668d883088', 'นาย', 'เมษวรรษ', 'แสงทอง', NULL, 'icewatpa2545@hotmail.com', NULL, '0982672173', NULL, '125 หมู่ 1 ต.เตาปูน อ.สอง จ.เเพร่', NULL, 175, '54120', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(880, '6021280056', '105cca0666a80820160928797b744b68b8991824', 'นางสาว', 'ศิริลักษณ์', 'กิ่งสาร', NULL, 'Mewmal6608@gmail.com', NULL, '0635032681', NULL, 'บ้านเลขที่ 25 หมู่ 4 ต.นาจักร\nอ.เมือง จ.แพร่ ', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1137, '6131280101', 'b803ebfeff7f49a054b44d23134deab7d451fd72', 'นางสาว', 'ชุติกาญจน์', 'หล้าจันทร์', NULL, '', NULL, '0932411180', NULL, '61/2 หมู่4 ต.แม่เกิ๋ง อ.วังชิ้น จ.แพร่', NULL, 175, '54160', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(884, '6021280060', '759a888faa9a41962d2905058fc4f85e891a4051', 'นางสาว', 'วัชราภรณ์', 'แก้วมูล', NULL, '', NULL, '0910769684', NULL, '43หมู่1ต.วังธง อ.เมือง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(885, '6021280061', '5dcb70204441229d12c5aae5b7d29a888cb950b8', 'นาย', 'พิชญ์ภัค', 'หลีเจริญ', NULL, '-', NULL, '0843737592', NULL, '143/1 หมู่7 ตำบนช่อแฮ จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1136, '6131280100', '28227de4cea27bbffab2a95ce49b7a526121eef2', 'นาย', 'วราวุธ', 'คำนาค', NULL, 'fccic302@gmail.com', NULL, '0932986890', NULL, 'บ้านเลขที่ 2 ม.2 ต.ป่าแดง อ.เมืองแพร่ จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(887, '6021280063', '44416c35d13d4a093e5c52e26b04ad8aec24864f', 'นางสาว', 'กนกพร', 'ทองภักดี', NULL, '', NULL, '0830044647', NULL, 'บ้านแม่กระทิง หมู่3 ตำบลไผ่โทนอำเภอร้องกวางจังหวัด แพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(888, '6021280064', '31d66e549fecf021b3ea46d3ad34a2174090da4c', 'นาย', 'นพดล', 'ทนันชัย', NULL, '', NULL, '0987688820', NULL, '76 ม.7 ต.ห้วยม้า อ.เมือง จ.เเพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(889, '6021280065', '6c390fa91fdcdfbb25869024bb55f62e11c512bb', 'นางสาว', 'ทิพย์ฑิฌา', 'ดวงดาว', NULL, 'thipticha.d@gmail.com', NULL, '0991708161', NULL, '197 ม.2 ต.แม่ตีบ อ.งาว\nจ.ลำปาง', NULL, 146, '52110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(890, '6021280066', '436ed4b0cc0e070251206905312d3a93da14ae20', 'นาย', 'ทินภัทร ', 'ทองประไพ', NULL, 'newsgt700@gmail.com', NULL, '0995786642', NULL, '72/1 ม.5 ต.วังหง อ.เมือง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(891, '6021280067', '90b9aa7e25f80cf4f64e990b78a9fc5ebd6cecad', 'นาย', 'ณัฐนนท์', 'ธรรมเมือง', NULL, 'nextnatthanon@gmail.com', NULL, '0646373106', NULL, '77/1 หมู่4 บ้านธรรมเมือง ตำบล ช่อแฮ อ.เมือง จ.แพร่ 54000', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(893, '6031280050', '16b92268e4a0d426a333d5fc218ef150f677a304', 'นาย', 'ปรีชา', 'แก้วโก', NULL, 'pamza_191@hotmail.com', NULL, '0887696209', NULL, '272 ม.8 ต.แมจั๊วะ อ.เด่นชัย จ.แพร่', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(894, '6031280051', 'c1aa42ef4a846943de72dd13b8f48ef303025fc8', 'นางสาว', 'จุรีรัตน์', 'กาศเกษม', NULL, 'lovemamza0221@hotmail.com', NULL, '0875699622', NULL, '117/1 ม.3 ต.บ้านกาศ อ.สูงเม่น จ.แพร่ ', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(895, '6031280052', '23ff0a1ce844939202a3749d477dbced39d70bf4', 'นาย', 'อภิสิทธิ์', 'ศรีตะลา', NULL, 'ecioboy1@gmail.com', NULL, '0960363094', NULL, '215/2 ม.2 ต.เด่นชัย อ.เด่นชัย จ.แพร่', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(896, '6031280053', 'f0ed62bab770722f63cb2fe140be519642015817', 'นาย', 'ณัฐพล', 'ชนม์ณนันท์', NULL, 'nut.nstory01@gmail.com', NULL, '0971684385', NULL, '60/3 หมู่ที่ 4 บ้านทุ่งเจริญ ตำบลหัวฝาย อำเภอสูงเม่น จังหวัดแพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(897, '6031280054', '77a21ec6668e0b8d8b31d4cbd0838fd85219ac12', 'นาย', 'ปฏิภาณ', 'ชมภูแสน', NULL, 'patiparn6643@gmail.com', NULL, '0863120944', NULL, '165/5  ม.1 ต.บ้านกวาง อ.สูงเม่น จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(898, '6031280055', '22538191063120feb658dc722bcf66fa4041dff0', 'นาย', 'ทินกฤต', 'สิงห์แก้ว', NULL, 'slapexs@gmail.com', NULL, '0932351402', NULL, 'บ้านเลขที่ 209 หมู่.5 หมู่บ้านวังโป่ง ต.ร้องกวาง  อ.ร้องกวาง', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(899, '6031280056', 'f05b8830aa4a689e3324b93a98d700a46920a7b3', 'นาย', 'เพชรพงษ์', 'พรรณวาที', NULL, 'pethpong1808@gmil.com', NULL, '0996786138', NULL, '223/3 ม.12 ต.ป่าเเมต อ.เมือง ', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(903, '6031280060', '4c08aac8df28097c844cc8e4c9e9ff64a54ce955', 'นางสาว', 'สุณิสา', 'จันทะวงค์', NULL, 'n_ple202@hotmail.com', NULL, '0824812672', NULL, '24 หมู่ 7 ต.ช่อแฮ อ.เมืองแพร่ จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(904, '6131280116', '63982e54a7aeb0d89910475ba6dbd3ca6dd4e5a1', 'นาย', 'ไชยยศ  ', 'ยศเทศ', NULL, 'chaiyod98@gmail.com', NULL, '0957646318', NULL, '98 ม.4 ต.วังหลวง อ.หนองม่วงไข่ จ.แพร่', NULL, 175, '54170', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(905, '6031280062', '61758ead928fd7448694f23460dbf1710fc87aa2', 'นางสาว', 'ภัทราภรณ์', 'เมืองมิ่ง', NULL, 'the_end_unhappy@hotmail.com', NULL, '0931766526', NULL, '21 ม.2 ต.บ้านเหล่า อ.สูงเม่น  จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(906, '6031280063', 'c82dd98d64735b821e2fce476ce5aad5d2097961', 'นาย', 'วิทวัส', 'เทพยศ', NULL, '', NULL, '', NULL, '150/1', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(908, '6031280064', 'fe703d258c7ef5f50b71e06565a65aa07194907f', 'นาย', 'ธนาธิป', 'กันยะมี', NULL, '+66877897200', NULL, '0939535046', NULL, '238/1 หมู่ที่2 ต.แม่คำมี\nอ.เมืองแพร่ จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(909, '6031280065', '1315c5a23362fdb4f08401e37b7492ba95dbd0c7', 'นาย', 'ชัยมงคล', 'เขตแดน', NULL, 'nebylond@hotmail.com', NULL, '0622970787', NULL, '187 ม.3 ต.หัวฝาย อ.สูงเม่น จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(910, '6031280067', 'e5f6ab42e7c5de26f626be55c27be7bf804c2a19', 'นาย', 'ภัทรพล', 'ศรีม่วง', NULL, '', NULL, '0882370053', NULL, '387/1 หมู่5 ต.แม่หล่าย อ.เมือง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(911, '6031280068', '3c50fd325c7764cff67389be1e2511fa0ac06670', 'นาย', 'จักรกฤตย์', 'เขื่อนแก้ว', NULL, NULL, NULL, '0859250233', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(974, '6031280066', 'ab0c46e4f95728eb932b6fc2203ef6f8a0dc19b7', 'นางสาว', 'ฑิตยา', 'วงศเขียว', NULL, 'ferngii2013@gmail.com', NULL, '0826861936', NULL, '33 ม.4 ต.แม่หล่าย อ.เมือง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1022, 'ekkachai', '90b9aa7e25f80cf4f64e990b78a9fc5ebd6cecad', 'นาย', 'เอกชัย', 'ศรชัย', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', 'J8RnVfzVeegNfBzyPv0uYIIZRLTZK1dqddAd5YsIQFX', 'MYZwSMXXeGmtemhEyDoBIojTcYEpIXg68ZgYOKlKYEo', 'uosFy14hTDYoTGZy4CkbRRHxnBHdhTcqNIoNHj371F7', '', '', 'teacher', 0, ''),
(984, '6031280038', '90b9aa7e25f80cf4f64e990b78a9fc5ebd6cecad', 'นาย', 'ธีรธนา', 'ป่าธนู', NULL, '', NULL, '', NULL, '', NULL, 175, '', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1142, '6131280106', '0da518b59459a1d4b17e8e7cf49a3bd295f996c6', 'นาย', 'สราวุฒิ', 'นุชิตประสิทธิชัย', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(994, '6031280071', '71fc7345083483ef8170fa3e5b88d2ebb99bc5d7', 'นางสาว', 'กาญจนา', 'กาบิน', NULL, 'J0915431544', NULL, '0915431544', NULL, '85หมู่5ตำบลน้ำชำอำเภอสูงเม่นจังหวัดแพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1146, '6131280110', '67afc37a9d7919557da7de9c034450aefba53616', 'นาย', 'ปัญจพล', 'สีดอนทอง', NULL, 'pom_panjapon2020@hotmail.com', NULL, '0629500059', NULL, '88 หมู่5 อำเภอเมือง จังหวัดแพร่ ตำบลร่องฟอง', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1145, '6131280109', 'fe3fc936eea49bfe46bd33b365962acfe14ae00d', 'นางสาว', 'กัญญารัตน์', 'รัตนอุดมศักดิ์', NULL, 'beamkan1997@gmail.com', NULL, '0987823592', NULL, '99/2 ถ.ร่องซ้อ ต.ในเวียง อ.เมืองแพร่ ', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1141, '6131280105', 'c7c010455d9324806bd48d6f552460096a6ee837', 'นาย', 'นนทวัฒน์', 'กัญญะมี', NULL, 'legendalykk@gmail.com ', NULL, '0996644059', NULL, '125หมู่6ต.ห้วยหม้าย บ.ดอนแก้ว อ.สอง จ.แพร่', NULL, 175, '54120', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1174, '6121280048', '90b9aa7e25f80cf4f64e990b78a9fc5ebd6cecad', 'นาย', 'นิกโคลัส', 'ลองสตรีท', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1190, '6121280073', '1d824110c08862a591037e760dec4a6e0f17bb75', 'นาย', 'ภัทรดนัย', 'วงค์ศิริ', NULL, 'buncha404@hotmail.com', NULL, '0931383679', NULL, '159 บ้านโป่งศรี หมู่.6 \nต.บ้านถิ่น อ.เมือง จ.เเพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1195, '6131280034', '96e523bcc36699498c0722c1863bfadeb5e4a6bf', 'นาย', 'ปรวรรษ ', 'จันทร์ต๊ะ', NULL, '', NULL, '0658644321', NULL, '', NULL, 175, '', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1206, 'surapong', '90b9aa7e25f80cf4f64e990b78a9fc5ebd6cecad', 'นาย', 'สุรพงษ์', 'พิมพ์อาจเอี่ยม', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', 'SzTIuYWiVCdwUYZj2WkVYTT0NcYQdP9SlUvYvKNFESJ', 'aX8Yi2PTRvZU1dcVZwm2R9q7qLH0cfNcnaUtkzhgqhD', 'z9IxcdESg07lvmEzS39gdwuMj0SY7ChchUbWQxtDCwW', '', '', 'teacher', 0, ''),
(1209, '6221280001', '3c413d75b81a90db1e09c78eedfe25bb58d32c33', 'นาย', 'อดิศร', 'สมเป็ง', NULL, 'adisonsompeng49@gmail.com​', NULL, '0979386342', NULL, '25/2​ หมู่5​ ต.ปากกาง​ อ.ลอง​ จ.แพร่', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1210, '6221280002', '57c5315f5edc6bf06c8c9313605568e117fb048a', 'นาย', 'วัตรทกรณ์', 'ใจเมา', NULL, 'nhekwattgorn2003@gmail.com', NULL, '0932480683', NULL, '47/1 ม.9 ต.แม่พุง อ.วังชิ้น จ.แพร่', NULL, 175, '54160', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1211, '6221280003', 'f646bfcf450c3c4c49df1d07217ac51428a0276f', 'นาย', 'นิติธาดา', 'ยุศภา', NULL, 'Nitithadaford2@gmail.com', NULL, '0946018436', NULL, '108หมู่5 อ.ลอง ต.เวียงต้า\nจ.แพร่ ', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1212, '6221280004', '6c880ed6b66dafaabe0ac3277ac954beaf056892', 'นางสาว', 'กมลทิพย์', 'ใจมูล', NULL, 'mukmuk3368@gmail.com', NULL, '0863059328', NULL, '72/3 หมู่8 ต.บ้านเวียง อ.ร้องกวาง จ.แพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1213, '6221280005', 'ae3d5f5fec8877eac94479841360cb600d14737c', 'นาย', 'วรายุส', 'คำอุต', NULL, 'ramboo344@gmail.com', NULL, '0950295670', NULL, '145หมู่1 ต.บ้านกวาง อ.สูงเม่น จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1214, '6221280006', 'c535b855a391948d5f808ca977caf829afd9145f', 'นาย', 'ณัฐดนัย', 'ใจคง', NULL, 'natdanai6m3@gmail.com', NULL, '0806215125', NULL, '79 หมู่1 อ.ลอง จ.แพร่', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1215, '6221280007', 'a3b67d946904645897e66245d3dc0fe42f636f61', 'นาย', 'ศรายุทธ', 'มีปัญญา', NULL, 'sarayutmeepanya011@gmail.com', NULL, '0637930329', NULL, '46 ม.7 ตำบลเเม่คำมี อ.เมือง จ.เเพร่ 54000\n', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1216, '6221280008', '1524a8173e70c8c91bc69dac8999030c1d0365cb', 'นาย', 'กิตตินันท์', 'กิตติวงศ์วาน', NULL, 'ralfsserfotmak@hotmail.com', NULL, '0987820563', NULL, '104/1 ม.10 ต.หัวฝาย อ.สูงเม่น', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1217, '6221280009', '5a3ebda1e3f2938cfadea40027758386ef79a644', 'นาย', 'ธนิสร', 'เวียงยา', NULL, 'poomza0083@gmail.com', NULL, '0646326830', NULL, '86 ม.1 ต.บ้านเวียง อ.ร้องกวาง จ.แพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1218, '6221280010', 'fb917366c16f6117f409bf285c706fe888cc0f9f', 'นาย', 'พีรพัฒน์', 'มหาชัย', NULL, '0930163667aa@gmail.com​', NULL, '0930163667​', NULL, '128/30', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1219, '6221280011', '6785de5e7e9c56665e71cb12b71a44bacb2551a5', 'นาย', 'การัณยภาส', 'ท้วมเทศ', NULL, 'book_zaza00@hotmail.com', NULL, '0993848708', NULL, '80 หมู่2 ซอย2 ต.บ้านเวียง อ.ร้องกวาง จ.แพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1220, '6221280012', '96bba552e2727464384f1d513c20ea98db81561a', 'นาย', 'ภาณุพงศ์', 'สง่ากูล', NULL, 'panupongsangakul@gmail.com', NULL, '0980068865', NULL, '291 หมู่.7 ต.หัวฝาย อ.สูงเม่น จ.แพร่ 54130', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1221, '6221280013', 'd44242cdf979e235de110ca584e043498dfd9546', 'นาย', 'ณัฐชนน', 'ชัยวิรัตน์', NULL, '', NULL, '0924415625', NULL, '54 ม.3 ต.ทุ่งน้าว อ.สอง\nจ.แพร่', NULL, 175, '54120', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1222, '6221280014', '08bc3430e1753474eea44d81693b8698b6f825e9', 'นาย', 'วรวุฒิ', 'เข็มเมือง', NULL, 'Worawut5745@gmail.com', NULL, '0933087159', NULL, '79 ม.6 ต.บ้านเวียง อ.ร้องกวาง จ.เเพร่ ', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1223, '6221280015', '16dd633961fdb8d34637267173f21cb3a1fb4cb2', 'นาย', 'ทินภัทร', 'วงศ์จันทา', NULL, 'kaylove00123@gmail.com', NULL, '0808582919', NULL, '55/1 หมู่2 ต.เเม่ป้าก อ.วังชิ้น จ.เเพร่', NULL, 175, '54160', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1224, '6221280016', 'd82a30af26de3ccd07fd1a735ccd270e3d27582a', 'นาย', 'ต้นตระการ', 'โพธิ์ถาวร', NULL, 'tontagarn@gmail.com', NULL, '0806608722', NULL, 'จ.แพร่ อ.สูงเม่น ต.หัวฝาย บ้านป่าผึ้งหมู่ 6', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1225, '6221280017', '541004037f740b52029f58cf2afa4d6532b3aec9', 'นาย', 'นันทวัฒน์', 'เมฆอากาศ', NULL, 'koko148oak@gmail.com', NULL, '0638940301', NULL, '157 ต.บ้านเหล่า อ.สูงเม่น จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1226, '6221280018', 'a346bc80408d9b2a5063fd1bddb20e2d5586ec30', 'นาย', 'ภานุพงศ์', 'กาศเกษม', NULL, 'Mark99987@hotmail.com', NULL, '0641140366', NULL, '61 ม 3 ต.บ้านกาศ อ.สูงเม่น จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1229, '6221280019', '7051735216890381c96af98f034c12cd98b6935f', 'นาย', 'วัชริศ', 'วิชาวุฒิพงษ์', NULL, '', NULL, '0645430551', NULL, 'บ้านเลขที่:19 \nถนน:เหมืองหลวง \nตำบล:ในเวียง', NULL, 175, '', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1230, '6221280020', '6511148faff0b7100c07dbfbaf4e7aa4f5e8dfbb', 'นาย', 'สิทธิพล', 'พลเยี่ยม', NULL, 'markalovmew@gmail.com', NULL, '098-8084609', NULL, '160/7​ หมู่.7​ ต.ทุ่งโฮ้ง​ อ.เมือง​ จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1231, '6221280021', '897a0886631e4e332554866db0182da5b85ef657', 'นาย', 'เกริกพล', 'กาละวัน', NULL, '', NULL, '0951850518', NULL, '4/1หมู่4ต.บเวียงต้าอ.ลองจ.แพร่', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1232, '6221280022', '68fa5fcce6a00807240d50366c30516a55232e9e', 'นาย', 'กมลชัย', 'แห่งพิษ', NULL, '', NULL, '0944390896', NULL, '38/10 ม.3 ต.ทุ่งกวาว อ.เมือง จ.เเพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1233, '6221280023', 'f65aad56d6b414edbc60c40ecd5912eff6b1f776', 'นาย', 'อัษฎายุธ', 'โตไผ่', NULL, 'skycraftthegame@gmail.com', NULL, '0650317083', NULL, '107 หมู่5 ต.บ้านเวียง อ.ร้องกวาง', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1234, '6221280024', '14682286a7cb136a4599d2a7fe3a89cebb0ef2b5', 'นาย', 'ปรเมศวร์', 'แก้วอินัง', NULL, 'cardzumoo@gmail.com', NULL, '0987836983', NULL, 'บ้านเลขที่ 5/2 บ.แม่คำมี ต. ตำหนักธรรม อ.หนองม่วงไข่ จ.แพร่', NULL, 175, '54170', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1235, '6221280025', 'cc7660a63cc566687775e3f166126f16d61bf4da', 'นาย', 'ปิลันธกรณ์', 'ค้าไม้', NULL, 'Neckpiluntakorn@gmail.com', NULL, '0808502865', NULL, '56/2 ม.6 อ.ลอง ต.ห้วยอ้อ จ.แพร่ ', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1236, '6221280026', 'b34d57f262f0438bbfa5e795027b35a330cb0b32', 'นาย', 'กิตติพงศ์', 'วิโจทุจ', NULL, 'bird003za@gmail.com', NULL, '0648952087', NULL, '15หมู่7ตำบลป่าแดงอำเภอเมืองจังหวัดแพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1237, '6221280027', '8891fb3343381e6a89f7d528ce2f571a5e8e0d0a', 'นาย', 'ธนบูรณ์', 'มุดเจริญ', NULL, 'zzhopeandboonzz@gmail.com', NULL, '0631830780', NULL, '55/2 ม.6 ต.เวียงทอง อ.สูงเม่น จ.แพร่ ', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1238, '6221280028', 'ac8c17f39fef97c16a1c4526815a2f6cf0d79ec3', 'นาย', 'ยศพนธ์', 'ขืมจันทร์', NULL, 'markrider0258a@gmail.com', NULL, '0998680343', NULL, '62หมู่3ซอย3', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1239, '6221280029', '99df0a9855af8fd7f3f9157c4a2ec010fb9597d0', 'นางสาว', 'ณัฐธิดา', 'จันทร์ใส', NULL, 'natthidachanasai@gmail.com', NULL, '0654573356', NULL, '21 ม.3 ต.ห้วยอ้อ อ.ลอง จ.แพร่', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1240, '6221280030', '7a193e30ee1d7cdd0331f8d531cf9591bfd88e61', 'นาย', 'กิตติศักดิ์', 'วิโจทุจ', NULL, 'Benz111m03@gmail.co.com', NULL, '0889473682', NULL, '177​ หมู่9​ ตำบลป่าแดง​ อำเภอเมือง', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1241, '6221280031', '9edef9744ebf17ff3fd2ec16a6c9283bae629303', 'นาย', 'รัตนชัย', 'ใจดี', NULL, 'rattanachai2744 @gmail.com ', NULL, '0624589314', NULL, '68/1 ม.10 ต.น้ำชำ อ.สูงเม่น จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1242, '6221280032', 'bdb8e49b987e43e4e068e402708ddf7165aece64', 'นาย', 'ณัฐพล', 'ชำนาญ', NULL, 'bos12345zozo@gmail.com', NULL, '0930408243', NULL, '188​ หมู่​4​ ต.นํ้าชำ​ อ.สูงเม่น​ จ.เเพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1243, '6221280033', '6767fc2d53709a024c0435fd18518f2c8b5bb6b3', 'นาย', 'สหชล', 'ยืนยงค์', NULL, 'Ballseranime@gmail.com​', NULL, '0639717669', NULL, '99/1 ม.11​ ต.นํ้าชำ\nอ.สูงเม่น​ จ.​แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1244, '6221280034', '1b959f6b63601276b0d34f391291154f5663a115', 'นาย', 'เอื้ออังกูร', 'เลาหล้า', NULL, 'Moneyfoxza@gmail.com', NULL, '0611850170', NULL, ' ', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1245, '6221280035', 'af888d0fabaa08b2c26ae436b6f1296810e4e814', 'นาย', 'ฐิติพัฒน์', 'ดอนดง', NULL, 'dondong150846@gmail.com', NULL, '0625407361', NULL, '265', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1246, '6221280036', 'a5db4eeeabec60219e1187fd7dbb24a38abcf6d6', 'นาย', 'วาทิน', 'เพ็ชรหล้า', NULL, 'Watinpedla', NULL, '0830275034', NULL, '119 ', NULL, 175, '54160', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1247, '6221280037', '712cc303cb818229b72251494ca2faa77123396b', 'นาย', 'ธนภัทร', 'สืบแก้ว', NULL, 'pota.aq2016@gmail.com', NULL, '0641857957', NULL, '40/1 ต.ท่าข้าม อ.เมือง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1248, '6221280038', '377ab35507826036df5cba86d74aaf58ff26f7f2', 'นาย', 'อัครเดช', 'ศิริวิภวัฒนากุล', NULL, '', NULL, '0801975780', NULL, 'บ้านห้ฮ่อม ตำบนบ้านเวียง อำเภอร้องกวาง', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1249, '6221280039', 'a4dbcfc9c67d5150e8dcf2c30133baf42b1a142e', 'นาย', 'ณัฏฐกิตติ์', 'มหาวัน', NULL, 'lileyu00@gmail.com', NULL, '0637309083', NULL, '159 ต.สู่งเม่น อ.สูงเม่น\nจ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1250, '6231280001', '32c0c25a0789a02a3cfb1810fd63be13dd247e51', 'นาย', 'ธนพล', 'อุดมภาคสกุล', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1251, '6231280002', 'b0bc204f39099d6c0e1127223c1c730020b98c66', 'นางสาว', 'มณีรัตน์', 'ฟุ้งเฟื่อง', NULL, 'Nestom041159@gmail.com', NULL, '0643042374', NULL, '107/1 หมู่1 ต.บ้านปง อ.สูงเม่น', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1252, '6231280003', '2414b6f1a1330efd23bc997b0b246081a790d673', 'นางสาว', 'สมฤทัย', 'เพียสนิท', NULL, 'somruethai.piasanit@gmail.com', NULL, '0933076137', NULL, '34/1 ม.4 ต.บ้านปิน อ.ลอง จ.แพร่ ', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1253, '6231280004', 'f216d9fb4ed73c2a992b68114cd1838f5b72d78d', 'นางสาว', 'ดรุณี', 'ครืนกระโทก', NULL, 'flookky.earnny@gmail.com', NULL, '088-2906040', NULL, '258/2 บ.โตนใต้ ต.สูงเม่น อ.สูงเม่น จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1254, '6231280005', '67a74306b06d0c01624fe0d0249a570f4d093747', 'นาย', 'ภูรินท์', 'ปรีชา', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1255, '6231280006', '1158413215967b3875f38e1e2a60743868aaa6b5', 'นางสาว', 'พรประภา', 'แสนสมบัติ', NULL, 'hitochi26@gmail.com', NULL, '0903183784', NULL, '37 ม.10 บ้านบ่อแก้ว ต.ไทรย้อย อ.เด่นชัย จ.แพร่', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1256, '6231280007', '01798ae2c0e67b8cc2ba2ece12e3c6c007d90444', 'นางสาว', 'วรวรรณ', 'วรรณสิทธิ์', NULL, 'Worawan8968@gmail.com', NULL, '0948288968', NULL, '77/4 ม.10 ต.ไทรย้อย อ.เด่นชัย จ.แพร่', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1257, '6231280008', 'ea544e62942d42585977ed57c4952d0944849034', 'นาย', 'ธนาณุวรางค์', 'คำมูล', NULL, 'Safe.110piri2557@piriyalai.ac.th', NULL, '0654163395​', NULL, '157 ม.6 ต.ไทรย้อย อ.เด่นชัย', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1258, '6231280009', '8fa0ea9d62da87f8a9bbadac659716da8ee94a59', 'นาย', 'ณัฐภูมิ', 'ขันตี', NULL, 'lipzpoom@gmail.com', NULL, '0623098957', NULL, '130/3 ม.4 ต.ช่อแฮ อ.เมือง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1259, '6231280010', '1c555c67940d5b5316601f67f817a3ca7ed87c5b', 'นางสาว', 'ปวีณา', 'วงษา', NULL, 'gtoon2543@gmail.com', NULL, '0932963306', NULL, '118 หมู่4 ต.เด่นชัย อ.เด่นชัย จ.แพร่ 54110', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1260, '6231280011', '7e5395a7d77a25bc52cace3fda4d53801e82508d', 'นางสาว', 'พรชิตา', 'แสงคำ', NULL, 'Cherry254321@gmail.com', NULL, '0979564491', NULL, '84 หมู่11 บ้านมณีวรรณ ต.ป่าแมต อ.เมือง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1261, '6231280012', '67a74306b06d0c01624fe0d0249a570f4d093747', 'นาย', 'ภาณุพงศ์', 'เหมืองจา', NULL, 'panupong_maungja@piriyalai.ac.th', NULL, '0612908891', NULL, '207 ม.11 ซอย25 ต.ป่าแมต อ.เมืองแพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1262, '6231280013', '67a74306b06d0c01624fe0d0249a570f4d093747', 'นาย', 'นรบดี', 'มณีฉายกระจ่าง', NULL, 'maycry123456789@gmail.com', NULL, '0856957078', NULL, '206/2 หมู่12 ต.ป่าแมต อ.เมือง จ.แพร่ 54000', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1263, '6231280014', '67a74306b06d0c01624fe0d0249a570f4d093747', 'นาย', 'พงศ์เทพ', 'ไข่คำ', NULL, 'Zeroasqw@gmail.com', NULL, '0613541546', NULL, '82 หมู่9 อำเภอ สอง จังหวัด แพร่', NULL, 175, '54120', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1307, '6221280048', '67a74306b06d0c01624fe0d0249a570f4d093747', 'นางสาว', 'หญิง', 'กาสา', NULL, 'yingyeen55@gmail.com', NULL, '0955829442', NULL, 'บ้านเลขที่41/1 หมู่1\nต.บ่อเหล็กลอง อ.ลอง จ.เเพร่\n', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1306, '6221280047', '67a74306b06d0c01624fe0d0249a570f4d093747', 'นางสาว', 'ธัญพิมล', 'ดีกาศ', NULL, '-', NULL, '0624282979​', NULL, 'บ้านน้ำโค้ง 54/1 ม.14 ต.ป่าเเมต อ.เมือง จ.เเพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1305, '6221280046', 'f626bd042b77be89c7864e0a91757db9ba5b1c04', 'นาย', 'กฤติภัทร', 'ชมเชย', NULL, 'Beamzero46@gmail.com', NULL, '0924860625', NULL, '75 หมู่11 ต.ป่าแมต', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1304, '6221280045', '67a74306b06d0c01624fe0d0249a570f4d093747', 'นาย', 'ปรเมษฐ์', 'ทิพย์รักษ์', NULL, 'dayporametaum@gmail.com', NULL, '0654296861', NULL, '8/3. ม.10 ต.น้ำชำ อ.สูงเม่น จ.เเพร่ ', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1303, '6221280044', '67a74306b06d0c01624fe0d0249a570f4d093747', 'นางสาว', 'นรวรา', 'วัชรเลขะกุล', NULL, '', NULL, '0613175700', NULL, '22 ม.9 ต.แม่ยางตาล อ.ร้องกวาง จ.แพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1302, '6221280043', 'fd6a3a5a19e701bf3c4621ae968d03363c4b166a', 'นาย', 'ณัฐชนน', 'พรวญหาญ', NULL, 'notzaty7266@gmail.com', NULL, '0951605298', NULL, '83/2 หมู่6 บ้านลอง ต.บ้านหนุน อ.สอง จ.แพร่', NULL, 175, '54120', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1301, '6221280042', '67a74306b06d0c01624fe0d0249a570f4d093747', 'นาย', 'จักรภัทร', 'เรืองทอง', NULL, 'gu.boss.gu1@gmail.com', NULL, '0952909047', NULL, '45 หมู่11 ต.ร่องกาศ อ.สูงเม่น จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1300, '6221280041', '67a74306b06d0c01624fe0d0249a570f4d093747', 'นาย', 'พีรพัฒน์', 'ธนัญชัย', NULL, '', NULL, '0909938252 ', NULL, '53/2 ต.ท่าข้าม อ.เมืองเเพร่  จ.เเพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1299, '6221280040', '67a74306b06d0c01624fe0d0249a570f4d093747', 'นางสาว', 'สุริวิภา', 'เชียวศักดิ์', NULL, 'dee1234950@gamil.com', NULL, '0935606457', NULL, '233 หมู่4 ต.บ้านปง อ.สูงเม่น จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1275, '6231280015', '05d68aa4c47c4446d401c3df5b57105737d5e4ec', 'นาย', 'วิทยา', 'ตาเอ้ย', NULL, '', NULL, '0931564641', NULL, '17/2 ม.2 ต.บ้านปง อ.สูงเม่น จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1276, '6231280016', '3377d03e117ff4af4a71a2aa6221f0e8e73157f6', 'นาย', 'ชยุตพงค์', 'สุทธิประภา', NULL, 'fimeman12@gmail.com', NULL, '0956821278', NULL, '2/117 อ.เมือง ต.ในเวียง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1277, '6231280017', '872bfb357232ba80080343b434abf45976f7778e', 'นางสาว', 'เกวลิน', 'วงษา', NULL, 'sakansakanqq@gmail.com', NULL, '0910562633', NULL, '138 ม.4 ต.เด่นชัย อ.เด่นชัย จ.แพร่', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1278, '6231280018', 'a76dffc32571193afedc36b6b55f0ccd4407d6e0', 'นางสาว', 'พัฒน์นารี', 'ขลุ่ยแก้ว', NULL, 'patnareekhuykaew12@gmail.com', NULL, '0637595340', NULL, '47/2 ต.ปงป่าหวาย อ.เด่นชัย จ.แพร่', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1279, '6231280019', '67a74306b06d0c01624fe0d0249a570f4d093747', 'นาย', 'แทนคุณ', 'พิมพา', NULL, 'thann_khun@hotmail.com', NULL, '0896328938', NULL, '12 สันกลาง 5 ต.ในเวียง อ.เมือง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1280, '6231280020', '9a12f2e6daa090f15ceab4accb5b0636d6e5fc32', 'นาย', 'ธนากร', 'หงษ์สินสี', NULL, 'bookzahot005@hotmail.com', NULL, '0989179055', NULL, '31 หมู่ 3 ต.วังหงส์ อ.เมือง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1281, '6231280021', 'bcd4ea21052c0b6c5c3b3e3b75a391fcecebef13', 'นางสาว', 'กชกร', 'ลาภทิพย์', NULL, 'Kotchagorn254330@gmail.com', NULL, '0944515538​', NULL, '160/4​ หมู่​3​ ตำบล​ป่าแมต​ อำเภอเมือง​ จังหวัดแพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1282, '6231280022', 'eb85b43797fae779afce123bd153c142ab21a62c', 'นาย', 'ชัชวิทย์', 'ศรีพรม', NULL, 'peehi123@gmail.com', NULL, '0884052237', NULL, '157 หมู่ที่ 1 บ้านดอนชัย\n ต.สะเอียบ อ.สอง จ.แพร่', NULL, 175, '54120', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1283, '6231280023', '3a7e97364aac70d02002d9ee68fa48881c5e6261', 'นางสาว', 'วันวิสา', 'มีของ', NULL, 'wanwisa0795@gmail.com', NULL, '0966810795', NULL, '209/6 ม.5 ต.หัวฝาย อ.สูงเม่น จ.แพร่ ', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1284, '6231280024', '0e3082b73aa073e813add03ff060cb53c013ec66', 'นาย', 'พันธกานต์', 'วันดี', NULL, 'uppnightcore@gmail.com', NULL, '0850400151', NULL, '249 ม.15 ตำบล.ป่าเเมต อำเภอ.เมือง จังหวัด.เเพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1285, '6231280025', '67a74306b06d0c01624fe0d0249a570f4d093747', 'นาย', 'กิตติศักดิ์', 'จันทวัติ', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1286, '6231280026', '67a74306b06d0c01624fe0d0249a570f4d093747', 'นาย', 'ธีระวัฒน์', 'แก้วสง่า', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1287, '6231280027', '67a74306b06d0c01624fe0d0249a570f4d093747', 'นาย', 'วีรชาติ', 'พุฒตาล', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1288, '6231280028', '01ad862e4573e9805ee7c5c3e19a15c1bc87b594', 'นาย', 'เจษฎากร', 'ป่าธนู', NULL, 'jessadakon2559@gmail.com', NULL, '0637741544', NULL, '60 หมู่ 8 ตำบลป่าแมต อำเภอเมือง', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1289, '6231280029', 'bdce75fba7a5190682815dad3b01cbc11233037a', 'นาย', 'ภัทรกร', 'ขวัญเพชร', NULL, 'takedown8500@gmail.com', NULL, '0634831652', NULL, '11/5 ต.เด่นชัย อ.เด่นชัย ', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1290, '6231280030', '8fd21cad1e4068d8faa4d0eb9c36ffb7ba6ce56b', 'นาย', 'สุกิต', 'ธงสามสิบเจ็ด', NULL, 'sukit1306@gmail.com', NULL, '0987591306', NULL, '55 หมู่ 1 บ้านน้ำโค้ง ต.ป่าแมต อ.เมือง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1292, '6231280032', '67a74306b06d0c01624fe0d0249a570f4d093747', 'นาย', 'ณัฐวุฒิ', 'เกิดอุบล', NULL, 'aexza33@gmail.com', NULL, '0963713702', NULL, '37/2 ม.9 ต.ร่องกาศ อ. สูงเม่น จ.แพร่ 54130', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1293, '6231280033', '67a74306b06d0c01624fe0d0249a570f4d093747', 'นาย', 'ปัณณวัฒน์', 'ชมภูมิ่ง', NULL, 'website54120@gmail.com', NULL, '061-8801237', NULL, '62 หมู่ 9 บัานหนุน อ.สอง จ.แพร่', NULL, 175, '54120', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1294, '6231280034', '67a74306b06d0c01624fe0d0249a570f4d093747', 'นาย', 'เทพอวยชัย', 'สายสร้อย', NULL, 'pupsogood01@hotmail.com', NULL, '0980085480', NULL, 'ที่อยู่ปัจจุบัน 138/1 ม.7 ต.ทุ่งโฮ้ง อ.เมือง จ.แพร่\nที่อยู่ตามทะเบียนบ้าน\n122 ม.7 ต.ทุ่งโฮฺ้ง อ.เมือง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1295, '6231280035', 'e5d4eea7210e4c89c664963153ea8951e5fbd926', 'นาย', 'ณัฐฬากร', 'ตื้อยศ', NULL, 'yummust@gmail.com', NULL, '0612670776', NULL, '303/16 ม.7 ต.นาจักร อ.เมือง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1296, '6231280036', '805d20960c1869197ba20a8c88569bf079f04280', 'นาย', 'ชาญชล', 'บุญเเรง', NULL, 'mckiwmy99@gmail.com', NULL, '0947509549', NULL, '178 ม.5 ต.ทุ่งโฮ้ง อ.เมือง จ.เเพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1297, '6231280037', '67a74306b06d0c01624fe0d0249a570f4d093747', 'นาย', 'ธีรไนย', 'งามพ้อง', NULL, 'frank_frank2543@hotmail.com', NULL, '0947217187', NULL, '170/2หมู่9บ้านบวกโป่ง ต.น้ำชำอ.สูงเม่น จ.เเพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1308, '6221280049', '67a74306b06d0c01624fe0d0249a570f4d093747', 'นาย', 'ศุภกฤต', 'หงษ์เหาะ', NULL, 'supakit12300@gmail.com', NULL, '0886652132', NULL, '212หมู่1บ้านป่าแดงตำบลเตาปูปเอาเภอสองจังหวัดแพร่', NULL, 175, '54120', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1309, '6221280050', 'b7277f71c00c08e80e446f23f29ed8a5a0728c3e', 'นาย', 'รุ่งนิมิตร', 'ปนเปี้ย', NULL, 'roongnimit2358@gmail.com', NULL, '0979312358', NULL, '119/1 หมู่5 บ้านนาจอมขวัญ', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1310, '6221280051', '67a74306b06d0c01624fe0d0249a570f4d093747', 'นางสาว', 'ณฐริกา', 'วีระคำ', NULL, ' Natharika3876@gmail.com ', NULL, '0629498062', NULL, '54/1 ต.ป่าเเมต อ.เมืองจ.เเพร่ บ.น้ำโค้ง', NULL, 175, '5400', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1311, '6221280052', '67a74306b06d0c01624fe0d0249a570f4d093747', 'นางสาว', 'อรปรียา', 'นาคา', NULL, 'Onpreeyanaca@gmail. com', NULL, '0636511424', NULL, 'บ้านเลขที่56/2 ม.11ต.บ้านปินอ.ลอง จ.เเพร่', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1312, '6221280053', '90b9aa7e25f80cf4f64e990b78a9fc5ebd6cecad', 'นางสาว', 'เมญาณี', 'ศรีใจ', NULL, 'Meyani_2534@email.com', NULL, '0656652125', NULL, '108หมู่5ซอย3ตำบล แม่หล่าย อำเภอเมือง จังหวัดแพร่ ', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1313, '6221280054', '926c17cb8daeffc3e6de9b0d6cc3dedcc549fb36', 'นาย', 'จิรวัฒน์', 'ปุตา', NULL, 'jirawat.danamo@gmil.com', NULL, '0993843732', NULL, '68หมู่ที่10', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1314, '6221280055', '67a74306b06d0c01624fe0d0249a570f4d093747', 'นาย', 'ปฏิพล', 'ท้วมแก้ว', NULL, '', NULL, '0654166095', NULL, 'บ้านเลขที่107/2หมุ่4ต.แม่ปานอ.ลองจ.แพร่', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1315, '6221280056', '67a74306b06d0c01624fe0d0249a570f4d093747', 'นาย', 'อภิรักษ์', 'ข่มอาวุธ', NULL, '1540400145476a@gmail.com', NULL, '0947017726', NULL, '51/3 ม.1 ต.บ้านเหล่า อ.สูงเม่น จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1320, '6231280120', '5350a3554b3d02f7e00e9c6bdc11450a54e864f4', 'นาย', 'นนทภัทธ์', 'กันทะวงค์', NULL, 'tery_2811@hotmail.com', NULL, '0996084405', NULL, '21 ม.5 ต.ห้วยม้า อ.เมือง\n ', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1321, '6231280121', '9ed27cdcbc3818784c1e6bcd123c687c1cdf7f54', 'นางสาว', 'ทินประภา', 'ปัญญากอง', NULL, 'tinprapa59@gmal.com', NULL, '0644212438', NULL, '91/2 ม.12 ต.ทุ่งแล้ง อ.ลอง จ.แพร่', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1322, '6231280122', '077ead40f3a96c688f232520acf7b04d5abb602b', 'นาย', 'วสันต์', 'ศรีเครือมา', NULL, 'gotter1230@gmail.com', NULL, '0613391304', NULL, '169/1 หมู่12 บ.หัวฝาย อ.สูงเม่น\nจ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1323, '6231280123', '6f9a7aa1b09fcf1b3ef379d68d66024b2a98b8da', 'นาย', 'กรินทร์', 'เหมืองหลิ่ง', NULL, 'semmyblock@gmail.com', NULL, '0928688041', NULL, '169/3 ม.9 ต.บ้านถิ่น อ.เมือง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1324, '6231280124', '21531cef1cc87b864f24b3a8c7e75ac34c5af5b2', 'นาย', 'ธีรภัทร์', 'ผาแก้ว', NULL, 'kenstar123456789@gmail.com', NULL, '0932644511', NULL, '45/1 หมู่ที่9 ต.ห้วยอ้อ\nอ.ลอง จ.แพร่', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1325, '6231280125', 'b3e95e8b14cccad3b42cd6586a2eababf28295f9', 'นางสาว', 'ปิยะนุช', 'สินธุวงค์', NULL, 'Piyanut16022543@gmail.com', NULL, '0830049685', NULL, '195 หมู่2 ต.แม่ทราย อ.ร้องกวาง จ.แพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1326, '6231280126', '976f34a035980b9bca79469fe1db75317e199b37', 'นาย', 'รัตนชัย', 'ฝักฝ่าย', NULL, '', NULL, '0903199868', NULL, '84/3​ ม.4​ ต.หัวฝาย​ อ.สูงเม่น​ จ.แพร่​ ', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1327, '6231280127', '12ed56a2fdd095697ddc12a2965da3998ee883b3', 'นาย', 'นัทธวัฒน์', 'หงษ์ยศ', NULL, 'Dreamaz752@gmail.com', NULL, '0621471246', NULL, 'บ้านเลขที่29 หมู่3 ตำบล วังหงส์ อำเภอ เมือง จังหวัด แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1328, '6231280128', 'f9332a2e4a3993919c3ea9b350bf44a6c97939ce', 'นาย', 'วิศรุต', 'ขอบปี', NULL, 'bookwisarut43@gmail.com', NULL, '0979707845', NULL, '123 ม.11 ต.นํ้าชำ อ.สูงเม่น จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1329, '6231280129', '72b0c91ba440a5dac9160a55ff6572e22923fd54', 'นางสาว', 'ภัสราพร', 'โคตสุภา', NULL, 'padsaraporn9318@gmail.com', NULL, '0931608780', NULL, '96 หมู่5 ต.บ้านปง อ.สูงเม่น จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1330, '6231280130', '96d9d6cf1a5ef1d89aca0f2cc6a48d4e7fb4d16f', 'นาย', 'ไพโรจน์', 'กรุณาก้อ', NULL, 'naelnw123123@hotmail.com', NULL, '0906738764', NULL, ' 86/9 ม.3 ต.ป่าเเดง อ.เมือง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1331, '6231280131', 'c505efd8d462ea9dcd05d6e8d53387ded354e2a1', 'นาย', 'ศรัณย์', 'คงจันทร์', NULL, 'sarankhongchan@gmail.com​', NULL, '0917601647​', NULL, '147 หมู่ 1 ตำบล เหมืองหม้อ อำเภอ เมือง จังหวัด แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1399, '6221280060', '7e729e0b1dc8d70266e4384647ae14bd52e4b0f5', 'นาย', 'มลฑล', 'เววา', NULL, 'monton.wew@gmail.com', NULL, '0623304793', NULL, '16 ม.5 ต.หัวทุ่ง อ.ลอง จ.แพร่', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1414, '63201280001', '620eb707b6637ba40f0a33dfc551a5298cd3ba9e', 'นางสาว', 'เจนจิรา', 'มิ่งขวัญ', NULL, 'janjiranj2561@gmail.com', NULL, '0992739578', NULL, '114/6 หมู่ที่1 ตำบลบ้านปง อำเภอสูงเม่น จังหวัดแพร่ ', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1415, '63201280002', '692faaede3f7bb5d3afe76195296ecfd8bc8a1c2', 'นางสาว', 'ทิพย์ธิดา', 'ต้นศิริ', NULL, '', NULL, '', NULL, 'ต.ห้วยอ้อ อ.ลอง จ.แพร่', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1416, '63201280003', '1883b146cb5209cb41ddfe7941d279791d1aef0d', 'นาย', 'รัฐภูมิ', 'สีจักรเงิน', NULL, 'bitebite023@gmail.com ', NULL, '090326726', NULL, '17/2 แม่จั๊วะ เด่นชัย จ.แพร่ 54110', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1417, '63201280004', '13e9618c10a6867b12a1e1d5a0c7dcc2d1849028', 'นาย', 'ณัฐนนท์', 'ปัญญาไว', NULL, 'nattanon4973@gmail.com', NULL, '0805014973', NULL, '23/2 หมู่11 อ.เมือง จ.แพร่ ต.เหมืองหม้อ', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1418, '63201280005', '506beea0deb6e46675a79031596ec44d6a6c35c3', 'นางสาว', 'ณัฏฐณิฌา', 'สีเข้ม', NULL, 'ximsexx@gmail.com', NULL, '06-30637751', NULL, '601/18 ถนน น้ำทอง ต.นาจักร อ.เมือง จ.เเพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1419, '63201280006', '9b553679d168c4fc7258812f139ab266d8e69eb9', 'นาย', 'พัชพล', 'โค้คำหล้า', NULL, 'cat254786@gmail.com', NULL, '0996084146', NULL, '70 หมู่ 1 ต.ปงป่าหวาย อ.เด่นชัย จ.แพร่ 54110', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1420, '63201280007', '846c55e5356dcf8e4762c012db22c19d1087c369', 'นาย', 'พิสิฐ', 'หงษ์สี่', NULL, 'simgard1112@gmail.com', NULL, '0969300749', NULL, '107 ต.วังหงส์​ อ.เมือง​ จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1421, '63201280008', '8804a1edbeaa87660d6584e6dc27507cfcdc86b7', 'นางสาว', 'ชาลิสา', 'ปัญจะศรี', NULL, 'mintkung23@gmail.com', NULL, '0963756136', NULL, '183 ม.9 ต.บ้านเวียง อ.ร้องกวาง จ.แพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1422, '63201280009', 'ac34c3675e3ded3286e65d421cd2b1ac0db9bd47', 'นาย', 'ธีรวุฒิ', 'เทพวีระพงศ์', NULL, 'Wutgods777@gmail.com', NULL, '0648010012', NULL, '75/1 หมู่2 ต.วังธง อ.เมือง', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1423, '63201280010', '9b9cc0670b4c99b2a6f5f989708749f60c9fba1d', 'นาย', 'กิตตินันท์', 'วุฒิ', NULL, 'owenrockker@gmail.com', NULL, '0618120571', NULL, '67 หมู่3 ตำบลเเมาหล่าย อำเภอเมือง ', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1424, '63201280011', '9e33c582f9165807dc5457085c673b80d2d10d66', 'นาย', 'กรกช', 'ถือนิล', NULL, 'dewazfbi54110@gmail.com', NULL, '0830046419', NULL, '10/1 ตำบล แม่จั๊วะ อำเภอ เด่นชัย', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1476, '63301280001', '68421c5c067abaa27f46ff6c240cfba737cfbdf3', 'นาย', 'พุฒิพงศ์', 'หลีแก้วสาย', NULL, 'aun0695@gmai;.com', NULL, '0979410695', NULL, '62/2 ม.1 ต.สวนเขื่อน อ.เมือง ', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1426, '63201280012', 'bac67533b5bfa1b62cca88e80a06b5a260760219', 'นาย', 'อเนชา', 'จากน่าน', NULL, 'anecha54150@gmail.com', NULL, '0638191015', NULL, '124 ม.9 ต.หัวทุ่ง อ.ลอง\nจ.แพร่', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1427, '63201280013', '613a1a30ae7d3f5097e9f601dc77c0527b76cff4', 'นาย', 'สุริยพร', 'พรมนันท์', NULL, 'min333zaza@gmail.com', NULL, '0946312660', NULL, '5 หมู่6 ต.แม่ยางฮ่อ\nอ.ร้องกวาง จ.แพร่​', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, '');
INSERT INTO `tb_member` (`member_id`, `member_code`, `member_password`, `member_title`, `member_firstname`, `member_lastname`, `member_gender`, `member_email`, `member_tel`, `member_mobile`, `member_fax`, `member_address`, `member_district`, `province_id`, `member_zipcode`, `member_registerdate`, `member_company`, `member_company_no`, `member_level`, `member_approve`, `member_last_login`, `member_note`, `member_line_token`, `member_line_token2`, `member_line_token3`, `member_line_token4`, `member_line_token5`, `member_type`, `student_id`, `member_img`) VALUES
(1428, '63201280014', '2c92166ad32c388fa32d1f79d1cdac5351cfff99', 'นางสาว', 'แพรพลอย', 'ใจนาวา', NULL, 'praeployjainawa@gmail.com', NULL, '0646762620', NULL, '180 หมู่ที่8 บ้านทรายมูลเหนือ ตำบลแม่ยางตาล อำเภอร้องกวาง จังหวัดแพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1429, '63201280015', 'daa46c61c43b659b834835f1fbaf404f80167491', 'นาย', 'นัทธพงศ์', 'แก้วมณี', NULL, 'bankwoks@gmail.com', NULL, '0647267187', NULL, '34', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1430, '63201280016', '4a8fe087b327b64200bd7a200fc226a7520e0c15', 'นาย', 'ชญานนท์', 'คำเป็ง', NULL, 'chayanon5826@gmail.com', NULL, '0800324528', NULL, '43/1 หมู่1 ตำบล.ห้วยอ้อ อำเภอ.ลอง จังหวัด.แพร่\nบ้านแม่เกี่ยม', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1431, '63201280017', '9e3b386f7165b78aa0753a2fc09a0abb034a1d3e', 'นาย', 'ภูวดล', 'วัลลภัย', NULL, 'addguhfd@gmail.com', NULL, '0956368720', NULL, '128/10 ตำบล ต้าผามอก\nอำเภอ ลอง จังหวัด เเพร่', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1432, '63201280018', '448a1bc1bb02658dcbb8d885a23539a6251d2186', 'นางสาว', 'ธิดาลักษณ์', 'เรือนมูล', NULL, 'Nunnyjokingly01@gmil.com', NULL, '0909351386', NULL, '223หมู่4ตำบลน้ำชำอำเภอสูงเม่นจังหวัดแพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1433, '63201280019', '28aa7ff29675e25645e274f2b72316f35d024598', 'นาย', 'เจษฎากร ', 'อาดุลย์สวัสดิ์', NULL, 'jesdakorn2529@gmail.com', NULL, '0639896804', NULL, '205/2  หมู่9 ซอย4', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1434, '63201280020', 'e6200399e8af298af8c8c713926cec08f982654f', 'นาย', 'วิษณุ', 'วังกระแสร์', NULL, 'wisanuzaza57231@gmail.com', NULL, '0966477421', NULL, '261 ม.1 ต.หนองม่วงไข่ อ.หนองม่วงไข่ ', NULL, 175, '54170', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1435, '63201280061', '9692dd4c2cda4f7f250204942fc01cd01d535442', 'นาย', 'นพรัตน์', 'คงยืน', NULL, 'khngyunn9@gmail.com', NULL, '0951838304', NULL, '64/1 หัวฝาย สูงเม่น แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1436, '63201280021', 'f891fc4db28dd41a27d432f03d96623f36612858', 'นางสาว', 'ชลธิชา', 'ธิน่าน', NULL, '0979253089', NULL, '0822524267', NULL, '45/1', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1437, '63201280022', '33d78339974b74d7d4c3b375829b2fe1b434122b', 'นาย', 'กษิดิศ', 'แควชล', NULL, 'earthleoza123@gmail.com', NULL, '0948279378', NULL, '7/1หมู่7 ตำบล.ป่าแมต\nอำเภอ.เมือง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1438, '63201280023', '6a99cdc2b9484f616e47a32f09e01842e59d2e5d', 'นาย', 'ศิริพงศ์', 'บุญประสิทธิ์', NULL, 'Siripong.2320@gmail.com', NULL, '0987852320', NULL, '175 ถ.ร่องซ้อ ต.ในเวียง อ.เมือง', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1439, '63201280024', 'b9e33fea3dbce3adcea17a7f84f7bbec2b30480c', 'นาย', 'วิศวะ', 'คำเหมือง', NULL, 'new6045@gmail.com', NULL, '0813546112', NULL, '65/1 หมู่2 ต.เหมืองหม้อ อ.เมือง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1440, '63201280025', '331f883de6e297d8f4e22ffac49e7bde41b88078', 'นาย', 'มนัสวิน', 'นาทาม', NULL, 'exarotza@gmail.com​', NULL, '0620419037', NULL, '47/1\n-', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1441, '63201280026', '7f7220c6f2ebf91ee38c12a8698f193a7bfad5c0', 'นาย', 'ปฏิภาณ', 'ลวดเหลือ', NULL, 'gameawd234@gmail.com', NULL, '0824725245', NULL, '99/2 หมู่1 ตำบลนํ้าชำ อำเภอสูงเม่น', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1442, '63201280027', '6ec68fc429eeaf5b1249984e2713b8bcd6064d35', 'นาย', 'ยศวรรธน์', 'ทะนันชัย', NULL, '', NULL, '0864339354', NULL, 'บ้านเลขที่173​ ตำบลแม่คำมี\nอำเถอเมือง​ จังหวัดแพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1443, '63201280028', '96fdfca286b59a912775a73b9370e05f1f6a8c6c', 'นาย', 'กรวิชญ์', 'ศรีประเสริฐ', NULL, 'uanotnoob00@gmail.com', NULL, '0886547215', NULL, 'บ้านเลขที่ 90 ม.2 ต.สูงเม่น อ.สูงเม่น', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1444, '63201280029', 'e16d355b4dc8303b039617764070c0637e2b5612', 'นาย', 'สรยุทธ์', 'แก้วมา', NULL, 'sorrayutkaewma029@gmail.com', NULL, '0629437652', NULL, '392 หมู่8 ต.แม่ยางตาล\nอ.ร้องกวาง', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1445, '63201280030', 'c1eed8b163b08c3663086209ef2d93446ac12089', 'นาย', 'ศรัญญู', 'ลียะวงศ์', NULL, '0830628418zaa@gmail.com', NULL, '0932485452', NULL, 'บ้านเลขที 7 หมู่ 7 ต.ปงป่าหวาย อ.เด่นชัย', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1446, '63201280031', 'a00aaf5068a553d8fa6a121f694d40e978cdf039', 'นาย', 'กิตติภูมิ', 'ศรีลา', NULL, 'Kittipoom8848@gmail.com​', NULL, '0622538848', NULL, '90​หมู่7ต.น้ำเลา​ อ.ร้องกวาง​  จ.แพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1447, '63201280032', '1e80aab1dec63fbc5ca17d06d5dafb96df7442bb', 'นาย', 'พีรพัฒน์', 'วงค์จวง', NULL, '-', NULL, '0806267609', NULL, '90หมู่2 ต.ปงป่าหวาย อ.เด่นชัย จ.เเพร่', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1448, '63201280033', '223159ace169ba21da0a3efc8c8a8ae1bef52506', 'นาย', 'จรูญ', 'น้อยอุบล', NULL, 'gbmew2468@gmail.com​', NULL, '0654402673', NULL, '67/3หมู่4​ อ.ลอง​ ต.เวียงต้า', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1449, '63201280034', '806b63ae35dd49eac9b6fce7b3146791027acccd', 'นาย', 'วชิรวิทย์', 'แก่นโท', NULL, 'wachi3079@gmail.com', NULL, '0951643742', NULL, '89/1 หมู่ 3 ต.ดอนมูล อ.สูงเม่น จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1450, '63201280035', '8ce49fcbd0fbc8c66a2c8f75b6e14514d7423894', 'นาย', 'รักษ์ศักดิ์', 'วิชัยปะ', NULL, 'raksakbank6306@gmail.com', NULL, '0932376306', NULL, '26/2 หมู่1 แม่ยางตาล ร้องกวาง แพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1451, '63201280036', '1865302a7673647b6bc41bb9b9941a17eea2c9a7', 'นาย', 'อภิรักษ์', 'จำปาจี', NULL, 'Kimsentch@gmail.com', NULL, '0803203709', NULL, '70/3 หมู่ 2 ตำบลตำหนักธรรม อำเภอหนองม่วงไข่\n', NULL, 175, '54170', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1452, '63201280037', '7f9f68436e5ccbabbfddf14efeb08bfeb6489c50', 'นางสาว', 'อาทิตยา', 'พลอยประดิษฐ์', NULL, '0994672327', NULL, '0994672327', NULL, '225/3ต.บ้านกวาง อ.สูงเม่น \nจ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1453, '63201280038', '57f53228a3aec6c1fb2a5d5890a7a72496e07f33', 'นางสาว', 'เสาวภาคย์', 'เจริญวัย', NULL, 'Saowaphak47m74@gmail.com', NULL, '0931608163', NULL, '92 ม.5 ต.ป่าเเมต อ.เมือง จ.เเพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1454, '63201280039', '1fa0c240d161353f02aaaa29d798b0dc5459e4c5', 'นางสาว', 'พรนัชชา', 'ม่วงมัน', NULL, 'phornnucha@gmail.com', NULL, '0624240554', NULL, '132 หมู่7 ตำบล ห้วยไร่ อำเภอ เด่นชัย จังหวัด แพร่', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1455, '63201280040', '51eeaa0bf93e85182c77a50cf6ff8e2f3577ee84', 'นาย', 'หนึ่งเดียว', 'สมกำลัง', NULL, 'nuengny48@gmail.com', NULL, '0843659075', NULL, 'บ้านเลขที่20 หมู่3 ตำบล.ร้องกวาง อำเภอ.ร้องกวาง จังหวัด.แพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1456, '63201280041', 'e097f6849ff389db65af1277413e0f29f8cc2ea4', 'นาย', 'ณัฐพงษ์', 'พูลทวี', NULL, 'jildusk5018@gmail.com', NULL, '0636610283', NULL, '3 หมู่3 ต.ต้าผามอก ', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1457, '63201280042', 'caaeb462c05be9b9376109716850076b433e262e', 'นาย', 'วงศพัทธ์', 'ปลาหนองแปน', NULL, 'oobbook342@gmail.com', NULL, '0931464162', NULL, '29/5 แม่ยางฮ่อ ร้องกวาง จังหวัดแพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1458, '63201280043', '54e3eaa13017ba70a081157de3c7045cdb5ffe10', 'นาย', 'ภูริภัทร', 'พุทธทรง', NULL, 'Kimmberry@gmail.com', NULL, '0931692083​', NULL, 'สอง บ้านวังฟ่อน หมู่12', NULL, 175, '54120', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1459, '63201280044', 'b05f1baea66d24676b2a85726a9561b1e7028d62', 'นาย', 'สุทธิพงค์', '', NULL, '', NULL, '0952802955', NULL, '', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1460, '63201280045', '2b8ce12f5000fed1a1de9b4e477a0212591a14a9', 'นาย', 'ชัยวัฒน์', 'โปร่งเส็ง', NULL, 'kiroymoy@gmail.com', NULL, '0654655754', NULL, '51/1หมู่6ต.เหมืองหม้อ อ.เมือง จ.เเพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1461, '63201280046', 'eda9f51c2cba287f23392359b3799d153775a96e', 'นาย', 'นภัสกรณ์', 'เวียงยา', NULL, 'Napatsakorn.4392@gmail.com', NULL, '0882637300', NULL, '5/2 ม.6 ต.เหมืองหม้ออ.เมือง จ.เเพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1462, '63201280047', '3c6ae727b2ff22cbd73124c1e5ed2a5f3d818fc4', 'นางสาว', 'ชีวรัตน์', 'สุขมะโน', NULL, 'Sp601114@songpit.ac.th', NULL, '0863066982', NULL, '466 ม.1 ต.เตาปูน อ.สอง จ.แพร่', NULL, 175, '54120', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1463, '63201280048', '23de17c2178d858f9e96d2edbd5bccbe53954cfa', 'นาย', 'พันธ์ธวัช', 'สุธรรม', NULL, '', NULL, '0963583801', NULL, '84 ม.9 ต.บ้านกลาง อ.สอง จ.แพร่ ', NULL, 175, '54120', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1464, '63201280049', '5b1233d188402351461fda8e35bcf473f1a7bfe1', 'นาย', 'เมธวิน', 'ภักดีโต', NULL, 'Metawin47@gmail.com', NULL, '0638042182', NULL, '207/2 บ้านป่าผึง หมู่5 ต.หัวฝาย อ.สูงเม่น จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1465, '63201280050', 'aa9ee3491879dc41675b76236d5335634b7f7c02', 'นาย', 'ธนกฤต', 'จันละคร', NULL, 'Thanakirtzazxx@gmail.com​', NULL, '0933062587', NULL, '4/1 หมู่5 ต.ร้องกวาง อ.ร้องกวาง จ.แพร่ บ้านวังโป่ง', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1466, '63201280051', '814f22749f872066dddab5fe1b0b679daea7e6bf', 'นางสาว', 'นภัสวรรณ', 'ม่วงศรี', NULL, 'napatasawan2647@gmail.com', NULL, '0815741512', NULL, '172/2 บ้านดอนแท่น ต.ดอนมูล อ.สูงเม่น จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1467, '63201280052', 'dc09612c9cf0a72c1b84f36e47ed717bcccd0d7a', 'นาย', 'สุพิชญา', 'ปัญญากอง', NULL, '', NULL, '0989982710', NULL, '104/5 ตำบลบ้านปง อำเภอสูงเม่น จังหวัดเเพร่ ', NULL, 175, '54132', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1468, '63201280053', '089d77b4c29d54fa46ce6b1f03efd3e536f1add9', 'นาย', 'อนุสรณ์', 'ยศตระกูลสิริ', NULL, 'anusorn58138@gmail.com', NULL, '0610162312', NULL, '28/9', NULL, 124, '55150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1469, '63201280054', '1f5a69bd20b63b29947bbfe8ff42da70974fc91e', 'นาย', 'มนัญชัย', 'กาศมัยจันทร์', NULL, 'inwbewchan@gmail.com', NULL, '0821826107', NULL, '113 บ้านปง หมู่8 ต.ห้วยม้า อ.เมือง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1470, '63201280055', 'fabaa4954b85eff35c2a4952d2a77ca8399a2ea0', 'นาย', 'อาณาจักร', 'ข่มอาวุธ', NULL, 'wedoza112@gmail.com', NULL, '0972077491', NULL, '7/2 หมู่6 ต.บ้านกวาง อ.สูงเม่น จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1471, '63201280056', 'a7eab6fb0587f1ce84338abfde0582d665701b37', 'นาย', 'ชนชล', 'สายถิ่น', NULL, 'Chanachon95.ch@gmail.com', NULL, '0647568195', NULL, 'บ้านโปร่งศรี​ หมู่6​ เลขที่18​ ตำบลบ้านถิ่น​ อำเภอเมือง​ จังหวัดแพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1475, '63201280060', 'efc2979a4c967e8921727c0b31744595e845f120', 'นางสาว', 'ธนัชชา', 'ยนต์คำแสน', NULL, 'khim1622547@gmail.com', NULL, '0646653140', NULL, '463 หมู่8 บ้านท่าม้า ต.สูงเม่น อ.สูงเม่น จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1477, '63301280002', 'bbbc4e5c8691c19d9c6c4f1b28c81d3f2ff721a3', 'นาย', 'ยุทธศักดิ์', 'สลับศรี', NULL, 'thebellzice@gmail.com', NULL, '0924184459', NULL, '121/2 ต.แม่ทราย อ.ร้องกวาง', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1478, '63301280003', '7281d7f1dccb2f2f9fa8a25bd87e10a51181c47d', 'นาย', 'อรรถกร', 'ญาณปัญญา', NULL, 'armarmtyuio@outlook.co.th', NULL, '0910450527', NULL, '69/2 หมุ่1 บ้านสบเกิ่ง ตำบลแม่เกิ๋ง อำเภอวังชิ้น จังหวัดแพร่', NULL, 175, '54160', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1479, '63301280004', '71cca2691e92576f099ccc80a9f4f1caba91df03', 'นาย', 'ณัฐภัทร', 'เจริญกิจหัตถกร', NULL, 'fixnattapat@gmail.com', NULL, '0857197997', NULL, '27/2-3ถ.ราษฎร์ดำเนิน\nต.ในเวียงอใเมืองแพร่จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1480, '63301280005', '9db1fe506613c11b4c1f7454065454b7c4c16d2e', 'นาย', 'เจษฎา ', 'ถาโถม', NULL, 'gtaman258@gmail.com', NULL, '0800977083', NULL, '58/3 ม.1 ต.ป่าแมต อ.เมืองแพร่ จ.แพร่ 54000', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1481, '63301280006', '0282c08ee8d7f82080f29bf1b711dfadc68b4309', 'นางสาว', 'พัชรพร', 'จันทร์คำ', NULL, 'patchaporn.2001@gmail.com', NULL, '0658459697', NULL, '52/1 ม.2 ต.แม่ยม ', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1482, '63301280007', '09b926fd50802f17f65e941b7f808802db2cc5f1', 'นางสาว', 'ศิริลักษณ์', 'กิ่งสาร', NULL, '', NULL, '0635032681', NULL, '25 หมู่ 4 ต.นาจักร อ.เมือง จ.แพร่ ', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1483, '63301280008', '22cdbe79563fbcfac8c8eb968cdef04a294b66b8', 'นาย', 'ศิลา', 'นาเมืองรักษ์', NULL, 'winbp123bp@gmail.com', NULL, '0966748516', NULL, '94 หมู่ที่ 4 ต.ห้วยม้า อ.เมือง จ.แพร่ 54000', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1484, '63301280009', '7281d7f1dccb2f2f9fa8a25bd87e10a51181c47d', 'นาย', 'ธีรภัทร', 'แก้วกัลยา', NULL, 'tee0613280473@gmail.com', NULL, '0613280473', NULL, '106 หมู่7 ต.น้ำเลา อ.ร้องกวาง จ.แพร่\n-', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1485, '63301280010', '2694f1c5f9d5406077545d2a20ad444f175f9e34', 'นาย', 'พิชชากร', 'แสนกือ', NULL, '-', NULL, '0644575309', NULL, '101 ม.13 ต.บ้านเวียง อ.ร้องกวาง จ.เเพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1486, '63301280011', '7f5dca66e1774acdbd3e04406982b07a5accb10b', 'นาย', 'ทินภัทร', 'ทองประไพ', NULL, 'newsgt700@gmail.com', NULL, '0803937036', NULL, '72/1 ม.5 ต.วังหงส์\nอ.เมืองแพร่ จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1487, '63301280012', 'fe09ab87fed6511c7266a9eb0e5a93024ccc9ae6', 'นาย', 'อนุพัฒน์', 'ขอร้อง', NULL, 'Anupat9756@gmail.com', NULL, '0638164497', NULL, '3/4 หมู่.10 บ้านโตนเหนือ\nตำบลสูงเม่น อำเภอสูงเม่น\n', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1488, '63301280013', 'a9cc4f14075408c4180656e102d5c740bb3252ac', 'นาย', 'นันทวัฒน์', 'กุศลส่ง', NULL, 'Dearzaing080@gmail.com', NULL, '0951166762', NULL, '154 หมู่2 ต.กาญจนา อ.เมือง จ.แพร่ ', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1489, '63301280014', 'c3175f82070bb0f33d7d5da4797624166076b467', 'นาย', 'คริสต์มาส', 'วุฒิ', NULL, 'turboboyrider@gmail.com​', NULL, '0646706415', NULL, '12 หมู่3 ต.แม่หล่าย อ.เมือง', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1490, '63301280015', '21a42ae8ec6ca327c57234a33b564f4634d6e006', 'นางสาว', 'ฐิดาพร', 'สำรองพันธุ์', NULL, 'dream03062544@gmail.com', NULL, '0882572293', NULL, '79 หมู่9 ตำบลกาญจนา อำเภอเมือง จังหวัดแพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1491, '63301280016', 'f05c7ae1d47fd8e268297289e406de9bab68525f', 'นาย', 'โอภาสพันธ์', 'กลิ่นชื่นจิต', NULL, 'Impan_1611_2544@hotmail.com​', NULL, ' 0984167736​', NULL, '69/4​ ม.1​ ต.เหมืองหม้อ​ อ.เมือง​ จ.แพร่​ ', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1492, '63301280017', '9ec75f69fcd8557a71e06a727da29bf57952e76f', 'นาย', 'ชนาธิป', 'วรกิจพาณิชกูล', NULL, 'Nako1122544@gmail.com', NULL, '0643590896', NULL, '108/1 ม.1 ต.แม่ยางร้อง อ.ร้องกวาง จ.แพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1493, '63301280018', '8a323daf6719912ecbf8a6fad48c44540c46f3f0', 'นาย', 'ณัฐชนน', 'สังข์ทอง', NULL, 'nadchanon11@gmail.com', NULL, '0954538784', NULL, '42 ม.7 ต.ห้วยอ้อ อ.ลอง จ.แพร่', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1494, '63301280019', '348703629b9aa78e5c03e9f7c1246a679c0a036c', 'นางสาว', 'สุดารัตน์', 'จำปาจี', NULL, 'tarsudarat5555@gmail.com', NULL, '0944168020', NULL, '223/1 ซอย2 หมู่4 ต.ตำหนักธรรม อ.หนองม่วงไข่ จ.แพร่ ', NULL, 175, '54170', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1495, '63301280020', '0effe9bb75d53d2255024c8aba657759b16d33ad', 'นางสาว', 'กมลทิพย์', 'นพพันธ์', NULL, 'Kamolthip.n2002@gmail.com', NULL, '084-073-4547', NULL, '50/8 หมู่ 4 ต.เด่นชัย อ.เด่นชัย จ.แพร่', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1496, '63301280022', 'd5e9d5e909bffd64ed433ea8c25022e1edc7093a', 'นาย', 'พิชญ์ภัค', 'หลีเจริญ', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1497, '63301280023', '76d54a710fa99e6610f633a873d222f58b876c78', 'นาย', 'ชาคริต', 'ปลงใจ', NULL, 'benz25047@gmail.com', NULL, '0965620938', NULL, '139 หมู่ 7 ตำบล เหมืองหม้อ อำเภอ เมือง จังหวัดแพร่ ', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1498, '63301280100', '89f29fe6bc810a88d2e9674be896999078ec8307', 'นางสาว', 'ปรียาภัทร', 'วงค์อนุ', NULL, 'bam624326@gmail.com', NULL, '0645051571', NULL, '159 ม.7 ต.ช่อแฮ อ.เมือง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1499, '63301280101', '4c3bbdd758be529ac01e2b79713d54b720502928', 'นางสาว', 'ณัฐธิดา', 'ไชยมา', NULL, 'nuttidachaima55@gmail.com', NULL, '0930015816', NULL, '113 บ้านเเม่จอก หมู่8 ต.แม่ป้าก อ.วังชิ้น จ.แพร่', NULL, 175, '54160', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1500, '63301280102', 'ce12da13c3906f6e3087717044e566a9eb90b54c', 'นาย', 'อนันต์ดา', 'มุ้งกุลณา', NULL, 'dewlove460@gmail.com', NULL, '0649268036', NULL, 'อ.เมือง ตำบลสวนเเขื่อน บ้านแม่แคม หมู่7 125', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1501, '63301280103', '0055c1ea8fac6f645fd6a2a37b0eff8faae311a9', 'นาย', 'ณัฐกิตต์', 'พรานกวาง', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1502, '63301280104', 'e70d0543460b37f96acf58221ba0106cb5ab4e76', 'นางสาว', 'พัชรพร', 'อ่อนคำ', NULL, 'beebph@gmail.com', NULL, '0636655401', NULL, '17/2 ม.9 ต.ห้วยอ้อ อ.ลอง จ.แพร่ ', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1503, '63301280105', '654c970c38eba34cb2093716862525bfd6aff0c2', 'นาย', 'ศิวัช', 'วงศ์คำแก้ว', NULL, 'Maxsiwat1@gmail.com', NULL, '0983363119', NULL, '55 พระนอน อ.ในเวียง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1504, '63301280106', '98b0f242ee333c3ade3c59602162b0329d3f4a7c', 'นาย', 'เจษฎา', 'จันทร์แสง', NULL, 'jameeeeeezaa@gmail.com', NULL, '0931474089', NULL, '400/100 ต.นาจักร อ.เมืองแพร่ จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1505, '63301280107', 'd3f7e0595868eb3ca2f2d7ea8916ff04451ced18', 'นาย', 'คทาทร', 'สุวรรณเสวตร', NULL, '', NULL, '0827785400', NULL, '22/1 ม.3 ต.ป่าแดงอ.เมือง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1506, '63301280108', '70d48f45c0daf5f56abaecabdcd2bf3adc63be8e', 'นางสาว', 'กนกมาศ', 'กันทาท้าว', NULL, 'meaw0667@gmail.com', NULL, '09-31961610', NULL, '91/1 ม.3 ต.ห้วยม้า', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1507, '63301280109', '0b765323249b40f391408aed1e879928bb102cf8', 'นาย', 'ณัฐพงษ์', 'ธรรมสอน', NULL, 'huaronarmyatk@gmail.com', NULL, '0946020623', NULL, '376 ม.3 ต.บ้านหนุน อ.สอง จ.แพร่', NULL, 175, '54120', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1508, '63301280110', 'cb2cb2a66daaa59173defb38eb98d8710501a1a7', 'นางสาว', 'ลักษมี', 'อิโสมิ', NULL, '', NULL, '0640843630', NULL, '22 หมู่6 ต.ช่อแฮ อ.เมือง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1510, '63301280024', 'af2e954e02cf671b5b6586dc381af9471faa0432', 'นางสาว', 'สิริกร', 'คำลือ', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1515, '63301280111', '0937afa17f4dc08f3c0e5dc908158370ce64df86', 'นาย', 'รัชพล', 'ทรายอินทร์', NULL, 'ratchaponmat005@gmail.com', NULL, '0658122458', NULL, '29/1 ม.3 ต.แม่ทราย อ.ร้องกวาง จ.แพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1516, '63301280112', '9e5cf8bd14f0d03ae3202eb016f4ecdc152fe63e', 'นางสาว', 'ปฑิตตา', 'ดำรงไชย', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1517, '63301280113', 'be18605922bc32e4f96d6d1b4912918f288747de', 'นางสาว', 'วิชญาดา', 'ดีมาก', NULL, 'wichayada09556@gmail.com', NULL, '0955642448', NULL, '57/3ม.4 ต.หัวฝาย อ.สูงเม่น', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1518, '63301280114', 'bb2774709b9d91ada3bafc1cd0c80d54c98f8daf', 'นาย', 'ภูมิธฤทธิ์', 'ขุนเงิน', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1521, '63201280062', 'b832f41e1f62c106a0fe510bdeb309857f5f5e01', 'นางสาว', 'ณัฎฐนิชา', 'คำร้อง', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1522, '63201280063', '9bea12111ed28af5a4ca31d1cf8667e8a9df2fee', 'นาย', 'ชัยวัฒน์', 'จันทร์แก้ว', NULL, 'film01155@gmail.com', NULL, '0909694383', NULL, '9/1 ต.บ้านเวียง อ.ร้องกวาง จ.แพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1525, '63301280025', '943e6674564e12e342d0406cd79e7b2539430545', 'นางสาว', 'วิภาดา', 'ติปัญโย', NULL, 'wipada0964@gmail.com', NULL, '0947011367', NULL, '17 หมู่ 9 ตำบลบ้านเวียง อำเภอร้องกวาง จังหวัดแพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1590, '63301280026', '63982e54a7aeb0d89910475ba6dbd3ca6dd4e5a1', 'นาย', 'นันทวัฒน์', 'กุศลส่ง', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1593, '64201280001', '355f2c76dd75321f90abe9f21d9729a29134f27b', 'นาย', 'สุทิวัส', 'ยานะวิน', NULL, ' aun.suthiwas@gmail.com', NULL, '0985025376', NULL, '80 หมู่1 ต.แม่ทราย อ.ร้องกวาง จ.แพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1594, '64201280002', '39fd7c8471bf23a696dce67a324e75fb82bd2297', 'นางสาว', 'สัจจพร', 'อินธนู', NULL, 'satchaporn4082@gmail.com', NULL, '0655721922', NULL, '116 ม.2 ต.บ้านปง อ.สูงเม่น จ.แพร่ ', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1595, '64201280003', 'feda249b70ea5ad804a663d3ab3393851dd892f9', 'นางสาว', 'ธัญลักษณ์', 'ลำใย', NULL, 'aink24474@gmail.com', NULL, '0947141457', NULL, '182/3หมู่6 ต.บ้านปง อ.สูงเม่น', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1596, '64201280004', 'deff79b0c9d7e02b7aa362ca7f88bf0e2c3475d7', 'นาย', 'ชนกันต์', 'เย็นใจ', NULL, 'nichapatyenjai35@gmail.com', NULL, '0654538919', NULL, '84 หมู่ 6 ต.ทุ่งกวาว อ.เมือง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1597, '64201280005', '1a9285584ec80cbcbc4b69b4d381a6a838b4edbd', 'นาย', 'สรรพวัต', 'กลั่นสกุล', NULL, 'nongkong.k123@gmail.com​', NULL, '0944460359', NULL, '197 ม.12 ต.หัวฝาย อ.สูงเม่น จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1598, '64201280006', '3bb0d24b74d42f8f899775612798129c0410f1d3', 'นาย', 'อนันต์ตุลา', 'ม้าวิ่ง', NULL, 'anantoola35@gmail.com', NULL, '0979300817', NULL, 'บ้านเลขที่31 หมู่2 ต.ห้วยม้า อ.เมือง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, 'IMG_0236.jpeg'),
(1599, '64201280007', '21e122bb03f879c5e7ede6cdb4061322ba132300', 'นาย', 'ปิยะพันธ์', 'เวียงโอสถ', NULL, '', NULL, '0992728337', NULL, '309/3 ม.10 ต.เเม่จั๊วะ อ.เด่นชัย จ.เเพร่', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1600, '64201280008', '709fd779d7cfe5971eb3a6049dfc82615df4f428', 'นาย', 'พงศภร', 'สมสิน', NULL, 'maizananuto@gmail.com', NULL, '0802575189', NULL, '60 ม.4 ต.แม่จั๊วะ อ.เด่นชัย จ.แพร่', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, 'unnamed-removebg-preview.png'),
(1601, '64201280009', '9073056a305a8c1250342d2f6cce3123806b41b2', 'นาย', 'ปุณญวัฒน์', 'เชียงน้อย', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1602, '64201280010', '81d66db33f217524d481fdc0debaa9df00eaa344', 'นางสาว', 'วิศินี', 'สุทธิพราหมณ์', NULL, 'visineesuttipram@gmail.com', NULL, '0926648250', NULL, '192/1 หมู่1 ต.ร่องฟอง อ.เมือง จ.แพร่ 54000', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1603, '64201280011', '02da4a5fb856e9023c7d462a1595e6a9cc3966a0', 'นาย', 'คุณานนต์', 'ศรชัย', NULL, 'sornchaikunanon@gmail.com', NULL, '0830044784', NULL, '5/1 หมู่10 ตำบลสูงเม่น อำเภอสูงเม่น จังหวัดแพร่ ', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1604, '64201280012', 'ad0d7455f45038b36fb56d542021babf824f2dfd', 'นาย', 'พิชิตชัย', 'มุกเพ็ชร์', NULL, 'bballkkung@gmail.com', NULL, '0612868351', NULL, '134 หมู่ 5 ตำบล วังหงษ์ อำเภอ เมือง จังหวัด แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, '1000000277.jpg'),
(1605, '64201280013', 'e57fa67ea5ecbc0b164538c589a137998a58f0f7', 'นาย', 'ภูริพัฒน์', 'เผ่าศรี', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1606, '64201280014', 'bd9e3ff74f20cd839e6da3aa8d2efbcc7b33a6be', 'นางสาว', 'ชญานิษฐ์ ', 'สุริยะสุข', NULL, 'chayanit6770@gmail.com', NULL, '0654166770', NULL, '57/3 ม.5 ต.ทุ่งแล้ง อ.ลอง', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1607, '64201280015', '3b1cf9312803f5b35b27daa533d3c35f30c107d8', 'นางสาว', 'กนกภรณ์', 'ริพล', NULL, 'thay29177@gmail.com', NULL, '0972312194', NULL, '36หมู่4 ต.เเม่ทราย อ.ร้องกวาง จ.เเพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1608, '64201280016', '0dcd7a90aaa5ea07c6b2510b65704338cbcafed9', 'นาย', 'ฉัตตภูมิ', 'เอี่ยมสอาด', NULL, 'tigernine919@gmail.com', NULL, '0914757113', NULL, '158/22 ถ.ยันตรกิจโกศล\nต.ในเวียง อ.เมือง จ.เเพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1609, '64201280017', 'ce01f8553918960a4871cf6124b72617c60e01bb', 'นาย', 'ณัฐกิตติ์', 'เวียงเจ็ด', NULL, 'natthakitwiangjet6035@gmail.com', NULL, '0840416035', NULL, 'บ้านเลขที่51 หมู่4 ตำบลช่อเเฮ อำเภอเมืองเเพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1610, '64201280018', '8b871576b52b281e3692cac4df9d226ec5fcce63', 'นาย', 'ธนกฤต', 'วงศ์ศักดิ์สิทธิ์', NULL, 'tanakrit1747@gmail.com', NULL, '0636588146', NULL, '194 หมู่7 ต.หัวฝาย อ.สูงเม่น', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1611, '64201280019', '804914acd2623df56f148f972f6fd921f41558a6', 'นาย', 'วัชรพล', 'อุ่นใจน้ำ', NULL, 'artth1693@gmail.com', NULL, '0864342554', NULL, '40/5 ตำบล.บ้านปง อำเภอ.สูงเม่น จังหวัด.เเพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1612, '64201280020', 'ecd13b200ccb5d55aae4d8bb0c38fc701ae7ac32', 'นาย', 'ศรนเรศ', 'มีชัยเจริญ', NULL, 'jnunon10@gmail.com', NULL, '0830038347', NULL, '', NULL, 175, '', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1613, '64201280021', 'a6d0d40a19fc406be967c6b5012863c00ce0db83', 'นาย', 'ธีระศักดิ์', 'ทองอุราฬ', NULL, 'Po9598329@gmail.com ', NULL, '0656813922', NULL, 'อ.เด่นชัย ต.แม่จั๊ะ 80/2 หมูที่2', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1614, '64201280022', '664289b8bf1590a692e1cb420d49cbf65f449477', 'นาย', 'ธัญวิชญ์', 'พหุสัจจธรรม', NULL, 'tent6052544@gmail.com', NULL, '0960234366', NULL, 'บ้านเลขที่ 29/6 บ้านปทุม หมู่11 ต.เหมืองหม้อ อ.เมือง จ.เเพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1615, '64201280023', '8a89980d53b6473bd255e2a5703fc7d5b1d1b427', 'นาย', 'กฤศ', 'ศศิวงศากุล​', NULL, 'mraccrag0@gmail.com', NULL, '0979404551', NULL, 'เหมืองหม้อ หมู่3 บ้านเลขที่40 อำเภอเมือง จังหวัดแพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, '345119911_1423530654855640_8499290628838026708_n.jpg'),
(1616, '64201280024', 'a6bdee323a9e7dd28aa4a61015653490787ee153', 'นาย', 'กฤษฎากร', 'แก้วพรม', NULL, 'pichayakarn45@gmail.com', NULL, '0979309677', NULL, '74/5 บ้านร่องกาศ หมู่11 อำเภอสูงเม่น จังหวัดแพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1617, '64201280025', '974525f9132870b7487146363af7c127a72e9cbc', 'นางสาว', 'เอกธิดา', 'เถระ', NULL, 'aektihda12345678@gmail.com', NULL, '0820192221', NULL, '83/2ม.4ต.แม่ทราย อ.ร้องกวาง จ.แพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1618, '64201280026', 'c333621c6e638e47ff7936e0dd5c7654b5bb3371', 'นาย', 'วิวรรธน์', 'นาพรม', NULL, '0933055414j093@gmail.com', NULL, '0933055414', NULL, '72หมู่7 ต.นํ้าเลา อ.ร่องกวาง จ.แพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1619, '64201280027', 'b92a315560922237b789604a65db1636fc443f8c', 'นาย', 'ศิวัฒน์', 'กล่อมปาน', NULL, 'sklomparn@gmail.com', NULL, '0932748770', NULL, 'ม.7 ต.น้ำเลา อ.ร้องกวาง จ.แพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1620, '64201280028', '0c844856aae6d74fae27208ec807428921c8163a', 'นาย', 'ธีรวัสส์', 'นาคะสิทธิ์', NULL, 'darkend.darknes1@gmail.com', NULL, '0984463504', NULL, '145 หมู่5 ต.พระหลวง อ.สูงเม่น จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1621, '64201280029', '9dd6b03c4d625288d61a31f2edd755c336fc5ca0', 'นาย', 'ปรัชญา', 'ผาทอง', NULL, 'patchayaphathong@gmail.com', NULL, '0645366828', NULL, '179/18 ม.4 ต.ทุ่งกวาว อ.เมือง จ.แพร่ ', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1622, '64201280030', 'a03482b8b2de17d9db1c0f650051b6eba6421782', 'นาย', 'กีรติ', 'นิ่มบุญ', NULL, '', NULL, '', NULL, '', NULL, 175, '', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1623, '64201280031', 'c846e373f7288c2ce822d7db3a32246074b800bd', 'นาย', 'วุฒิกร', 'จีกัน', NULL, 'tarza521za@gmail.com', NULL, '0961900060', NULL, '167 ม.1 ต.บ้านกวาง อ.สูงเม่น จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1624, '64201280032', 'e4fb93ef588c86ad9c842f0e405de52b241f1183', 'นาย', 'พิชชากร', 'อินทเจริญศานต์', NULL, 'nekomaasan@gmail.com', NULL, '0956988847', NULL, 'อ.ร้องกวาง ต.น้ำเลา หมู่ 3 บ้าน 173', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1625, '64201280033', '7b57b7a6cea1dd20f798bd3c909e7e7211206eb3', 'นาย', 'ศุภวิชญ์', 'เครือไทย', NULL, 'gearhero08@gmail.com', NULL, '0808594770', NULL, '29 ม2 ต.ตำหนักธรรม อ.หนองม่วงไข่ จ.แพร่', NULL, 175, '54170', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1626, '64201280034', '1488faafcca179138ed401b861bb4b8bde5198df', 'นาย', 'กนกพล', 'ปัญญาธรรม', NULL, 'payyathrrmknkphl01@gmail.com', NULL, '0643510691', NULL, '4/2 หมู่ 5 ต.เหมืองหม้อ อ.เมืองแพร่ จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1627, '64201280035', 'f573503ef6d5d37e0b096d5cbb2a261a4c108b65', 'นาย', 'วรรธนะ', 'ประดับเชื้อ', NULL, 'FaLordKung@gmail.com', NULL, '0947518533', NULL, '50/1 หมู่4 ต.นาจักร\nอ.เมือง จ.เเพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1628, '64201280036', 'c80d2a54408e0be4913bb3d524bee3a98c4144b4', 'นาย', 'วิรุฬห์', 'กาศสกุล', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1629, '64201280037', '1295bff0922a32f0e58ffd400457df878483c0cc', 'นาย', 'ณัฏฐกิตติ์', 'สร้อยวังวรณ์', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, '297018807_840341560707093_1462014247054991627_n.jpg'),
(1630, '64201280038', 'ce951b979242dea4c1f40eb4a76dd330e5103268', 'นาย', 'ณัฐภูมิ', 'นิลุบล', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1631, '64201280039', 'cff8bb60ae70dbd9ed58475176b3006b6c79e125', 'นาย', 'คฑาวุธ', 'สุนันทา', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1632, '64201280040', '5fd060c03afe1c8107a914d7c7350c8daad83c05', 'นาย', 'สุรโชค', 'วังคำ', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1633, '64201280041', '0b8ff958f94519d99e94097ac4aac7462f81c47b', 'นาย', 'ศุภวิชญ์', 'มังกร', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1634, '64201280042', '7592c06aef5d3ab12c070eddf01fc62330466fb5', 'นางสาว', 'เกศินี', 'เขื่อนคำ', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1635, '64201280043', '17b56775416ec7c22703c7ab7aa8819c90255cd7', 'นาย', 'ลาภิศวสุ', 'ชัยสาร', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1636, '64201280044', '37587e6cb3e091f023f8ae2852a8ed68960644e5', 'นาย', 'มงคล', 'ปิ่นแก้ว', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1637, '64201280045', '1a67db16420f230d6e0635bc78f22a172ea09660', 'นาย', 'ธนดล', 'แก้วกล้า', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1638, '64201280046', '8de2b203038e06e0ca4bbb4486a749bd60c29d3b', 'นาย', 'เดชสิทธิ์', 'เดชกุญชร', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1639, '64201280047', '72d8d059edb2a1ab571d240d692c150c5632a6d7', 'นาย', 'ศิวกร', 'อุดมพงศธร', NULL, '', NULL, '0618745359', NULL, '135/5 หมู่ 2 ถนนราษฎร์อุทิศ ซอย 4 ตำบลทุ่งกวาว อำเภอเมือง', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1640, '64201280048', '71e8f7b59b1948c46475fcb2c8b24c10c2120459', 'นาย', 'ณัฐนันท์', 'วงค์ฉายา', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1641, '64201280049', '2d33bed953401f90820ee97934c3c72268aa6bff', 'นาย', 'ณวรัฎ', 'วงค์ฉายา', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1642, '64201280050', '5b051028e586cabe07366c3eb29a0193a2202230', 'นาย', 'พิชานันท์', 'ศรีรัตนะพัฒน์', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1643, '64201280051', '251905b294359c207e9190217ba828bbdcbca380', 'นาย', 'อธิภัทร', 'ตันติพิสิฐกุล', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1644, '64201280052', 'c0c96c39139d5897d9d83ce37355093e14376208', 'นางสาว', 'พัชราภา', 'กุณะสี', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1645, '64201280053', '184b3ef7e32158842c428033c3c2011add86f71b', 'นางสาว', 'พิจิตรตรา', 'กันทะวะ', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1646, '64201280071', '8ddff4db595deea32e5987cecb7658f8ad2817f7', 'นาย', 'ธนกฤต', 'แสนกือ', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1647, '64201280054', '3fcbad73270be7a7a484e4f35ac0f2f18ac16475', 'นาย', 'อภิชาติ', 'สุสินทร์', NULL, 'apichat065375@gmail.com', NULL, '0926080618', NULL, '142 ห.8 อ.ลอง จ.แพร่ ต.บ้านใหม่ศรีล้อม', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1648, '64201280055', '2d47436625a76b11e5eca1b94e55e2aa98d5f725', 'นาย', 'ชนาธิศ', 'ชื่นประดิษฐ์', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1649, '64201280056', '136dc212223cc2e2353de245f2cf737bd2d77c56', 'นาย', 'อนุวัฒน์', 'ท่วงที', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1653, '64201280060', '0ec39ec75c18ec2c21037f0f778744ed74783bf3', 'นาย', 'พีรพัฒน์', 'พุ่มพวง', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1654, '64201280061', 'f03ae45a73ed3b3a5a72dc59b9e34857da220f8a', 'นาย', 'บารมี', 'อุดกันทา', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1655, '64201280062', 'be9ff5af031f0527d76b1225e2dadb2c77f62d3a', 'นางสาว', 'จุฑามาศ', 'มหาชัยสกุล', NULL, 'Jutamas08042548@gmail.com', NULL, '0659491554', NULL, '108 หมู่11 บ้านปางเคาะ\nต.ไทรย้อย อ.เด่นชัย ', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1656, '64201280063', '74517800647c9073c12f9268b65a24b51c176e92', 'นาย', 'ภูมิพัฒน์', 'จันชุ่ม', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1657, '64201280064', '2c58366249f097839cbd39ce9caf1e31e6da295f', 'นาย', 'บุญญาฤทธิ์', 'จินะกาล', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1658, '64201280065', '2910e2c1afae6a3bd34ee5ebaa399ba94337af76', 'นาย', 'จุฑาภัทร', 'ปินชัย', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1659, '64201280066', 'd5fb7e1cad89036eb362118ac4f58646605eedf6', 'นางสาว', 'ขวัญจิรา', 'บัวรอด', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1660, '64201280067', '16814d25d8fbdfcd915983dc51470588607993f5', 'นาย', 'ปวรปรัชญ์', 'กอบกำ', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1661, '64201280068', '9d1dfff8207c942489806c6733a08cc6c848a01b', 'นางสาว', 'ชิดชนก', 'สุวรรณหงษ์', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1662, '64201280069', '89d1c29e258aedc8df4b1df7066a1aa62f42d141', 'นาย', 'ปัณณวิชญ์', 'ดอกแสง', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1663, '64201280070', '1b23f58147b1e8e3b20edda2547f259e092bd6ef', 'นาย', 'ราชพฤกษ์', 'คำเขียว', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1664, '64201280072', 'd1c4d780bdfb848061b8460e4b66509e5a203eba', 'นาย', 'ภาคิน', 'ศรีเหรา', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1665, '64201280073', 'e9f04131aa4e05feff7c87b32a057276a0b42f11', 'นางสาว', 'กชกร', 'สุขยิ่ง', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1666, '64301280001', 'f19028f6695a56510020454e3179ed6ede4b0449', 'นาย', 'นราธิป', 'ทาคำ', NULL, 'narathip2002@outlook.co.th', NULL, '0924617473', NULL, '169 หมู่ 1 ต.นาพูน อ.วังชิ้น จ.แพร่', NULL, 175, '54160', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1667, '64301280002', 'de8f94a7e07cd6d275576827a34f76b2367a687f', 'นาย', 'พลพัต', 'ทรวงหิรัญ', NULL, 'getseedza@gmail.com', NULL, '0656781986', NULL, '52/1 หมู่ 1 ต.ทุ่งกวาว อ.เมืองแพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1668, '64301280003', '7238394a9504108917284fe994a343a53681258c', 'นาย', 'ชยางกูร', 'อุรัจฉทาภรณ์', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1669, '64301280004', 'f9a3f607b425b63a7604f904019efcdfcda0ab86', 'นาย', 'วิทวัส', 'ภิระบรรณ์', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1670, '64301280005', 'bdffc6c640e7201fe415375b1aa4c4c4d1941df7', 'นาย', 'อนุรัตน์', 'สมใจ', NULL, 'penpieapple014@gmail.com', NULL, '0957753259', NULL, '195/1 หมู่ 5 ต.วังหงส์ อ.เมือง จ.แพร่ ', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1671, '64301280006', '1d824110c08862a591037e760dec4a6e0f17bb75', 'นาย', 'ภัทรดนัย', 'วงค์ศิริ', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1672, '64301280007', '51e9c01aa792d04859445a3b2a41d1942ab591b0', 'นาย', 'เทวัญ', 'จะเฮิง', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1673, '64301280008', '7989fb2569fcdc2d57b7a7ce7301319b75333faf', 'นาย', 'สุรพัศ', 'สุภาพ', NULL, 'tgmt4445@gmail.com', NULL, '0981865209', NULL, '64/1 หมู่.3 ต.ร่องกาศ อ.สูงเม่น ', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1674, '64301280009', '3f4841302a33f2a58663fee162cdf127291f8b99', 'นาย', 'ธนพล', 'ผายาว', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1675, '64301280010', 'cf81fe198348e5c8d7f90618328acbd2dba83cee', 'นาย', 'ศุภกิตติ์', 'กุกอง', NULL, 'firsthonlol@gmail.com', NULL, '0902389025', NULL, '123 หมู่4 ต.บ้านปง อ.สูงเม่น จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1676, '64301280011', 'b37e7f28fde3cdfac8159512b2a3db1a75c5e9ee', 'นาย', 'โยธิน', 'มั่งคั่ง', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1677, '64301280012', 'e51dc4f1b6d9e56ef57dc1cb9ad144ba28ab9693', 'นาย', 'พัสกร', 'บทศรี', NULL, 'tros2545@hotmail.com', NULL, '0828944088', NULL, '', NULL, 175, '', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1678, '64301280013', '37357d653c8a666a252a0cd2bd894cbd575e78bd', 'นาย', 'ณภสกร', 'สุขนิธิ', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1679, '64301280014', '30ba7fff0535b0f88365f8baa57feb6ff7c671bb', 'นาย', 'นันทิพัฒน์', 'สมบัติวงศ์', NULL, 'lebeno211059@gmail.com', NULL, '0991260098', NULL, 'บ้านเลขที่ 99 หมู่ที่ 3 ต.นาจักร อ.เมืองแพร่ จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1680, '64301280015', '5413856cf80ab3501a2d00ddf175f1ba59d75c97', 'นางสาว', 'ชญานิศ', 'ประเทศ', NULL, 'chayanad5121@gmail.com', NULL, '0971655792', NULL, '111/8ม.8ต.ไทรย้อย อ.เด่นชัย จ.แพร่', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1681, '64301280016', '9158dd1c6ea2d2c701f300091b5461e7425d5ba4', 'นาย', 'จีรัชญ์ ', 'เอี่ยมวิจารณ์', NULL, 'phoochirat@gmail.com', NULL, '0806733083', NULL, '166/102 ถ.ยันตรกิจโกศล\nต.ในเวียง อ.เมือง จ.แพร่\n', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1682, '64301280017', 'd2b0f0686c6de7e3787766e4eec9dae0df82daf1', 'นาย', 'ณัฐวุฒิ', 'ภูจีวร', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1683, '64301280018', '11e053a5f65f5b2bebcab6079f0458b3058ffd55', 'นาย', 'นนทวัฒน์', 'คันที', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1684, '64301280019', '4dbe93b2e5b4aad0d7aec641f30e3077931b5aa3', 'นาย', 'จิรภัทร', 'วงค์มณี', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1685, '64301280020', 'b8055c355d5950aba235eb89da35dfcc4c731f61', 'นาย', 'กิตติพงศ์', 'ยะทะนะ', NULL, 'kittipong15072545@gmail.com', NULL, '0648697365', NULL, '139 หมู่ 15 ต.ห้วยหม้าย อ.สอง จ.แพร่', NULL, 175, '54120', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1686, '64301280021', 'd4e9349b70b163847f913101f79134831d41ff0a', 'นางสาว', 'พอฤทัย', 'ชมภูมิ่ง', NULL, 'rummapoppychannel@gmail.com', NULL, '0611169369', NULL, '23/2 ถ.ราษฎร์ดำเนิน\nต.ในเวียง', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1687, '64301280022', 'd1931a76b75d4bc3aba2016f75bb89215b4c54c1', 'นาย', 'จิรภัทร', 'ทนุโวหาร', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1688, '64301280023', 'c901a4f66bbe20652a370a9cf9e182b36eebd684', 'นาย', 'จักรกฤษ', 'ชุมเเสน', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1689, '64301280024', 'b4eb083faeb1e1231ee1bd2279653fb09e572a3b', 'นาย', 'เจษฎา', 'แสนสุภา', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1690, '64301280025', '40a972903563465a86628f5348cc2ff14ea803ee', 'นาย', 'ณัฐนันท์', 'หอมจันทร์', NULL, '', NULL, '0997562394', NULL, '545/21ม.9ต.เด่นชัยอ.เด่นชัย', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1691, '64301280026', '7ddc0a10a9021774447bb0b05139ef9b5f875a3e', 'นาย', 'ไชยวุฒิ', 'ธิฟู', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1692, '64301280027', '161a32be2a9fecf2e6edcb05e2f48edd6151191b', 'นาย', 'ศรศิลป์', 'อินทรรุจิกุล', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, '');
INSERT INTO `tb_member` (`member_id`, `member_code`, `member_password`, `member_title`, `member_firstname`, `member_lastname`, `member_gender`, `member_email`, `member_tel`, `member_mobile`, `member_fax`, `member_address`, `member_district`, `province_id`, `member_zipcode`, `member_registerdate`, `member_company`, `member_company_no`, `member_level`, `member_approve`, `member_last_login`, `member_note`, `member_line_token`, `member_line_token2`, `member_line_token3`, `member_line_token4`, `member_line_token5`, `member_type`, `student_id`, `member_img`) VALUES
(1693, '64301280028', '4a75b2f0972aba4a4ed58e4857a1f6fdcc46c436', 'นาย', 'ภูวดล', 'จันทร์ใจ', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1694, '64301280029', '4ec0c7a7efa0a7e94ba79acfc5aeb52b701a6223', 'นาย', 'กฤตภัค', 'ตั้งตระกูลรัตนกร', NULL, '	krittapak1112@gmail.com', NULL, '+66969259192', NULL, '92/2 ม.5 ต.แม่จั๊วะ อ.เด่นชัย จ.แพร่', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1695, '64301280030', '083e9222dd6a9037562f5a9aee150e8508e95d51', 'นาย', 'นนทวัฒน์', 'จันทร์สุข', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1696, '64301280031', 'd78c0cb5d4ac50ce387184e6c575b741b2f92591', 'นาย', 'วีรภัทร', 'ฉัตรสงวนชัย', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1697, '64301280032', '75cfbf4231668ef8a74d2953cb840f3d8b5d7ab3', 'นาย', 'จิรวัฒน์', 'ขุนเงิน', NULL, 'zajirawat@gmail.com', NULL, '0944273658', NULL, '143ม.13 ต.หัวฝาย อ.สูงเม่น จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1698, '64301280033', '09d41a6c77bc19e29e0b8cce1fa4d2392b5a6e17', 'นาย', 'อรรคพัทธ์', 'คำปินตา', NULL, 'flam888flam@gmail.com', NULL, '0931476898', NULL, '52 หมู่3 ต.บ้านเวียง อ.ร้องกวาง จ.แพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1699, '64301280034', '38c2a2c2b3ae3783d02df8b946625b84b8dc1d89', 'นาย', 'ปกรณ์', 'ภู่ปรางค์', NULL, 'pon116710@gmail.com', NULL, '0652299910', NULL, '152หมู่4 ต.เตาปูน อ.สอง\nจ.แพร่', NULL, 175, '54120', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1700, '64301280035', '52f6b7e3ef59c55336fb90505274655febd79ab8', 'นาย', 'รัชชานนท์', 'บุญมาภิ', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1701, '64301280036', '874e64c98332e1b271e3545e650e20d2be44fba4', 'นางสาว', 'จุฬาลักษณ์', 'แสนขัด', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1702, '64301280100', '4c73491ded29c9667b72fe131508238d25e2579a', 'นาย', 'ณพพงศ์', 'ราชไร่', NULL, 'nopphong9788@gmail.com', NULL, '0930705242', NULL, '81/1 ม.5 ต.สวนเขื่อน อ.เมือง จ.เเพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1703, '64301280101', '31f11a9cbda33cfbd52fa10c4a1d9358f0780079', 'นาย', 'วสุทธา', 'วรรณวงค์กา', NULL, 'Monkeyxcoolertv@gmail.com', NULL, '0649091857', NULL, '3ม.6 ต.น้ำเลา อ.ร้องกวาง ', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1704, '64301280102', '9247bcaa00f055ab869a1c9c2f8ea915fa86bc0f', 'นาย', 'ณฐกฤษ', 'วงค์ตะวัน', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1705, '64301280103', '3e21d49ac4208d68ab008fba146846c3b7877dba', 'นาย', 'ศตวรรษ์', 'สมหมาย', NULL, 'sattawatsommai@gmail.com', NULL, '0623934440', NULL, '16/3 บ้านนาพูน หมู่ 2 ต.นาพูน อ.วังชิ้น', NULL, 175, '545160', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1706, '64301280104', 'fe66fe2ecab11b83923acef47c045b5828692df1', 'นาย', 'ชิตพล', 'ม่วงหวาน', NULL, 'tntmool001@gmail.com', NULL, '0984900477', NULL, '53/1 หมู่7 ต.บ้านกาศ อ.สูงเม่น จ.แพร่', NULL, 175, '54123', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1707, '64301280105', 'd52a627b74cdac3aa689e9c4b831bf901f51561c', 'นาย', 'จรรยวรรธ', 'ธรรมปัณณ์พงษ์', NULL, 'rithakorn123@gmail.com', NULL, '0654766310', NULL, '110/1 ต.ดอนมูล อ.สูงเม่น จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1708, '64301280106', 'c87b38076833b85b1b969d203c655adf68cb6482', 'นาย', 'ปิยะราช', 'เมษา', NULL, 'nonasdnon3@gmail.com', NULL, '0994645019', NULL, 'บ้านเลขที่72/1 หมู่4 ตำบบล.ห้วยม้า อำเภอ.เมือง จังหวัด.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1709, '64301280107', '6d010d538d172a55e4a403c7b9ee41c2f1a7db27', 'นาย', 'เจตภานุ', 'กินร', NULL, NULL, NULL, '0622614701', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1710, '64301280108', 'd10b042e6a4310ae1a2a658fdc38ea6675951173', 'นางสาว', 'สุดารัตน์', 'ป่งคำ', NULL, 'sudaratpongkham163@gmail.com', NULL, '0628949560 ', NULL, '56 หมู่1 บ้านวังเย็น ต.ห้วยม้า อ.เมือง', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1711, '64301280109', 'dd75beadf60dbe3cc5d1e48234708b9c83b138d9', 'นาย', 'ชนาธิป', 'อนุบุตร', NULL, NULL, NULL, '0840548474', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1712, '64301280110', '2863b81486bc38b21c8f8e6bd622a7b4a4d3982f', 'นาย', 'ทศพร ', 'โนจิตร', NULL, '', NULL, '0987972750', NULL, '120 ม.5 ต.บ้านเวียงอ.ร้องกวาง จ.แพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1713, '64301280111', 'eb5986ddaf129b9b0f7bcf6636d8b1a28b8e15ce', 'นางสาว', 'โกลัญญา', 'เรือนคำ', NULL, 'kolanyaruankham093@gmail.com', NULL, '0835079985', NULL, '59 หมู่1 ต.ร่องกาศ อ.สูงเม่น จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1715, '64301280112', '769518957112fd17ab4e8d784db10a46be560daf', 'นางสาว', 'อรุณวัชรี', 'พิริยานุรักษ์', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1716, '64301280113', 'f82f19e81c56593dd1d24e190af2ae7567e137df', 'นาย', 'กิตติธัช', 'ทองขาว', NULL, 'anpantougkau@gmail.com', NULL, '0971196806', NULL, '128/4 หมู่9 ต.เวียงทอง อ.สูงเม่น ', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1717, '64301280114', 'c1d9f688c11e2d64cb85b7a87e22f167a31d4716', 'นาย', 'ศราวุฒิ', 'จันทองใส', NULL, 'sarawutzaza7070@gmail.com', NULL, '0943239581', NULL, '40/1 หมู่1 ต.เวียงทอง อำเภอสูงเม่น จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1718, '64301280115', '2c651a004d2f32094ff2c3827af041807651dc84', 'นาย', 'ประสิทธิ์ศักดิ์', 'กระจ่างแก้ว', NULL, 'zombizz1111@gmail.com', NULL, '0968030356', NULL, '94 หมู่3 ต.ช่อแฮ อ.เมือง ', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1719, '64301280116', 'd62f52d346ca720b8e9169ffa8792ed6aaaed915', 'นาย', 'กฤษฎา', 'จงปัตนา', NULL, 'kitsada.gg@gmail.com', NULL, '0807345391', NULL, '546 ม.7 ต.เด่นชัย อ.เด่นชัย', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1720, '64301280117', '9a47fb65cdfb4e1da643249cd4bba279e3a6a62f', 'นางสาว', 'เมธาวี', 'ศักดิ์สิทธ์', NULL, 'trimondspin@gmail.com', NULL, '0612586974', NULL, '91/1 ม.1 ต.พระหลวง อ.สูงเม่น จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1721, '64301280118', 'ba7b379574e59709f217b37772daee4ee7b75a6e', 'นาย', 'กิตติชัย', 'อินจินดา', NULL, 'kittichai17102543@gmail.com', NULL, '0625049311', NULL, '131 ม.4ต.แม่ปาน อ.ลองจ.แพร่ 54150', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1722, 'thawatchai', '90b9aa7e25f80cf4f64e990b78a9fc5ebd6cecad', 'ว่าที่ ร.ต.', 'ธวัชชัย', 'สุเขื่อน', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '79xsB8CHLz4hqov2oe6lwVk116vTk4hPIv4Mz8zW39F', 'p4C0PUVTEIKRBQ2tDfmekOU7cLHQQeLNvX0JSrO6kui', '-', '-', '-', 'teacher', 0, ''),
(1752, '64201280075', '67a74306b06d0c01624fe0d0249a570f4d093747', 'นาย', 'กิตติวิน', 'ภูบริบูลย์', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1753, '64201280074', '8960d679435e98f9df31d6afc5d181d51f3e60b4', 'นาย', 'จารุเดช', 'สีทองใส', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2026, '66201280069', '9fac1b25fc0489a09c24a9cc5429b41c5872e607', 'นาย', 'ณิชนันทน์', 'แสนโซ้ง', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1760, '64301280119', '67a74306b06d0c01624fe0d0249a570f4d093747', 'นางสาว', 'อาทิติยา', 'แสนมงคล', NULL, NULL, NULL, '0838272020', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1771, '65201280002', 'e5b99b19ef0b95fc1388c5e85d67cdf007518145', 'นาย', 'วรัญชัย', 'วิใจคำ', NULL, 'waranchaiwijaikum2549@gmail.com', NULL, '0863750094', NULL, '210 หมู่ที่1 ตำบลทุ่งโฮ้ง อำเภอเมืองแพร่ จังหวัดแพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, 'officer_img4.png'),
(1772, '65201280003', 'fbeda842117dcb7361c835c3c46ed90ca3a40b25', 'นางสาว', 'อักษราภัค', 'เปียงใจ', NULL, 'ibeargod54@gmail.com', NULL, '0924159175', NULL, '106/2 ม.5 ต.ช่อแฮ อ.เมือง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1770, '65201280001', '8c6dd839a1a2cd8e6e5a988c1cad6f3d77e879d6', 'นาย', 'ภัควัฒน์', 'กาบจันทร์', NULL, 'pakhwawt.07@gmail.com', NULL, '0923459468', NULL, '101/7 ตำบล บ้านปง อำเภอ สูงเม่น จังหวัด แพร่', NULL, 175, '54139', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, 'logo_computer.png'),
(1773, '65201280004', '6b039e797e426b0d90b0c8b42e9543081b75f5d3', 'นาย', 'ธนโชติ', 'วังแก้ว', NULL, 'fnball56964@gmail.com', NULL, '0629072988', NULL, '69/8 หมู่6 บ้าน.เหมืองค่า ตำบล.เหมืองหม้อ อ.เมือง จ.เเพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1774, '65201280005', 'f6fc679e98d22eacc536c9ee4e466b9fb1541b35', 'นางสาว', 'ปรียารัตน์', 'หมื่นคำตุ้ย', NULL, 'Priyaratt.muenkhamtui@gmail.com', NULL, '0612249116', NULL, '195 ม.10 ต.นาพูน อ.วังชิ้น \n', NULL, 175, '54160', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1775, '65201280006', '0023c59e71b14afb9d7f0e4a05b442ad6846a8e3', 'นาย', 'ณัฐสิทธิ์', 'มั่งมูล', NULL, 'ceonattoch@gmail.com', NULL, '0927240350', NULL, 'บ้านเลขที่ 112/1 หมู่5 ตำบลบ้านปงท่าข้าม ', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1776, '65201280007', 'aac8c0e4d65883de3714ccab50a8996e65b81c04', 'นางสาว', 'ญาดา', 'รักษาพล', NULL, 'yadalaksapol@gmail.com', NULL, '0956755082', NULL, '36/1 หมู่4 ต.ป่าแมต อ.เมือง\nจ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1777, '65201280008', '6737d8e19c27259fabdd24cd10e521c61db63fdf', 'นาย', 'พิพัฒน์', 'นิ่มบุญ', NULL, 'Piphat.nwe@gmail.com', NULL, '0645033224', NULL, '127/2 หมู่ 9 ต.ป่าเเมต อ.เมือง จ.เเพร่ ', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1778, '65201280009', '1510b01717cfad9415c31555696bc9e045428cbc', 'นางสาว', 'ศศิภา', 'วงค์รอบ', NULL, 'sasipa16064900@gmail.com', NULL, '0930379712', NULL, 'ต.ปงป่าหวาย อ.เด่นชัย ', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1779, '65201280010', '0f392bedf74b02447529e02ff18f619a708ee835', 'นาย', 'ธีรวัฒน์', 'มินารินทร์', NULL, 'nack1506za@gmail.com', NULL, '0886984760', NULL, '144/2 หมู่ 5 ต.แม่ยางตาล \nอ.ร้องกวาง จ.แพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1780, '65201280011', 'ab7ab5e4dda370fdb5cae1afa30bbf16e226fd6f', 'นาย', 'อชิระ', 'อนันทสุข', NULL, 'ashira.qq@gmail.com', NULL, '0912486951', NULL, '223 ตำบลสูงเม่น อำเภอ สูงเม่น จังหวัด แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1781, '65201280012', '89a5359a266ca282bf6a990cec28ccc791a03fcb', 'นาย', 'ธัญยบูรณ์', 'ไฝทอง', NULL, 'peeawer123@gnailbcom', NULL, '0643091152', NULL, '106/1 หมู่1 หมู่บ้าน ดอนดี ตำบล กาญจนา อำเภอ เมือง ', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1782, '65201280013', '19782387284f06876214f4a286ec20da36236a3a', 'นาย', 'กฤษฎากร', 'ศรีโพธิ์', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1783, '65201280014', 'a46a3b8b43560ad9046f8a8921f1ddf37707417b', 'นางสาว', 'ศรัญญา', 'สมวรรณ์', NULL, 'yoksomwan01@gmail.com', NULL, '0637309285', NULL, '136 ม.3 ต.บ้านกาศ อำเภอสูงเม่น ', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1784, '65201280015', '15cadf482b487a43c6317d553ce7db41e10beeff', 'นาย', 'กฤตภัค', 'เเสนสุภา', NULL, 'Baszaas007@gmail.com', NULL, '0613522478', NULL, '51 ม.7 ต.เเม่คำมี อ.เมือง จ.เเพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1785, '65201280016', '0bf15df3d39f81a3484de6801915dba9eb062a64', 'นางสาว', 'พรนภา', 'มีจุ้ย', NULL, '', NULL, '0927103661', NULL, '', NULL, 175, '', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1786, '65201280017', '8608e42eec46427d4c76f7ae1526a2b57a2be130', 'นาย', 'กุลวัฒน์', 'วัฒนพร', NULL, 'Kunlawatwattanapron@gmail.com', NULL, '0616379166', NULL, '99 หมู่ 10 ต.เหมืองหม้อ .เมือง จ.แพร่ ถ.ช่อแฮ', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1787, '65201280018', 'e51f3726f034136725618aa70b6a2fda886f4c9d', 'นาย', 'อรรถกร', 'พงษ์สวัสดิ์', NULL, 'baimon5435@gmail.com', NULL, '0620034416', NULL, '9/17 หมู่1 ตำบลช่อแฮ อำเภอเมือง จังหวัดแพร่ ', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1788, '65201280019', 'f3c648c94478887dbbbe3f5a96b479c9c82a3c86', 'นาย', 'ณัฐชัย', 'สีแดง', NULL, 'nattachai44331@gmail.com', NULL, '0809972927', NULL, '54 หมู่5 ต.แม่ยางตาล อ.ร้องกวาง จ\nแพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1789, '65201280020', '39a868c74c9eba6599fef1c98066297e505cd368', 'นาย', 'ธีรภัทร์', 'ผาผึ้ง', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1790, '65201280021', 'bac0416640d600d28e97eae7c52d2dcfcdb5c922', 'นาย', 'ดัสกร', 'ลาลิตร', NULL, 'datsakonlalit@gmail.com', NULL, '0979684885', NULL, '20/1 ต.กาญจนา หมู่3 หัวฝาย อ.เมือง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1791, '65201280022', '0fa2730c9040a0a315d9c7b0b026fccd76b864f7', 'นางสาว', 'วิลาวัณย์', 'กิติสาร', NULL, 'Techrae@hotmail.com', NULL, '0902872744', NULL, 'บ้านเลขที่42/4 บ้านม่อน ม.3 ต.เวียงต้า อ.ลอง จ.แพร่', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1792, '65201280023', '24ea6c049ee672a0394d6c5ba1b350e98209dfae', 'นาย', 'อนุชิต', '-', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1793, '65201280024', '10eb250e2aaeff5ee94ad242efa67498927b9c3d', 'นางสาว', 'รัตตนาภรณ์', 'นนทะรา', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1794, '65201280025', 'c155367b61bb272a38f4b9ef12c7eda383c5a91a', 'นาย', 'เฉลิมพล', 'กาบจันทร์', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1795, '65201280026', 'c8f96776acb56742a974875c5790f9df335ac444', 'นางสาว', 'พิมพิกา', 'วิหก', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1796, '65201280027', '5bdf03693ef22b50e34bff808b6fb0e9f98d4320', 'นางสาว', 'ชนิสรา', 'จันตาเเปง', NULL, 'Jajachanisara@gmail.com', NULL, '0855682875', NULL, '30/1 หมู่13 บ้านนาไผ่ \nต.ห้วยอ้อ อ.ลอง จ.เเพร่', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1797, '65201280028', '5c23f60ab22203f025134f51e2213a94b9ac7b51', 'นาย', 'ปิยพัทธ์', 'ฝักฝ่าย', NULL, 'aimik.th2549@gmail.com', NULL, '0969980125', NULL, '42/1 หมู่10 ต.น้ำชำ อ.สูงเม่น', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1798, '65201280029', '31e00fef6957e3f7bfe47606fbf0ba335b959713', 'นาย', 'ชัยวัฒน์', 'ชัยวงค์', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1799, '65201280030', 'cf9e12f994e5e8aed870d5c574f966854eec1889', 'นาย', 'ญาณภัทร', 'สมบูรณ์', NULL, 'yiwchanel2007@gmail.com', NULL, '0889592272', NULL, 'หมู่1 บ้านเลขที่87 ต.เเม่ทราย อ.ร้องกวาง จ.เเพร่\n', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1800, '65201280031', '7073b6606e102093a47dff8bf9cba3ad9cee46e7', 'นาย', 'พัทธดนย์', 'ถิ่นสุข', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1801, '65201280032', 'fcdb8972d8c81230d2ad69bfed186e43282286f9', 'นาย', 'ธนกฤต', 'เหลารัตร', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1802, '65201280033', '307fff15896980265c1a7908866b2f87e174b2a3', 'นาย', 'บูรพา', 'ทัศเกิด', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1803, '65201280034', '85088bd52e49e4add5225b3f32dbcc7313c75db1', 'นาย', 'กฤษฎา', 'ยานะเเก้ว', NULL, 'kidsadagg2@gmail.com', NULL, '0910763055', NULL, '167 ม.7 ต.ช่อแฮ อ.เมืองแพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1804, '65201280035', '48eea446ed31ef67750449be3876de6cdb264fa1', 'นาย', 'จีรพงษ์', 'จิตรจง', NULL, 'roplaytony@gmail.com', NULL, '0820266408', NULL, '476/1 หมู่8 เด่นชัย', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1805, '65201280036', '58973fd41c261f197cc318a2c58bb8d6343157a4', 'นาย', 'อำพล', 'เกิดมั่น', NULL, 'icegtawp123@gmail.com', NULL, '0980852493', NULL, '46/1หมู่3บ้านปากพวก', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1806, '65201280037', 'c304493aff736bdf6f8a2e2227fecf00cd4bbc32', 'นาย', 'ธนทัต', 'วงค์งาม', NULL, 'tanatat.w2549@gmail.com', NULL, '0655014100', NULL, '22/4 หมู่8​ ต.เวียงทอง​ อ.สูงเม่น​ จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1807, '65201280038', 'd01af95215722a8be54dfc0dbcb95495b4534142', 'นางสาว', 'พิชชาภา', 'พรมแก้ว', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1808, '65201280039', 'c32401195356e5278159a650ce83a504c3b01fa8', 'นาย', 'ธนภัทร', 'แก้วทอนช้าง', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1809, '65201280040', 'bad3ea3e6694e1bc6c39a30152d60cd86c194bc8', 'นาย', 'วงศธร', 'วงค์อินทร์', NULL, 'wongsathon1969@gmail.com', NULL, '0926627693', NULL, '155/1 ม.8 ต.ดอนแก้ว อ.สูงเม่น จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1810, '65201280041', '22ee8fed32a9048ee5afce5f84de7b1f8d4fa9d0', 'นาย', 'พิริยา', 'กอบกำ', NULL, '', NULL, '', NULL, '', NULL, 175, '', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1811, '65201280042', 'fa3d12fdbdd0e8f6ef58edd732be6522aabb9c8d', 'นาย', 'ศุภวิชญ์', 'วรรณกุล', NULL, 'mobaythai51@gmail.com', NULL, '', NULL, '', NULL, 175, '540000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1812, '65201280043', '8d71492609d3fbbf25fff1f31d2eb766ece287f6', 'นาย', 'ภูมิภัทร', 'จักรสาน', NULL, 'poommipat429@gmail.com', NULL, '0631353192', NULL, '', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1813, '65201280044', 'e6a820d14d77ffb7d6c4401ec81f41021c1a183b', 'นาย', 'ณภัทร', 'งามขำ', NULL, 'four181049@gmail.com', NULL, '0987586910', NULL, '50/1 หมู่3 ต.เวียงต้า อ.ลอง บ้านม่อน', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, '4.jpg'),
(1814, '65201280045', '321506dd74d193648e3424d1151de17681396008', 'นางสาว', 'ตีรณา', 'พันเดช', NULL, '', NULL, '', NULL, '', NULL, 175, '', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1815, '65201280046', '7a4d22544195471b094e21d192defb1da05ea62d', 'นาย', 'กิรติกร', 'ศรีนวล', NULL, 'tlelele2606@gmail.com', NULL, '0650470222', NULL, '', NULL, 175, '54120', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1816, '65201280047', 'a4ab8af821446eb03d216d7f23800b65ab7acac4', 'นาย', 'พงศ์พัฒน์', 'แก้วมูลศิริ', NULL, 'imuki.koji293@gmail.com', NULL, '0621736725', NULL, 'ค่ายทหารม้าม.พัน 12', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1817, '65201280048', 'a60a109a7aa31658bab03b0f4b340110a4d71d31', 'นาย', 'เพฑาย', 'พุฒิมา', NULL, 'ackhot63@gmail.com', NULL, '0946426747', NULL, '40/3 ตำบลบ้านเวียง อำเภอร้องกวาง จังหวัดแพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1818, '65201280049', '744dbe6e3ad69b2e13ec38fb4273ab0ba95840d8', 'นาย', 'ธนกร', 'สิงห์ชัย', NULL, '220549Poppy@gmail.com', NULL, '0926583307', NULL, 'บ.87/5 ม.10ต.ห้วยอ้อ อ.ลอง', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1819, '65201280050', '36ad4cb33edaf0994ac1c05d6771e14a635beac5', 'นาย', 'พัทธกรณ์', 'มูลนิกา', NULL, 'patta0613676879@gmail.com', NULL, '0613676879', NULL, '1หมู่7 ตำบลดอนมูล อำเภอสูงเม่น จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1820, '65201280051', '77351abf83236d1481df4ba35639d6839d9e78ef', 'นาย', 'รัฐนันท์', 'มีเดช', NULL, 'yongza2006@gmail.com', NULL, '0963818399', NULL, '225 ต.บ้านเหล่า อ.สูงเม่น จ.แพร่ หมู่ที่9', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1821, '65201280052', '21f7b9c7afca3a469665d4c68afb6233a529813a', 'นาย', 'ศิริวัฒน์', 'บัวทอง', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1866, '65301280061', '988df1cd75809c0afab7092027790afb562b135b', 'นาย', 'ธนภัทร', 'อินตา', NULL, '', NULL, '0923560114', NULL, '', NULL, 101, '', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1823, '65201280053', 'b24e69136b982e9bbb731cc4d30345437afd48a0', 'นาย', 'ภคพน', 'ด่านตระกูล', NULL, 'phkhphndantrakul5@gmail.com', NULL, '0628702631', NULL, '92 หมู่2 ต.วังหลวง อ.หนองม่วงไข่ จ.เเพร่ 54170', NULL, 175, '54170', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1824, '65201280054', '1aff5c9381c0cad1ba46f85a62fe0e06c6aec850', 'นาย', 'อมรเทพ', 'เมตตา', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1825, '65201280055', '166bc9d67bf3f2f1a8fa7621b9e6f10a22299cc8', 'นาย', 'กวีวัฒน์', 'เฉลิมวงษ์', NULL, 'nes.kaweewat@gmail.com', NULL, '0926195277', NULL, '12/3 หมู1 ตำบลร่องกาศ อำเภอสูงเม่น จังหวัดแพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1826, '65201280056', '57085df4bdfbceb2c84201083472661b1401b561', 'นาย', 'นิธิอัทธ์', 'รัศมีเปี่ยมแก้ว', NULL, 'nitiautpak2550@gmail.com', NULL, '0932811949', NULL, 'บ้านเลขที่76/1 หมู่7 ตำบล เหมืองหม้อ อำเภอ เมือง จั้งหวัด แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1830, '65201280060', '8c82878fb0e34a72d0d3aeb5cf08b8aa1ba2003f', 'นาย', 'ณัฐวุฒิ', 'สีงาม', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1831, '65201280061', '106280689f5841dd5051eb1bcd3108f82aebba30', 'นาย', 'ธนกร', 'แก้วประดับ', NULL, '', NULL, '0660074747', NULL, '', NULL, 175, '', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1832, '65301280001', '7a09a62c1217a1a3efac384f26d75198c7a5dd9e', 'นาย', 'ณัฐชนน', 'พรวญหาญ', NULL, 'notzaty7266@gmail.com', NULL, '0951605298', NULL, '83/2 หมู่6 ต.บ้านหนุน อ.สอง จ.แพร่ ', NULL, 175, '54120', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1833, '65301280002', 'e2377df5eec620569063521707e231277f14faa8', 'นาย', 'กิตติพงศ์', 'วิโจทุจ', NULL, 'Bird003za@gmail.com', NULL, '0648952087', NULL, '177หมู่9ตำบลป่าแดงอำเภอเมืองจังหวัดแพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1834, '65301280003', '14682286a7cb136a4599d2a7fe3a89cebb0ef2b5', 'นาย', 'ปรเมศวร์', 'แก้วอินัง', NULL, 'cardzumoo@gmail.com', NULL, '0987836983', NULL, '5 หมู่ 2 ตำบลตำหนักธรรม อำเภอหนองม่วงไข่ จังหวัดแพร่ ', NULL, 175, '54170', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1835, '65301280004', '1f9705463660b8d464cd4b29b327e6175f04b05a', 'นาย', 'กิตติศักดิ์', 'วิโจทุจ', NULL, 'benz03m111@gmail.com', NULL, '0889473682', NULL, '177หมู่9ตำบลป่าแดงอำเภอเมืองจังหวัดแพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1836, '65301280005', 'ab795c1d8559e5e551d644a85f7b5b2e5c1448a1', 'นาย', 'กิตตินันท์', 'กิตติวงศ์วาน', NULL, '', NULL, '0987820563', NULL, '104/1 ม.10 ต.หัวฝาย อ.สูงเม่น จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1837, '65301280006', 'f83d783c15bc0fe14df59101f10eb6c6b0e21fe0', 'นาย', 'ธนภัทร', 'สืบแก้ว', NULL, 'pota.aq2016@gmail.com', NULL, '0641857957', NULL, '40/1 หมู่ 2 ตำบล ท่าข้าม อำเภอ เมือง จังหวัด แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1838, '65301280007', '3fe12bafda4ca87d736f2a706912f4f5e2730270', 'นาย', 'พีรพัฒน์', 'มหาชัย', NULL, '0930163667aa@gmail.com', NULL, '0930163667', NULL, '128/30 ต.ต้าผามอก อ.ลอง จ.แพร่', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1839, '65301280008', 'ce2b9fd38dcc9a5f12d2984dbb2a2609f61dcb39', 'นาย', 'อัษฎายุธ', 'โตไผ่', NULL, 'skycraftthegame@gmail.com', NULL, '0650317083', NULL, '107\nบ้าน', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1840, '65301280009', 'f626bd042b77be89c7864e0a91757db9ba5b1c04', 'นาย', 'กฤติภัทร', 'ชมเชย', NULL, 'beamzero46@gmail.com', NULL, '0893176315', NULL, '75 หมู่11 ต.ป่าแมต อ.เมืองแพร่ จ.แพร่ ', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1841, '65301280010', 'a585dd4b21dfbe6b0e3924d57fec65284bdacc41', 'นาย', 'จิรวัฒน์', 'ปุตา', NULL, 'jirawatpota@gmail.com', NULL, '0993843732', NULL, '68หมู่10 อ.เด่นชัย   \nต.แม่จั๊วะ จ.แพร่', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1842, '65301280011', 'b7277f71c00c08e80e446f23f29ed8a5a0728c3e', 'นาย', 'รุ่งนิมิตร', 'ปนเปี้ย', NULL, 'roongnimit2358@gmail.com', NULL, '0979312358', NULL, '119/1 หมู่5 บ้านนาจอมขัวญ ต.ห้วยอ้อ อ.ลอง จ.เเพร่', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1843, '65301280012', 'b724961776ca06d50ee6890ecf973fda25b73e6f', 'นาย', 'พีรพัฒน์', 'ธนัญชัย', NULL, '-', NULL, '0970354270', NULL, '53/2 หมู่.3 ต.ท่าข้าม\nอ.เมืองเเพร่ จ.เเพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1844, '65301280013', '6164062aa24acdf9df5dfdbb097f28a33d3c3198', 'นาย', 'ฐิติพัฒน์', 'ดอนดง', NULL, 'dondong150846@gmail.com', NULL, '0954477891', NULL, '265', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1845, '65301280014', '54bba279ca3a8e88abe00bf3887f216f21281b12', 'นาย', 'กมลชัย', 'แห่งพิษ', NULL, '', NULL, '0944390896', NULL, '38/10 ม.3 อ.เมือง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1846, '65301280015', '60e17e02d3ecd89f41861c5a2703d9e4fe593a4d', 'นาย', 'นันทวัฒน์ ', 'เมฆอากาศ', NULL, 'koko148oak@gmail.com​', NULL, '0638940301', NULL, '157 หมู่ 1 ต.บ้านเหล่า อ.สูงเม่น', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1847, '65301280016', 'bb362805e6d7c5ee1366bd88d9c6d7515caf6d5d', 'นาย', 'นิติธาดา ', 'ยุศภา', NULL, 'Fordyusapha03@gmail.com', NULL, '0946018436', NULL, '108 ม.5 ต.เวียงต้า อ.ลอง จ.แพร่', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1848, '65301280017', '12dc2ebf191c62fef075cbfcaea73f37a86efb62', 'นาย', 'ภาณุพงศ์', 'สง่ากูล', NULL, 'panupongsangakul@gmail.com', NULL, '0980068866', NULL, '291 หมู่ที่ 7 ตำบล หัวฝาย\nอำเภอ สูงเม่น จังหวัด แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1849, '65301280018', 'c9a5a5f10f290cf467a7686ba970dc4e77e0ed94', 'นาย', 'ต้นตระการ', 'โพธิ์ถาวร', NULL, 'tontagarn@gmail.com', NULL, '0820850247', NULL, '64/5 บ้านป่าผึ้ง หมู่6 ต.หัวฝาย อ.สูงเม่น จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1850, '65301280019', '8891fb3343381e6a89f7d528ce2f571a5e8e0d0a', 'นาย', 'ธนบูรณ์ ', 'มุดเจริญ', NULL, 'zzhopeandboonzz@gmail.com', NULL, '0631830780', NULL, 'บ้านเลขที่ 55/2 หมู่.6', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1851, '65301280020', '94fc11c3e94ef4166bf00a13e02c28979cc455fb', 'นาย', 'วรายุส', 'คำอุด', NULL, 'ramboo344@gmail.com', NULL, '0950295670', NULL, '145 หมู่ที่1 ต.บ้านกวาง อ.สูงเม่น จ.แพร่ ', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1852, '65301280021', '4bce6dd7398a4677abfa90d72a217f7977199b6a', 'นาย', 'วรวุฒิ', 'เข็มเมือง', NULL, 'Worawut5745@gmail.com', NULL, '0933087159', NULL, '79ม.6ต.บ้านเวียง อ.ร้องกวาง\nจ.แพร่ ', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1853, '65301280022', '1a2b5b4240545515bf1153cf02fd9f7eabda02d4', 'นาย', 'วรวุฒิ', 'หล่ายแปด', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1854, '65301280023', '81066fa9c4efe73181850ad67c00b770388e42e7', 'นาย', 'จักรภัทร', 'เรืองทอง', NULL, 'gu.boss.gu1@gmail.com', NULL, '0952909047', NULL, '45 หมู่11 ต.ร่องกาศ อ.สูงเม่น จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1855, '65301280050', 'efa9f5bd7eb083691561d209f5c22f6176a9cbd8', 'นางสาว', 'ชนนิกานต์', 'วีระเดช', NULL, 'chonnikanwiradet@gmail.com', NULL, '0612972945', NULL, '55หมู่ที่5 ตำบลแม่ปาน อ.ลอง จ.แพร่', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1856, '65301280051', 'b836aa2ce5b2b7c2ad7f74bbbd5578fdf64c4028', 'นาย', 'ภูบดินทร์', 'มณีทิพย์', NULL, 'pubadins123@gmail.com', NULL, '0952286510', NULL, '58/1 หมู่ 2 บ้าน ทองเกศ \nตำบล เวียงทอง \nอำเภอ สูงเม่น จังหวัด แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1857, '65301280052', 'b606376ed0a3c4666078eaacd7f0402c2b4caf1b', 'นาย', 'อาทิตย์', 'หงษ์สามสิบหก', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1858, '65301280053', '6a4ab7fb6ff77c6bbd6564814d1ba7cbc378f504', 'นาย', 'รัชพล', 'จิตมั่น', NULL, 'rutchapol.00@gmail.com​', NULL, '0631075001', NULL, '115 ม.6 ต.ห้วยหม้าย อ.สอง จ.เเพร่ 54120', NULL, 175, '54120', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1859, '65301280054', 'dc5da0aadc0d4d7144f7685b799cf5f7c9f7f03d', 'นาย', 'สงกรานต์', 'สารีสุข', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1860, '65301280055', '0937f28d10eaf0e7787871d76a5c4ea1b8ad5a6b', 'นาย', 'ศิริศิลป์', 'พินิจจันทร์', NULL, 'nerogogonero863@gmail.com', NULL, '0656404890', NULL, '198 หมู่7 ต.ห้วยอ้อ อ.ลอง จ.แพร่', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, 'image_2023-11-09_211300193.png'),
(1861, '65301280056', 'a3b4532fc8ca9031b62104b7151a7ada01e3738b', 'นาย', 'ธนาดร', 'ป้อมอาษา', NULL, '', NULL, '0849730502', NULL, '', NULL, 175, '', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1865, '65301280060', 'a207811f67d53e1e5741c8d0de5cc29ed2d857a3', 'นาย', 'พงศกร', 'ประจวบ', NULL, 'pongsakorn_hoff2016@hotmail.com', NULL, '0637905810', NULL, '80/2หมู่ที่1 ต.พระหลวง อ.สูงเม่น จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1884, '65301280062', 'de975fd529d1e17646fe42f9af7dcf4cd7a3af6b', 'นางสาว', 'วาสนา', 'ดีคำ', NULL, 'watsana321123@gmail.com', NULL, '0944394835', NULL, '69/1ม.5 ต.บ้านปิน อ.ลอง จ.แพร่', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1892, '65301280024', '162bb63d6fe906a48cdf0773daf41e574665005c', 'นาย', 'อัษฎายุธ', 'โตไผ่', NULL, 'skycraftthegame@gmail.com', NULL, '0625391679', NULL, '107 หมู่5 ต.บ้านเวียง อ.ร้องกวาง จ.แพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1893, '65201280062', 'e487195408f28b4547816de2ad2fc1e3196b8a69', 'นางสาว', 'ใบหยก', 'แตงทอง', NULL, 'baiyoktt.1608@gmail.com', NULL, '0957133558', NULL, '132 ม.9 ต.ร้องเข็ม อ.ร้องกวาง จ.แพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1903, '66201280001', '4d9285846767dd3631c6566f604db024063f9faa', 'นางสาว', 'ประกายรัตน์', 'กึกก้อง', NULL, '', NULL, '0817578805', NULL, '104 หมู่ 9 ตำบลสูงเม่น อำเภอสูงเม่น', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1904, '66201280002', '11ac16f2984041d76b8a9847c77a31d6e600aa78', 'นาย', 'ศุภวิชญ์', 'ร่องพืช', NULL, 'r.supawit04@gmail.com', NULL, '0987847833', NULL, '275/2 ต.หนองม่วงไข่ อ.หนองม่วงไข่ จังหวัด เเพร่', NULL, 175, '54170', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1905, '66201280003', 'b44bc8d510a29a5e75fcd3e71290f3b87e977bc8', 'นาย', 'พงศพัด', 'อินทะพุธ', NULL, 'pongsapat.in@gmail.com', NULL, '0843513242', NULL, '154 หมู่8 บ้านลองลือบุญ ต.บ้านหนุน อ.สอง', NULL, 175, '54120', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1906, '66201280004', '$2y$10$cu/WprjjteZRxKMld6feSe36/21XfOalmw6NTb2/agwK3Ed791i0.', 'นาย', 'บวรวิชญ์', 'เสียงหวาน', NULL, 'bowornwit555@gmai.com', NULL, '0992740016', NULL, '117 หมู่ 14 ต.ป่าแมต อ.เมืองแพร่ จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1907, '66201280005', '282a36b4652b8bbe03ec5a1c646380273a04f277', 'นาย', 'สราวุฒิ', 'ชมเชย', NULL, '', NULL, '0925170012', NULL, 'เเพร่ สูงเม่น น้ำชำ บ้านบวกโป่ง หมู่11 บ้านเลขที่105', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1908, '66201280006', 'bd087c9e6c50600581cdc47bfa0b52e42efbf07c', 'นางสาว', 'สุภารัตน์​', 'กุ​ณ​น๊ะ​', NULL, 'aum1792550@gmail.com', NULL, '0650780251', NULL, '123/1 หมู่3 ต.ห้วยม้า อ.เมืองเเพร่ จ.เเพร่ ', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1909, '66201280007', '9d87405c805668f72fa13f510ac057c3c19dcc7a', 'นาย', 'ณัฏฐชัย', 'ไกรวุฒิพัชรกุล', NULL, 'kenji3098888@gmail.com', NULL, '0932481034', NULL, '155 หมู่3 อำเภอ เมือง หมู่บ้าน บ้านหัวฝาย', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1910, '66201280008', 'e7442d3786d8d85fe0a158295398f69272a5149d', 'นาย', 'มงคล', 'ขุนบุญ', NULL, 'phonevivo750@gmail.com', NULL, '0928023185', NULL, '44 ม.1 หมู่บ้าน.แม่แปง ต.นาพูน อ.วังชิ้น จ.แพร่', NULL, 175, '54160', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1911, '66201280009', '67a74306b06d0c01624fe0d0249a570f4d093747', 'นาย', 'ยศพล', 'ช่องรัมย์', NULL, 'ycohram@gmail.com', NULL, '0882637195', NULL, 'อ.เมือง ต.ทุ่งโฮ้ง หมู่.3', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1912, '66201280010', '4861a4af2ea502c4de421163d4f6e0cf147e688e', 'นาย', 'ณัฐภาส', 'สัตพันธ์', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1913, '66201280011', '62c39255ecf5d2fc6ecaefd6b2bdbd996e8ab164', 'นาย', 'ภานุดล', 'แก้วเขียว', NULL, 'time2255026@gmail.com', NULL, '0914781224', NULL, '11ม.3ต.แม่หล่ายอ.เมือง', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1914, '66201280012', '498843148ef5a3d27086c6fc15955d89129c4697', 'นาย', 'อนุรักษ์', 'นุชเทียน', NULL, 'banza6133@gmail.com', NULL, '0936250859', NULL, '95 ตำบล น้ำชำ อำเภอ สูง เม่น หมู่8 วัดดอนแก้ว', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1915, '66201280013', '2674a9a6b440fd61d862850a1e8732e6e852b2dd', 'นาย', 'กฤตภาส', 'ทิมดอน', NULL, 'kidtapad.timdorn@gmail.com', NULL, '0841343576', NULL, '128/1 ต.ป่าแมต อ.เมือง', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1916, '66201280014', '5f7dfc441ce5a645add6c090758bd45a1112d348', 'นางสาว', 'ธิดารัตน์', 'ใจกระเสน', NULL, 'thidarat5686@gmail.com', NULL, '0967755686', NULL, 'บ้านเลขที่113 หมู่5 ตำบลทุ่งโฮ้ง อำเภอเมือง', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1917, '66201280015', '378bc7339e661b80bbb28b57e31d48624236810a', 'นางสาว', 'กัญญาพัชร', 'ไชยมา', NULL, 'kanyaphatchaima12@gmail.com', NULL, '0931532851', NULL, '116/5 ,หมู่5 ต.บ้านปิน อ.ลอง จ.แพร่ ', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1918, '66201280016', '7836ac516563af480d0262fa19fc17ba9ccc33a4', 'นางสาว', 'มนธิรา', 'ยั่งยืน', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1919, '66201280017', '7ad4e7d4c0343857c5651c3266db42fe9e0a3de1', 'นาย', 'จารุเดช', 'กาทองทุ่ง', NULL, 'techinlmlm@gmail.com', NULL, '0971396806', NULL, '236 ม.4 ต.น้ำเลา อ.ร้องกวาง', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1920, '66201280018', '81e51a8fe61585dd39d1133bfc1f73a6be70d8bb', 'นาย', 'พีระพงศ์', 'หลีแก้วสาย', NULL, 'pootthipong5322@gmail.com', NULL, '0636822623', NULL, '62/2 หมู่1 อำเภอ เมือง \nจังหวัด แพร่ ตำบลสวนเขื่อน\n', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1921, '66201280019', '0d8d80cc533fc50766661e81097c9b65dc9aed7a', 'นาย', 'กันตภณ', 'สีงาม', NULL, '', NULL, '0825931077', NULL, '3/2  ม.1 ต.บ้านปง อ.สูงเม่น', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1922, '66201280020', '4ddb650fd4ed75c7b7a30369ed4cf7e5ada535f8', 'นาย', 'ณพวุฒิ', 'ร่มเย็น', NULL, 'noppawut.fei@gmail.com', NULL, '0886361141', NULL, '106/1 ม.2 ต.ทุ่งโฮ้ง อ.เมืองแพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1923, '66201280021', 'ea7b71572529dd432fb752fc1a6204923e29b577', 'นางสาว', 'นิพัทธา', 'ร่องศักดิ์', NULL, '', NULL, '0821933697', NULL, 'บ้านเลขที่62 หมู่ที่3 ตำบลทุ่งโฮ้ง อำเภอเมือง', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1924, '66201280022', 'd5d32a78f335218d58cb9c661be8cba789aa190e', 'นาย', 'กฤติเดช', 'ประไพศรี', NULL, 'nongtoto2500@gmail.com', NULL, '0849439474', NULL, '49 ม.11 ต.ร่องกาศ อ.สูงเม่น จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1925, '66201280023', '8f8223043bc9a82251f7e4ea0401f25c90a011c6', 'นาย', 'วชิรวิทย์', 'นวลคำ', NULL, '', NULL, '0910210869', NULL, '', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1926, '66201280024', '4b35b316aaee094a96d543fe0e063bf2356b5c61', 'นาย', 'ณัฐดนัย', 'วงศ์ใจมา', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1927, '66201280025', '5509459af20a9c9c14f252296563b759d81f8a6c', 'นางสาว', 'อมลญาภรณ์', 'เทศะ', NULL, '', NULL, '0829460456', NULL, '217 บ้านเเม่ลาน หมู่14 \nอำเภอลอง จังหวัดเเพร่', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1928, '66201280026', '77c2fd796baf1529a0ab0b8da5de77c570796b29', 'นาย', 'จตุมงคล', 'ชัยแขม', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1929, '66201280027', 'f52a3eba7fb6e0879800be071f8df54e58f4fd2e', 'นาย', 'พชรรักษ์', 'ติสระ', NULL, 'wabwbaza2546@gmail.com', NULL, '0801916520', NULL, '403 หมู่6 ต.ป่าแมต\nอ.เมือง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1930, '66201280028', 'e61a6c752b8096d79e01a980267ce4729074ba39', 'นางสาว', 'ธีรนาฏ', 'เพ็ชรรื่น', NULL, 'thiranat.pp15@gmail.com', NULL, '0613084715', NULL, '99 ม.4 ต.น้ำเลา อ.ร้องกวาง จ.แพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1931, '66201280029', 'fe032f2fc4d423ed2de94a6db3a5c5ea26466c94', 'นาย', 'แมยะ', 'อาว มอง', NULL, 'kritsanaphon14345@gmail.com', NULL, '0943818102', NULL, '160 หมู่14 ต.ห้วยอัอ อ.ลอง จ.เเพร่', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1932, '66201280030', 'fd8028b3e323cb8b6d6d08c0002975c0abf558ba', 'นาย', 'พงศกร', 'เพียงแก้ว', NULL, 'eamim9007@gmail.com', NULL, '0627640053', NULL, '91 หมู่ 9 ต.กาญจนา อ.เมืองแพร่ จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1933, '66201280031', 'dabeff7e6d82fa65c1e5414599533bcf8a34c89a', 'นาย', 'สัณห์พิชญ์', 'มาละเสน', NULL, 'sanphit131110@gmail.com', NULL, '0970418498', NULL, '40หมู๋7ตำบลส่วนเขื่อนอำเภอเมืองเเพร่จังหวัดเเพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1934, '66201280032', '6b7c9fed9544968023d97d119551775ef687ca3d', 'นาย', 'สุทธิภัทร', 'ต่างสี', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1935, '66201280033', '555eccee17e0788ae1506a1ac5a3044121fd5401', 'นาย', 'กฤษเรศ', 'ปรินรัมย์', NULL, 'ham2520yy@gmail.com', NULL, '0917540316', NULL, '210/2 ม5 จังหวัดแพร่ อำเภอสูงเม่น ตำบลหัวฝาย', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1936, '66201280034', '0ace2de0e72f561d6ad9927849f3c02ca17798cd', 'นาย', 'ภูริณัฐ', 'ใจสว่าง', NULL, 'phurinathciswang@gmail.com', NULL, '0889528714', NULL, '137/8 ม.9 ต.เวียงทอง อ.สูงเม่น จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1937, '66201280035', 'ceba881bec433f4c5b5ee22af1c2b507f3835a38', 'นางสาว', 'ชนินาถ', 'สุตาต๊ะ', NULL, '', NULL, '', NULL, '', NULL, 175, '', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1938, '66201280036', 'fdaa2f25ae2c6a6bd296e62a51c95229dc976a01', 'นาย', 'ธรรมนูญ', 'ศรีจันทร์', NULL, 'thammanoona51@gmail.com', NULL, '0805042731', NULL, '54 ร่องซ้อ ต.ในเวียง \nอ.เมือง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1939, '66201280037', '9d992c269830da616f87602889eee02b2605d38f', 'นาย', 'วัชระ', 'พงศ์พิภพ', NULL, 'kirito01ipeg@gmail.com', NULL, '0461320699', NULL, '146 หมู่18 ต.วาวี อ.แม่สรวย จ.เชียงราย', NULL, 170, '57100', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1940, '66201280038', '3a6c9040d708b40f2b8d6cc6340e2e8474c38f32', 'นาย', 'ราชพฤกษ์', 'เชื้ออ้วน', NULL, 'northchaeaun@gamil.com', NULL, '0655560297', NULL, '107 หมู่6 ตำบลร้องเข็ม\nอำเภอร้องกวาง จังหวัดแพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1941, '66201280039', '38325e3b6f1d19e48e1d5f2f86a0d0f00edee12f', 'นาย', 'เมธัส', 'ดาวดึงษ์', NULL, 'methus4527@gmail.com', NULL, '0653957968', NULL, '82/9', NULL, 175, '', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1942, '66201280040', '7957ba837cda3b41781f8e672b4f894fa9575b80', 'นาย', 'กรกฎ', 'สุวรรณสิทธิ์', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1943, '66201280041', '1d20ce8524e6192c19b9bd41be8d1ba898112284', 'นาย', 'ณัฐกิตติ์', 'สาขา', NULL, 'nuttakit0388@gmail.com', NULL, '0624056956', NULL, '108/2 หมู่ที่ 2 ต.เหมืองหม้อ อ.เมืองเเพร่ จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1944, '66201280042', '1015c65060a6c4ef0d91dad55cb9e70393236f0f', 'นางสาว', 'คคนางค์', 'ใจต๊ะมา', NULL, 'kaksnang.tonliew@gmail.com', NULL, '0622871108', NULL, '169ม.9ต.หัวทุ่งอ.ลองจ.แพร่', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1945, '66201280043', '71f32e18843f00002617aaa425ff320e5d8b94af', 'นางสาว', 'ณิชาภัทร', 'ตาณะฉาย', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1946, '66201280044', '672d733582813fad20c34aaa46241bca13ea82f4', 'นาย', 'กฤษฎา', 'ใจปัญญา', NULL, '', NULL, '', NULL, '', NULL, 175, '', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1947, '66201280045', 'c80c9cf30df3c1fc847f07a9f22d176b03ec5e6d', 'นาย', 'อัษฎายุทธ', 'โชติกะพุกกณะ', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1948, '66201280046', 'e64a59a7528f1c4fffe81d097410220fe435a9bf', 'นาย', 'เหมราช', 'ขอนเอิบ', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1949, '66201280047', '40563ac97f48b660f52187e8220a79cbd65af387', 'นาย', 'ธิตินันท์', 'ชุ่มปิว', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1950, '66201280048', '70061f2c855f67df2b09b91692a05ae0d92c2620', 'นาย', 'จักรกฤษณ์', 'ประมูลสิน', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1951, '66201280049', 'cc9309b60c421ce2e6d8277ea0f99c3f1a0f8395', 'นางสาว', 'อนัญญา', 'แฮคำ', NULL, 'sky.101loona@gmail.com', NULL, '0612095617', NULL, '44ม.3ต.ห้วยโรงอ.ร้องกวางจ.แพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1952, '66201280050', '1a38b36b780b206ff9ffd02e2cba1cca7f644c65', 'นาย', 'ชานน', 'กลีบใบ', NULL, 'chanonkleebbai@gmil.com', NULL, '0621533674', NULL, 'บ้านแม่หล่าย หมู่5/5\nตำบลแม่หล่าย อำเภอเมืองแพร่ จังหวัดแพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1953, '66201280051', '6309b84193d4d8ad4b41fb87694295cd86782e42', 'นาย', 'ณัฏฐ์ธฤต', 'วงศ์วรหิรัญ', NULL, 'wonkworrahiran1@gmail.com', NULL, '0658024302', NULL, '153 ม.1 ต.ร้องกวาง อ.ร้องกวาง จ.แพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1954, '66201280052', 'f877ab38efc3aa0c66fb7e417e2aa7e2d8cbd4f1', 'นาย', 'จีรพัฒน์', 'สายทอง', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1955, '66201280053', '9a0dcfa674a02b4c81ba2b27a8a5a0a4a959aa39', 'นางสาว', 'ณัฎฐธิดา', 'บุญรี', NULL, 'nattidaboonree1549137251', NULL, '0629143521', NULL, 'บ้านฮ้านน้ำหม้อ 75/2 หมู่6\nต.ห้วยไร่ อ.เด่นชัย จ.เเพร่', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1956, '66201280054', '6d215a20f27dd8094d2818cbfc70a36f9d4afcee', 'นางสาว', 'อรณิชา', 'เปี้ยแดง', NULL, 'onnicha.8826@gmail.com', NULL, '0615287853', NULL, 'บ้านเลขที่2 บ้านเเม่ขมิงหมู่2 ตำบลสรอย อำเภอวังชิ้น จังหวัดแพร่', NULL, 175, '54160', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1957, '66201280055', '83ce1502d8c8065e8e8a5b4e9fd3e7dd4d5d4821', 'นาย', 'ภัทรพล', 'นิลพันธ์พงษ์', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, '');
INSERT INTO `tb_member` (`member_id`, `member_code`, `member_password`, `member_title`, `member_firstname`, `member_lastname`, `member_gender`, `member_email`, `member_tel`, `member_mobile`, `member_fax`, `member_address`, `member_district`, `province_id`, `member_zipcode`, `member_registerdate`, `member_company`, `member_company_no`, `member_level`, `member_approve`, `member_last_login`, `member_note`, `member_line_token`, `member_line_token2`, `member_line_token3`, `member_line_token4`, `member_line_token5`, `member_type`, `student_id`, `member_img`) VALUES
(1958, '66201280056', '082948d5fbfbce7032e9668479db38e7f99e188c', 'นางสาว', 'อภิรดี', 'พะชะ', NULL, 'aphiraditar@gmail.com', NULL, '0656504299', NULL, '62 หมู่2 ตำบลสูงเม่น อำเภอสูงเม่น จังหวัดแพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, 'download (1).jpg'),
(1962, '66201280060', 'c18a5c208c00b024ed0fe3374601d000048db61d', 'นางสาว', 'ปวริศา', 'ลำดวน', NULL, '', NULL, '0623078839', NULL, '', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1963, '66201280061', '281ed149cb8107aecf93e057acdaefbdf3396fee', 'นาย', 'ธนกร', 'สถานทิพย์', NULL, 'Thanakon0839f@gmail.com', NULL, '0648899063', NULL, '', NULL, 175, '', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1964, '66201280062', '81a3f3efb8e5a329b4b763df65aac12c8ad2079f', 'นาย', 'พลกฤต', 'อินติ๊บ', NULL, 'oat9847@gmail.com', NULL, '0638589847', NULL, 'บ้านเลขที่139 อ.เด่นชัย\nต.แม่จั๊ว หมู่.6', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1965, '66201280063', '44232a8c4eeb97486edbef9e6d8f003209ade928', 'นาย', 'ธีรเทพ', 'บุญถา', NULL, '', NULL, '', NULL, '', NULL, 101, '', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1966, '66201280064', '3ea4d85fa099ed80edd84c25aebc69f0483b86bd', 'นางสาว', 'ปัทมาภรณ์', 'อ่อนน้อม', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1967, '66201280065', 'bd3ef9b4ab47fc31b568fc70fb83b134c4303e1d', 'นาย', 'อัคคเดช', 'ปั้นสุวรรณ', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1968, '66201280066', 'fc1b641a7b95d0c0449fa5294708a4a57e83f6a6', 'นาย', 'เมธี', 'มีปัญญา', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1969, '66201280067', '7bcc56545e2d5ed930b003afd07e7d83d1c71a9c', 'นางสาว', 'ชนิสรา', 'วงค์อาภาศิริ', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1970, '66201280068', 'f66625b5322067d9421ec93547ac00a68c28df3b', 'นาย', 'สรวิศ', 'พรชัยวิริยะกร', NULL, 'srwisphrchaywiriyakr@gmail.com', NULL, '0961621928', NULL, 'ต.สันทะ อ.นาน้อย จ.น่าน', NULL, 124, '55150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1971, '66301280001', '85fb3a5553906df1b663d2f0061cfa996e6e4f44', 'นาย', 'กิตตินันท์', 'วุฒิ', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1972, '66301280002', '5e5028433e9f92b977c2362895ce8abe977592e1', 'นาย', 'ศิริพงศ์', 'บุญประสิทธิ์', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1973, '66301280003', '1c382cd278b86f10d09a5cd135b4d23f1b8c8183', 'นาย', 'ณัฐนนท์', 'ปัญญาไว', NULL, 'nattanonpunyawai004@gmail.com', NULL, '0805014973', NULL, '23/2 หมู่ 11 จ.แพร่ อ.เมือง ต.เหมืองหม้อ', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1974, '66301280004', 'a89151a56261f733cb9af808c9a02a0ef382c58a', 'นาย', 'ธนกฤต', 'จันละคร', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, '20240505_091223.jpg'),
(1975, '66301280005', '1ee7eae5c39c4782cf4b4701e26dad033f7a63f9', 'นาย', 'รัฐภูมิ', 'สีจักรเงิน', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1976, '66301280006', '37ec66b51ffb6585025d65cd65a4f1ed2c69e4cf', 'นางสาว', 'เจนจิรา', 'มิ่งขวัญ', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1977, '66301280007', '086948852cfcec5acb5bcb2f5e06890fe9743598', 'นาย', 'กรกช', 'ถือนิล', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1978, '66301280008', '2f04cd1f468c4ba42b5556c9efed25e2f7abc863', 'นาย', 'สุริยพร', 'พรมนันท์', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1979, '66301280009', 'c701d5a5873223574a2a1e8d0ef85b3f45005104', 'นางสาว', 'ณัฏฐณิฌา', 'สีเข้ม', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1980, '66301280010', '126c3870da6927658f1f1e4956f77a3f0f78ee2a', 'นาย', 'วิษณุ', 'วังกระแสร์', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1981, '66301280011', '3ef65766a3080586144074de3e0de809d3b825f4', 'นาย', 'มนัสวิน', 'นาทาม', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1982, '66301280012', '3edf67a6cc7f2a9de3e296478db81a56869f2d74', 'นาย', 'ชญานนท์', 'คำเป็ง', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1983, '66301280013', 'da6a0e3391624b2513ad4b55d176444874980ed8', 'นาย', 'พัชพล', 'โค้คำหล้า', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1984, '66301280014', '1941f6916acb35db70b0a14b1f6ae85c6003d032', 'นาย', 'วิศวะ', 'คำเหมือง', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1985, '66301280015', 'd126bf1282775a839ef686a4b4eca619c73cd26d', 'นาย', 'อเนชา', 'จากน่าน', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1986, '66301280016', '844e0224979dbebb86d904dcf9db9950715c7822', 'นาย', 'กษิดิศ', 'แควชล', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1987, '66301280017', '5ca35b21b972fc1044ddb46fa9e3424f521c59aa', 'นาย', 'ณัฐพงษ์', 'พูลทวี', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1988, '66301280018', 'e961022a0c5e1adb0f29b95bcbad9f5abad39ae8', 'นาย', 'กรวิชญ์', 'ศรีประเสริฐ', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1989, '66301280019', 'c0c1179462819d9d2d131bc4cda03a9d8fda4acb', 'นาย', 'อาณาจักร', 'ข่มอาวุธ', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1990, '66301280020', '9d799ab658b0952d4d46c3e9c4bd5b6b2c6c7434', 'นาย', 'สรยุทธ์', 'แก้วมา', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1991, '66301280021', 'fb0727bfc06041e271d5abcf46b76d4ae4615040', 'นาย', 'มนัญชัย', 'กาศมัยจันทร์', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1992, '66301280022', '9e1114f130b58fbd7e1c03916ff9b799723acf63', 'นาย', 'ยศวรรธน์', 'ทะนันชัย', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1993, '66301280023', 'c1490674bfae90f18a4dc59d36880e2c6c8556a1', 'นาย', 'กิตติ​ภูมิ​', 'ศรี​ลา​', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1994, '66301280024', '4954ef1676e92c5bebac3fa211bf3faea07d5f1b', 'นาย', 'วชิริวทย์', 'แก่นโท', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1995, '66301280025', '5236b1cca61250851acc997dd66a88ff50b01414', 'นาย', 'อภิรักษ์', 'จำปาจี', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1996, '66301280026', 'b1a9c9538f4f00df15d84bb0c9a850a8e0415aaf', 'นาย', 'สุทธิพงค์', 'ตาคำสา', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1997, '66301280027', '93766ff472c4df106b940fb1643986d8c7c7c878', 'นางสาว', 'ทิพย์ธิดา', 'ต้นศิริ', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1998, '66301280028', '51b7900641c6c2718d1ac1f49cd179f86a39c5f0', 'นาย', 'ศรัญญู', 'ลียะวงค์', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(1999, '66301280029', '500bb7fe2f071d17fba79e21636de6b7588c685a', 'นาย', 'ภูวดล​', 'วัลลภัย', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2000, '66301280030', '28b8b176196a0afa936479a91409bbfac5dbd83e', 'นางสาว', 'เสาวภาคย์', 'เจริญวัย', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2001, '66301280031', 'e7aa29fece745aaea37dec2bcab330bf2d8f1333', 'นางสาว', 'พรนัชชา', 'ม่วงมัน', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2002, '66301280032', '635aa06097d9b977632fbc5caacf03082afeaf9b', 'นาย', 'วงศพัทธ์', 'ปลาหนองแปน', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2003, '66301280033', '620c74c23451a1828ac3422d5a9d0df52843bcb0', 'นาย', 'นัธพงศ์', 'แก้วมณี', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2004, '66301280050', 'bd41987873b9c1e8a4ee534703e897a6e075a163', 'นาย', 'ธนพนธ์', 'วิใจยา', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2005, '66301280051', '77848e7f51d3d30d203787bdcaec9257eda17d43', 'นางสาว', 'ณัฐติกานต์', 'ปัญจะลา', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2006, '66301280052', '8b4e765f4b702373f591c91fc05e1921b1323d09', 'นางสาว', 'กฤติญา', 'นะอิ', NULL, '', NULL, '0987706708', NULL, '', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2007, '66301280053', '837426593e1fa1af5e1fae93e0b219fc82324733', 'นางสาว', 'กาญจนา', 'แสงธง', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2008, '66301280054', '40d8b86e3a0a6c74ce447e21f8fa988ce74f671f', 'นาย', 'ดริณภัทร์', 'จันทิ', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2009, '66301280055', 'a3223d137ba33097bd63bf792809d342159a0533', 'นาย', 'ณัฐกิตติ์', 'วันมหาใจ', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2010, '66301280056', 'e087a01afeb49d719667abbfa9cada9daf9d418d', 'นางสาว', 'ธีรดา', 'นวลวงค์', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2014, '66301280060', 'c5d33dd6179edae7a4005de97de303e34dafb36c', 'นาย', 'สิทธินันท์', 'สายถิ่น', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2015, '66301280061', '7d91e461d0416f3bade1b7503c1be9a3c4d1e531', 'นาย', 'ดนุสรณ์', 'วิเชียรกันทา', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2016, '66301280062', '827588cf99e23ffb08a9652eee4245cd0cf64883', 'นาย', 'นราวิชญ์', 'อินทร์จันทร์', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2017, '66301280063', 'c5be2ee7fe75f9aaa1da585b466c7e96f3ddef00', 'นาย', 'ภานุวัฒน์', 'ดังดี', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2018, '66301280064', '724259b423f7cb3af6bb7221b55a754a20d6bfe3', 'นาย', 'วรุนันท์', 'สารเถื่อนแก้ว', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2019, '66301280065', 'b402be2cd47c74dd13c58f990e667b30a51ed4dd', 'นางสาว', 'กนกวรรณ', 'แสงสุริย์', NULL, 'Kanokwansangursee@gmail.com', NULL, '0658788010', NULL, '8 ม2 ต.ทุ่งศรี อ.ร้องกวาง จ.แพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2020, '66301280066', '168114c35febbd1a615653ed96d249fd18cfde8b', 'นาย', 'อานุภาพ', 'รัตนชมภู', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2021, '66301280067', 'b5c5ac47f53864f6fad5bf65721a0026252fc6d5', 'นาย', 'วิธวินท์', 'จันทรา', NULL, 'widtawin2547@gmail.com', NULL, '0899973997', NULL, '24/5 ถ.ราษฎร์อุทิศ ต.ในเวียง อ.เมืองแพร่ จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2022, '66301280068', '54132a72ea82620555d3245ca34608d04a5a698e', 'นาย', 'สิรภพ', 'กันเจริญ', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2023, '66301280069', 'c3068080589decf0cc36a673dad1e4d27ec3d74f', 'นาย', 'อนันตสิทธิ์', 'ศรชัย', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2027, '66201280070', '9360a3141e67c7873493e7bb35929c384a26415d', 'นาย', 'ศิริพัทธ์', 'ภักดีอาษา', NULL, 'earth.pakdeeasa@gmail.com', NULL, '0898503269', NULL, '36/1 ถ.ราษฎร์อุทิศ ต.ในเวียง อ.เมืองแพร่ จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2028, '66201280071', 'b4255ef36f6053907bdfb81f73eeadb0d1d43a96', 'นางสาว', 'กวิสรา', 'ใสสะอาด', NULL, 'ks0629745345@gmail.com', NULL, '0629745345', NULL, 'บ้านเลขที่154 อ.สูงเม่น ต.สบสาย หมู่2 ซอย6', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2091, '66201280074', '152d4f0d4d7d9e2b2f953240dfe6871969630f0e', 'นางสาว', 'คคนางค์', 'ใจต๊ะมา', NULL, NULL, NULL, '0622871108', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2092, '66301280034', '131d7f6d6f471e0c4232c323e288d406e9299363', 'นางสาว', 'พรนัชชา', 'ม่วงมัน', NULL, 'phornnucha@gmail.com', NULL, '0624240554', NULL, '132 หมู่7 ต.ห้วยไร่ อ.เด่นชัย จ.แพร่', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2093, '66301280070', '1f82ea75c5cc526729e2d581aeb3aeccfef4407e', 'นาย', 'วรธาม', 'หล้าคำมี', NULL, '', NULL, '0803740205', NULL, '', NULL, 175, '', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2096, '67219090001', '3699e4ee7f193155d1df169aae05fe77ffe75a23', 'นาย', 'ณัฐภัทร', 'ท่วงที', NULL, 'nattapathtuangtee@gmail.com', NULL, '0652473516', NULL, '224/3 ต.บ้านปง อ.สูงเม่น จ.แพร่ ', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2097, '67219090002', '073ee72b74b1a15368f0c36ab7a75b77d8c246d1', 'นางสาว', 'ปรีดารัตน์', 'ขืมจันทร์', NULL, 'Preedaratch551@gmail.com', NULL, '0924283516', NULL, '153 หมู่3 ต.น้ำเลา อ.ร้องกวาง จ.แพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2098, '67219090003', 'ac4f0130ee0c608210c580667c80db83faa9634e', 'นาย', 'สุริยพงศ์', 'มูลสุข', NULL, 'm.suriyaphong@gmail.com', NULL, '0654386692', NULL, 'บ้านเลขที่93/2หมู่2ตำบลเวียงต้าอำเภอลองจังหวัดแพร่', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2099, '67219090004', '646d54c82b569494b4f60b888bd068e7d173b9e8', 'นาย', 'จิรพนธ์', 'ทาก๋า', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2100, '67219090005', '9f2bf4ff956ef7022bbeab58368ac822040566c7', 'นาย', 'พงศกร', 'อินกา', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2101, '67219090006', 'afafff95b3add7a7da217ed358078180f3d0dda2', 'นาย', 'ธนวิน', 'ถาโถม', NULL, 'thanawin.txy@gmail.com', NULL, '0830044582', NULL, '175 หมู่1 ต.ร่องฟอง อ.เมือง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2102, '67219090007', '1d74c9dcad3c21eb4779f1eeb4226cb59d6e9bd4', 'นาย', 'พีรวิชญ์', 'มาอุ่น', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2103, '67219090008', '89166cb3cb9329d1900a464b52ef520736b4f992', 'นาย', 'ญาณวัฒน์', 'ร่องซ้อ', NULL, 'Yanawatauto2206@gmail.com', NULL, '0639496808', NULL, '63/9 หัวเมือง สอง เเพร่', NULL, 175, '54120', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2104, '67219090009', '6d1c7c3ba906b2e9ee23a15f0f76473e92b091c2', 'นางสาว', 'ภัทรนันท์', 'ฉิมภารส', NULL, 'pataranan180851@gmail.com', NULL, '0924637046', NULL, '225/5 ม.4 ต.ทุ่งกวาว อ.เมืองแพร่ จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2105, '67219090010', '5bb75b0982c4e0980e9125c6021834d2e0895bc0', 'นางสาว', 'ภัสสร', 'ดำคำ', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2106, '67219090011', 'dc96dc7df847abc93095aa6a596437fe7c9e114e', 'นาย', 'นัทธพงศ์', 'จันทชารี', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2107, '67219090012', 'ea54a7c5bf11b3a8b8ce8d0fc16d95ccdab438e1', 'นาย', 'จารุวิทย์', 'สายพิบูลย์', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2108, '67219090013', '2cb2d50f2cfaf810c541b23fc9f62ececd24804a', 'นางสาว', 'ธันย์ยานี', 'ศรีวิชัย', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2109, '67219090014', 'a046370a8d666a2bed37fef9030d37ebaae7ea17', 'นาย', 'นวพล', 'ประจำเมือง', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2110, '67219090015', 'cc3d638335f5987ee849a0beda4e03b0d3719583', 'นาย', 'ณัฐสิทธิ์', 'สุดวรรค', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2111, '67219090048', 'f1ce46ffde477da29e796dce2bdacb893c1602fb', 'นางสาว', 'จรัสศรี', 'จักร์แก้ว', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2112, '67219090049', '3c5963b44500f5e75aa1d494738b72e5866f7887', 'นางสาว', 'ผกาพรรณ', 'เอ้ยวัน', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2113, '67219090016', 'bf5af37f109d576929efe6ebbff68c9e15322140', 'นาย', 'ธีระพล', 'กมลเมือง', NULL, '', NULL, '0934214758', NULL, 'บ้านเลขที่83หมู่4ตําบลนํ้าชําอําเภสูงเม่นจังหวัดเเพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2114, '67219090017', '8834c5bb0be6c761e498005ec67259d29d4ac059', 'นาย', 'พีรวิชญ์', 'สุรจิต', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2115, '67219090018', '9d8bcb3babd4d372be566566c00685edf7f20e24', 'นาย', 'ญาณวิทย์', 'วรรณงาม', NULL, 'auto2551.wan@gmail.com', NULL, '0639952770', NULL, '', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2116, '67219090019', 'dd712881727db8feb76b746df414e57ce0b135a8', 'นาย', 'สรรเสริญ', 'อุปสรรค์', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2117, '67219090020', 'c4dc82f728342b9935cf4335fe066a09c8e6707e', 'นางสาว', 'ณิชกุล', 'ผาทอง', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2118, '67219090021', '32c08a58d3b29e4b2908cf701bba3fe9fe641988', 'นาย', 'ภูดิส', 'แจ้งนคร', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2119, '67219090022', '60b95623cd0e11e0101ba59ea782cc6ae0911f7b', 'นาย', 'ณัชพล', 'วิชาธร', NULL, 'jamenatchapol212@gmail.com', NULL, '0822211971', NULL, '4/4 หมู่9 ตำบลห้วยอ้อ อำเภอลอง จ.แพร่', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2120, '67219090023', 'fd114ba7277bc065e79a533eaf27f43c6214ac7a', 'นาย', 'สิทธิพล', 'อาทิตย์ตั้ง', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2121, '67219090024', '5e1eecbb691d157576ef2867e3722e4f32b84ace', 'นางสาว', 'พิมพกานต์', 'ปัญจะลา', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2122, '67219090025', '480a751df30a5b708ac644818e307768f4fabdbb', 'นาย', 'พีรพัฒน์', 'เหล็กแก้ว', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2123, '67219090026', 'b87a4a80ffd535a6f9fdc635ebb65040f752a5db', 'นาย', 'รัตนพล', 'บรรจง', NULL, 'rattanaphon3961@gmail.com', NULL, '0864232761', NULL, 'บ้านเลขที่179หมู่5ต.ปงป่าหวาย อ.เด่นชัย จ.แพร่', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2124, '67219090027', '1557acb47746391dd913ce998d3c9709b5b42a24', 'นาย', 'วทัญญู', 'กันตะนา', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2125, '67219090028', '4d3ffbf2d8974b80dd44fe86304dd86f80663d44', 'นางสาว', 'ช่อลดา', 'จักรสาน', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2126, '67219090029', 'b0caeae19cfa814838d65e0343a3e0f2275f99d0', 'นาย', 'พีรพงษ์', 'สมบุตร', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2127, '67219090030', 'ec68cacbc1bf3c8faecb96b9c72d461191050ed6', 'นาย', 'ณัฐนันท์', 'วงค์ฉายา', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2128, '67219090047', '9e611fbcd953dd9955939b0a1491e65d2bda0fa8', 'นาย', 'ธนกฤต', 'เหล่ารุ่งเรืองกุล', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2129, '67219090050', '07f9d3f1c0c82090d92ba42fa30bd9fcd1030d68', 'นาย', 'ธนกร', 'พึ่งตน', NULL, 'marshmello38612@gmail.com', NULL, '0858065796', NULL, '73 หมู่ 3 ต.ป่าแดง อ.เมือง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2130, '67219090031', '953728aaf190a303301c27c6c5177e6593b35f3e', 'นาย', 'ถิรพัทธิ์', 'ดวงเกษม', NULL, 'xakhrdechchaywathn@gmail.com', NULL, '0988931161', NULL, '99 หมู่12 ตำบลหัวฝาย อำเภอสูงเม่น จังหวัดแพร่ 54130', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2131, '67219090032', '7cf7598675c2e8db8b3f5b3bd42455ccbb5b34fd', 'นาย', 'กฤษดา', 'เชียงทา', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2132, '67219090033', '6bbeae84d0284e72d846acf7c66055c205191544', 'นาย', 'พงศกร', 'พรมสวะณา', NULL, 'posbsuc2527@gmail.com', NULL, '0658944973', NULL, '27/2 ซอย 1 อ.สู่งเม่น\nต.บ้านปง จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2133, '67219090034', 'e6c5a588a6b4bb6938fc122b447b0505f4382a4e', 'นาย', 'ปุณณจิต\r\n', 'จิตสว่าง\r\n', NULL, 'j.koon2551@gmail.com', NULL, '0636255771', NULL, 'Phrae, Thailand', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2134, '67219090035', '4e640ef7e071d65e337829394373fe7857c277b4', 'นาย', 'สุเทพ', 'รัชวัตร์', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2135, '67219090036', '947adc5b16733d3f1048c3130450ac91f04397c7', 'นางสาว', 'วิรินรัญชนา', 'บุญสาร', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2136, '67219090037', '67a74306b06d0c01624fe0d0249a570f4d093747', 'นาย', 'ณัฐปกร', 'ด่านตระกูล', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2137, '67219090038', '7244e2f73ec75fcb74214723456490e3158369e2', 'นาย', 'ธนภัทร', 'มโนรา', NULL, 'thanapat99m@qmail.com', NULL, '0949079547', NULL, '31หมู่1อ.สอง จ.เเพร่', NULL, 175, '54120', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2138, '67219090039', 'dc336433335d86c331598cda6f70ee229d8241e4', 'นาย', 'ธนภูมิ', 'สีแดง', NULL, 'sidaengthnphumi082@gmail.com', NULL, '0926647578', NULL, '6/1 ต.ทุ่งกวาว อ.เมืองแพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2139, '67219090040', '1633c0d1c2c5141b95f2dc7994e59899a90b4bec', 'นาย', 'ณัฐกรณ์', 'กวาวสิบสอง', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2140, '67219090041', 'df2dba34b1ef5e289e71996849de4cdf24316b85', 'นาย', 'รัชพล', 'สุริยะสุข', NULL, 'ratchaphonsuriyasuk@gmail.com', NULL, '0932967280', NULL, 'บ้านเลขที่25ม.5บ้านอ้ายลิ่ม ต.ทุ่งแล้ง อ.ลอง จ.แพร่', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2142, '67219090042', '57bb9ceb42b73030661a6d3f27f6dd53e5c7013a', 'นางสาว', 'ธนัชชา', 'สุทธกร', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2143, '67219090043', '5d04e90bff6e876d0940ada0a21e9e5854fdb6e1', 'นาย', 'ปัณณวิชญ์', 'อาตวงษ์', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2144, '67219090044', 'adc2d8d156460926c9d33efb7f210c9d3dbae92e', 'นางสาว', 'อภิชญา', 'ไข่คำ', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2145, '67219090045', 'ce2b24aeed179a22fefe4dbe746262e77d2ac8e0', 'นางสาว', 'ญากาจ์นสิริ', 'ผ่านคำ', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2146, '67219090046', '5453d63d278da7eafaa23434fa370e7c052096dc', 'นาย', 'ตัชกร', 'สิริรชารัช', NULL, 'tsirircharach@gmail.com', NULL, '0981615447', NULL, '', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2147, '67319090050', 'ecb422bfd27880799740338ea269deead4584474', 'นางสาว', 'หทัยชนก', 'คงยืน', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2148, '67319090051', '184eaf46958b5b733fdf4b0b1c1484fcb6eb3701', 'นางสาว', 'ธัญชนก', 'แก้วคร่ำทอง', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2149, '67319090052', '76a3f30be973d23a56c7c4293491cde71e458bd5', 'นาย', 'อัฐพล', 'เสาร์อินทร์', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2150, '67319090053', '8c4183d025149341df57501b6a8e29f96236ad4d', 'นาย', 'ธนภัทร', 'ทองโต', NULL, 'posttoday18@gmail.com', NULL, '0820016205', NULL, '', NULL, 130, '', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2151, '67319090054', '40aac4c290a9f0d8a12658fc619a5675c2ae3fb3', 'นาย', 'ดิตถกร', 'บุญอินทร์', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2152, '67319090056', '83c59b510d4adcd9d7e5b8613cb30f2e138aada2', 'นางสาว', 'พรทิพย์', 'เเสนคำลอ', NULL, '', NULL, '0864779560', NULL, '', NULL, 175, '', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2156, '67319090060', '29c7d5f83a0d5ca27fc5b0f8ac65d55bb43cc7b5', 'นาย', 'กฤษตยชญ์', 'ทองงาม', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2157, '67319090061', '2bfeb471946cb86ee07ae6f7250d307081634fbf', 'นางสาว', 'ลัคณา', 'เสนาธรรม', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2158, '67319090062', '90c77fc53568d8a546188f8cd439a9d30fb5f712', 'นาย', 'กรวิชญ์', 'สิงห์คราม', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2159, '67319090063', '7ee224bb63318ef1c4690ae7c486a2c0cd3acfbb', 'นางสาว', 'เขมิสรา', 'ถาปะนา', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2160, '67319090064', '6ebb4823e0dc0a4af6e8d7d0d1c8cad14fc2bf0a', 'นาย', 'ศุภณัฐ', 'พุฒิไพศาล', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2161, '67319090065', '607b1ce7cd83b6ba407dc408d148bcd11bfdd0e6', 'นางสาว', 'ชนิกานต์', 'พุฒิไพศาล', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2162, '67319090001', 'c45ad2dd5097e043ad882d222e91a205ed32172b', 'นาย', 'สุทิวัส', 'ยานะวิน', NULL, 'aun.suthiwas@gmail.com', NULL, '0924670290', NULL, '80 ม.1 ต.แม่ทราย อ.ร้อง กวาง จ.แพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2163, '67319090002', 'a63607652a4c406952b6d1c16d3da66b41443ac3', 'นาย', 'พงศภร', 'สมสิน', NULL, 'maizananuto@gmail.co', NULL, '0802575189', NULL, '60 หมู่4 ตำบลแม่จั๊วะ อำเภอเด่นชัย จังหวัดแพร่', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2164, '67319090003', '27ca4bd953d2fbc11c505b6575415f17031812b5', 'นาย', 'คุณานนต์', 'ศรชัย', NULL, 'sornchaikunanon@gmail.com', NULL, '0836038713', NULL, '5/1 หมู่10 ตำบลสูงเม่น อำเภอสูงเม่น จังหวัดแพร่ ', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2165, '67319090004', 'b447cc5305d69cbefc77f037a2113e8bc63c9d25', 'นาย', 'ภูริพัฒน์', 'เผ่าศรี', NULL, 'puriphatpaoshi@gmail.com', NULL, '0654820800', NULL, '275 หมู่ 1 ตำบล ร่องฟอง อำเภอเมืองแพร่ จังหวัดแพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2166, '67319090005', 'e699375b8665e57d90e4b94d701737451b2cb5bf', 'นาย', 'สรรพวัต', 'กลั่นสกุล', NULL, 'nongkong.k123@gmail.com', NULL, '0944460359', NULL, '197 ม.12 ต.หัวฝาย อ.สูงเม่น จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2167, '67319090006', 'cf358eb582178aa88cff42166293d47b3b0c35bf', 'นาย', 'ฉัตตภูมิ', 'เอี่ยมสอาด', NULL, 'zasu8765@gmail.com', NULL, '0914757113', NULL, '158/22 ถนนยันตรกิจโกศล\nอ.เมือง ต.ในเวีียง', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2168, '67319090007', 'dca50f9461e861791276e7a05cad1a1d755c7518', 'นาย', 'ธีระศักดิ์', 'ทองอุราฬ', NULL, 'po9598329@gmail.com', NULL, '06568139222', NULL, '80/1 ต.แม่จั๊วะ อ.เด่นชัย จ.แพร่', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2169, '67319090008', '537eee0ba6098b170166e0341f6c2f95a5eb9029', 'นาย', 'พิชิตชัย', 'มุกเพ็ชร์', NULL, 'bballkkung@gmail.com', NULL, '0612868351', NULL, '134 หมู่5 ตำบล วังหงส์\nอำเภอ เมือง จังหวักแพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2170, '67319090009', 'f7a04813dc8dc3991be688347dfda280493e2345', 'นาย', 'ศรนเรศ', 'มีชัยเจริญ', NULL, 'sornnaretnon@gmail.com', NULL, '083-0038-347', NULL, '43/3 หมู่ 5 ต.แม่หล่าย อ.เมือง จ.แพร่ 54000', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2171, '67319090010', '1c9500445648790928c1f502ff7cb40995fc49e6', 'นาย', 'พิชชากร', 'อินทเจริญศานต์', NULL, 'nekomaasan@gmail.com', NULL, '0956988847', NULL, 'อ.ร้องกวาง ต.น้ำเลา ม.3 173 ', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2172, '67319090011', '9391dec5aa435846b0025b29e72661f260d8140d', 'นาย', 'ธัญวิชญ์', 'พหุสัจจธรรม', NULL, 'tent6052544@gmail.com', NULL, '0960234366', NULL, '144/67 ถ.ช่อเเฮ ต.ในเวียง อ.เมืองเเพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2173, '67319090012', '9fa1db3a1cdb13e24b97dfd6cf5ed435daf66b2d', 'นาย', 'อนันต์ตุลา', 'ม้าวิ่ง', NULL, 'Anantoola35@gmail.com', NULL, '0979300817', NULL, '31 หมู่2 ตำบลห้วยม้า อำเถอเมือง จังหวัด แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2174, '67319090013', '18e37b83ef88883f3bad6ed59c177e6ced0adeb7', 'นาย', 'กฤษฎากร', 'แก้วพรม', NULL, 'pichayakarn45@gmail.com', NULL, '0979309677', NULL, 'บ้านเลขที่74/5 หมู่11 ตำบลร่องกาศ อำเภอสูงเม่น จังหวัดแพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2175, '67319090014', '1f52bf38368bf1c1ad397bafff7067c19ca016bd', 'นาย', 'กนกพล', 'ปัญญาธรรม', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2176, '67319090015', '84afebc697b10d8f9598e4152ccfcdd764154b3b', 'นาย', 'ธนกฤต', 'วงศ์ศักดิ์สิทธิ์', NULL, 'tanakrit1747@gmail.com', NULL, '0636588146', NULL, '194 หมู่7 ต.หัวฝาย อ.สูงเม่น', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2177, '67319090016', '4aaf437d4406a3008d53b40479e657a27fc125db', 'นาย', 'กฤศ', 'ศศิวงศากุล', NULL, 'mraccrag0@gmail.com', NULL, '0979404551', NULL, 'บ้านเลขที่40 เหมืองหม้อ หมู่3 อำเภอเมือง จังหวัดแพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2178, '67319090017', 'b09f81c1ba19bd7adda4d83cf161e3f0c8b412a0', 'นาย', 'ธีรวัสส์', 'นาคะสิทธิ์', NULL, 'darkend.darknes1@gmail.com', NULL, '0984463504', NULL, '245 ม.3 ตำบลพระหลวง อำเภอสูงเม่น จังหวัดแพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2179, '67319090018', 'ee8ed08c46b38e01f51b69acfd4aef671f395d53', 'นาย', 'ปิยะพันธิ์', 'เวียงโอสถ', NULL, '', NULL, '0992728337', NULL, '309/3 ม.10 ต.เเม่จั๊ว อ.เด่นชัย จ.เเพร่', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2180, '67319090019', 'c66be41af9ab93b37eed1a3d13bced876fff0e19', 'นาย', 'ชนกันต์', 'เย็นใจ', NULL, 'nichapatyenjai35@gmail.com', NULL, '0654538919', NULL, '84 หมู่6 ตำบล ทุ่งกวาว อำเภอ เมือง จังหวัดแพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2181, '67319090020', '6646c301b51364ab5a4b16b37d63af6c6f9ff853', 'นาย', 'ณัฏฐกิตติ์', 'สร้อยสังวรณ์', NULL, 'nantakit.3415@gmail.com', NULL, '0947984078', NULL, '100/1 ถนนช่อแฮ่ ตำบลในเวียงอำเภอเมืองจังหวัดแพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2182, '67319090021', '650ada0bd7c487b04b83cd28d60cd20ff47a262d', 'นาย', 'วิวรรธน์', 'นาพรม', NULL, 'w.wiwat88@gmail.com', NULL, '0658631485', NULL, '72 หมู่7 ต.นํ้าเลา อ.ร้องกวาง จ.แพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2183, '67319090022', '4e2db31470426ec282bb6c77ceb65619254659f1', 'นาย', 'อธิภัทร', 'ตันติพิสิฐกุล', NULL, 'atiphat.tt99@gmail.com', NULL, '0984615699', NULL, '76/1 ต.ต้าผามอก อ.ลอง\nจ.แพร่', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2184, '67319090023', '80e294369a1fe493c7ee5a3b35da512f094c2376', 'นาย', 'พีรพัฒน์', 'พุ่มพวง', NULL, 'pumpoungpeerapat240@gmail.com', NULL, '0898327176', NULL, '132/4 ถนนยันตรกิจโกศล ต.ร่องกาศ หมู่3 อ.สูงเม่น จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2185, '67319090024', '48bd3b526af934ee4a0377c604fa046ad3aaae5c', 'นาย', 'ณัฐกิตติ์', 'เวียงเจ็ด', NULL, 'natthakitwiangjet6035@gmail.com', NULL, '0840416035 ', NULL, '51 หมู่4 ตำบลช่อแฮ อำเภอเมืองแพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2186, '67319090025', 'fcdc2e96e994746b06d4254c7a411299160f4f40', 'นางสาว', 'กนกภรณ์', 'ริพล', NULL, 'Kanokpornthay@gmail.com', NULL, '0972312194', NULL, '36 ม.4 ต.เเม่ทราย อ.ร้องกวาง\nจ.เเพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2187, '67319090026', '6d312681c750256756b743af1de477240b5a0660', 'นาย', 'ศุภวิชญ์', 'เครือไทย', NULL, 'gearhero08@gmail.com', NULL, '0613838828', NULL, '29 ม.2 ต.ตำหนักธรรม อ.หนองม่วงไข่ จ.แพร่ ', NULL, 175, '54170', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2188, '67319090027', 'eb65cfbc391ac9a80c520f09e88df97cd97a0709', 'นางสาว', 'วิศินี', 'สุทธิพราหมณ์', NULL, 'visineesuttipram@gmail.com', NULL, '0926648250', NULL, '192/1 หมู่1 ต.ร่องฟอง อ.เมือง', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2189, '67319090028', '51b5b4bbb263f32bab6eed34e5688c65b09086df', 'นาย', 'ศุภวิชญ์', 'มังกร', NULL, 'suphawitmangkon2548@gmail.com', NULL, '0991799832', NULL, '194/2หมู่7 ต.หัวฝาย อ.สูงเม่น จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2190, '67319090029', '9eca941f780acb796024977ca4e69082ec3b563f', 'นาย', 'พิชานันท์', 'ศรีรัตนะพัฒน์', NULL, 'phonephichanan@gmail.com', NULL, '0935537138', NULL, '41/2 ม.12 ซ.13 ตำบลป่าแมต อำเภอเมืองแพร่ จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2191, '67319090030', '4753f52bbb32b0b28f9b1feb278e2f8bc89bb7ff', 'นาย', 'เดชสิทธิ์', 'เดชกุญชร', NULL, 'dejsitti@gmail.com', NULL, '0863850085', NULL, '151 หมู่ 5 ต.บ้านปิน อ.ลอง จ.แพร่', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2192, '67319090031', '6f3563e60fd6f9a66ae0ebd55808ed62becf9e7e', 'นาย', 'ศิวัฒน์', 'กล่อมปาน', NULL, 'sklomparn@gmail.com', NULL, '0625291069', NULL, '118 ม.7 ต.น้ำเลา อ.ร้องกวาง จ.แพร่ ', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2193, '67319090032', '79650b89086a9bccd9a843d64e1b11dab1d79224', 'นางสาว', 'สัจจพร', 'อินธนู', NULL, 'Satchaporn4082@gmail.com', NULL, '0864344082', NULL, '116หมู่2 ต.บ้านปง อ.สูงเม่น จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2194, '67319090033', 'b607613e43100887dc1fa185119710e397aaa17b', 'นาย', 'ณัฐภูมิ', 'นิลุบล', NULL, '', NULL, '0902966012', NULL, '49/1 ม.6 ต.เวียงทอง อ.สูงเม่น', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2195, '67319090034', '59b170519da02469b64037bbb0d9f6f29c3900c7', 'นาย', 'ปรัญชัย', 'กาศเกษม', NULL, 'paranchai6088@gmail.com', NULL, '0631060324', NULL, 'วังหงหมู่5อ.เมือง จ.เเพร่ซอย28', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2196, '67319090035', '610bf50d8b09a3b6ac1d7a0899a3c15587bd5a12', 'นาย', 'วุฒิกร', 'จีกัน', NULL, 'tarza521za@gmail.com', NULL, '0961900060', NULL, '167 หมู่ 1 ซอย 1 ต.บ้านกวาง อ.สูงเม่น จ.แพร่ ', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2197, '67319090036', '2a9bd43c224e36e4646af720239d6cabf0cf919c', 'นาย', 'วรรธนะ', 'ประดับเชื้อ', NULL, 'FaLord429@gmail.com', NULL, '0947518533', NULL, '50/1 ม.4 ต.นาจักร อ.เมือง จ.เเพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2198, '67319090037', 'e3a80a00fc9b598d411e2a72e075088582b64110', 'นาย', 'บารมี', 'อุดกันทา', NULL, 'barrameeaudkanta@gmail.com', NULL, '0932856013', NULL, '220', NULL, 175, '54160', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2199, '67319090038', '60fe30f9329dde5677f3921824eaf716c6675d35', 'นาย', 'ธนโชติ', 'วันดี', NULL, 'thanachot0659@gmail.com', NULL, '0801029574', NULL, '249 ม.15 ซอย5 ต.ป่าแมต อ.เมือง จ.แพร่', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2200, '67319090039', '8a09eee9d2dfcfd9c09182ef96d34b28949160be', 'นาย', 'ราชพฤกษ์', 'คำเขียว', NULL, 'fourzqe@gmail.com', NULL, '0825690520', NULL, '94/1 ต.ทุ่งศรี อ.ร้องกวาง จ.แพร่', NULL, 175, '54140', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2201, '67319090040', '458f1fdcb0390d0ac7195677356f615b9ff600cf', 'นาย', 'ชนาธิศ​', 'ชื่น​ประดิษฐ์​', NULL, 'nonaeinter@gmail.com', NULL, '0932537954', NULL, '155หมู่8 ตอน.ดอลมูล อยู่.สูงเม่น จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2202, '67319090041', 'afd5277f0a3505ca73f8ff7f4a55a622dcd95068', 'นาย', 'วิรุฬห์', 'กาศสกุล', NULL, 'jjjaggh675@gmail.com', NULL, '0948810435', NULL, '7/3 ม.8 ต.ไทรย้อย อ.เด่นชัย', NULL, 175, '54110', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2203, '67319090042', '905b9ae045006e73d022763d02fe78d3ba8c7dea', 'นางสาว', 'ธัญลักษณ์', 'ลำใย', NULL, 'Aink24474@gmail.com', NULL, '0947141457', NULL, 'บ้านปงหัวหาด หมู่6 ต.บ้านปง อ.สูงเม่น จ.แพร่', NULL, 175, '54130', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2204, '67319090043', 'd84313fe133653301cb9cf3923c43bdbb1ef4ebd', 'นาย', 'อภิชาติ', 'สุสินทร์', NULL, 'apichat065375@gmail.com', NULL, '0926080618', NULL, '142 ห.8 อ.ลอง จ.แพร่ ต.บ้านใหม่ศรีล้อม', NULL, 175, '54150', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2208, '67319090067', 'ae19db7228a4cfad113b8f15045e881494acdb90', 'นาย', 'พงษ์ศกร', 'อินต๊ะนาค', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2207, '67319090044', '5059370e678c11cb7c7917a24beb88cb6de44a94', 'นาย', 'กีรติ', 'นิ่มบุญ', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2205, '67319090066', 'e4a7d04d86e0e81652ef8a329de6c01f22a9439b', 'นาย', 'รัฐภูมิ', 'เปียงอ้น', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2209, '67319090045', 'ee9aba67be2f77939edf7f774b4b5170aa0271d4', 'นาย', 'อนุวัฒน์', 'ท่วงที', NULL, '', NULL, '0931533815', NULL, '22/4 ม.6ต.น้ำชำอ.สูงเม่น', NULL, 175, '54000', NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, ''),
(2231, '67319090068', 'f77d4e5e2185ecb588d8cb577ee89b49c1cb69cf', 'นาย', 'ศิวกร', 'เอี่ยมพักตร์', NULL, NULL, NULL, '', NULL, NULL, NULL, 0, NULL, NULL, '', 0, '', '1', '0000-00-00', '', '', '', '', '', '', 'student', 0, '');

-- --------------------------------------------------------

--
-- Table structure for table `teacher_info`
--

CREATE TABLE `teacher_info` (
  `teacher_id` int(11) NOT NULL,
  `prefix` varchar(10) DEFAULT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `department` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='เก็บข้อมูลครูผู้สอน';

--
-- Indexes for dumped tables
--

--
-- Indexes for table `course_information`
--
ALTER TABLE `course_information`
  ADD PRIMARY KEY (`courseid`),
  ADD KEY `FK_group_information_TO_course_information` (`infoid`),
  ADD KEY `FK_subject_TO_course_information` (`subject_id`);

--
-- Indexes for table `create_study_table`
--
ALTER TABLE `create_study_table`
  ADD PRIMARY KEY (`field_id`),
  ADD KEY `FK_teacher_info_TO_create_study_table` (`teacher_id`),
  ADD KEY `FK_room_TO_create_study_table` (`room_id`),
  ADD KEY `FK_course_information_TO_create_study_table` (`courseid`);

--
-- Indexes for table `group_information`
--
ALTER TABLE `group_information`
  ADD PRIMARY KEY (`infoid`),
  ADD KEY `FK_study_plans_TO_group_information` (`planid`);

--
-- Indexes for table `more_plan`
--
ALTER TABLE `more_plan`
  ADD PRIMARY KEY (`more_id`),
  ADD KEY `fk_planid` (`planid`),
  ADD KEY `fk_infoid` (`infoid`);

--
-- Indexes for table `room`
--
ALTER TABLE `room`
  ADD PRIMARY KEY (`room_id`);

--
-- Indexes for table `study_plans`
--
ALTER TABLE `study_plans`
  ADD PRIMARY KEY (`planid`);

--
-- Indexes for table `subject`
--
ALTER TABLE `subject`
  ADD PRIMARY KEY (`subject_id`),
  ADD KEY `FK_study_plans_TO_subject` (`planid`);

--
-- Indexes for table `tb_member`
--
ALTER TABLE `tb_member`
  ADD PRIMARY KEY (`member_id`);

--
-- Indexes for table `teacher_info`
--
ALTER TABLE `teacher_info`
  ADD PRIMARY KEY (`teacher_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `course_information`
--
ALTER TABLE `course_information`
  MODIFY `courseid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=361;

--
-- AUTO_INCREMENT for table `create_study_table`
--
ALTER TABLE `create_study_table`
  MODIFY `field_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `group_information`
--
ALTER TABLE `group_information`
  MODIFY `infoid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=507;

--
-- AUTO_INCREMENT for table `more_plan`
--
ALTER TABLE `more_plan`
  MODIFY `more_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `room`
--
ALTER TABLE `room`
  MODIFY `room_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `study_plans`
--
ALTER TABLE `study_plans`
  MODIFY `planid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=106;

--
-- AUTO_INCREMENT for table `subject`
--
ALTER TABLE `subject`
  MODIFY `subject_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=427;

--
-- AUTO_INCREMENT for table `tb_member`
--
ALTER TABLE `tb_member`
  MODIFY `member_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22125;

--
-- AUTO_INCREMENT for table `teacher_info`
--
ALTER TABLE `teacher_info`
  MODIFY `teacher_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `course_information`
--
ALTER TABLE `course_information`
  ADD CONSTRAINT `FK_group_information_TO_course_information` FOREIGN KEY (`infoid`) REFERENCES `group_information` (`infoid`),
  ADD CONSTRAINT `FK_subject_TO_course_information` FOREIGN KEY (`subject_id`) REFERENCES `subject` (`subject_id`);

--
-- Constraints for table `create_study_table`
--
ALTER TABLE `create_study_table`
  ADD CONSTRAINT `FK_course_information_TO_create_study_table` FOREIGN KEY (`courseid`) REFERENCES `course_information` (`courseid`),
  ADD CONSTRAINT `FK_room_TO_create_study_table` FOREIGN KEY (`room_id`) REFERENCES `room` (`room_id`),
  ADD CONSTRAINT `FK_teacher_info_TO_create_study_table` FOREIGN KEY (`teacher_id`) REFERENCES `teacher_info` (`teacher_id`);

--
-- Constraints for table `group_information`
--
ALTER TABLE `group_information`
  ADD CONSTRAINT `FK_study_plans_TO_group_information` FOREIGN KEY (`planid`) REFERENCES `study_plans` (`planid`);

--
-- Constraints for table `more_plan`
--
ALTER TABLE `more_plan`
  ADD CONSTRAINT `fk_infoid` FOREIGN KEY (`infoid`) REFERENCES `group_information` (`infoid`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_planid` FOREIGN KEY (`planid`) REFERENCES `study_plans` (`planid`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `subject`
--
ALTER TABLE `subject`
  ADD CONSTRAINT `FK_study_plans_TO_subject` FOREIGN KEY (`planid`) REFERENCES `study_plans` (`planid`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
