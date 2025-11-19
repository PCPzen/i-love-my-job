import React from "react";
import * as LucideIcons from "lucide-react";
import { Link, useNavigate, useLocation } from "react-router-dom";
import Swal from "sweetalert2";

// ฟังก์ชันสำหรับเปิด/ปิด Sidebar บน Mobile
function toggleSidebar() {
  const sidebar = document.getElementById("sidebar");
  sidebar.classList.toggle("hidden");
}

function Sidebar() {
  const navigate = useNavigate();
  const location = useLocation();

  // ฟังก์ชันเช็ค path ปัจจุบันสำหรับ active link
  const isActive = (paths = []) => {
    // ถ้า paths ไม่ใช่ array ให้แปลงเป็น array ก่อน
    const checkPaths = Array.isArray(paths) ? paths : [paths];
    // เช็คว่า path ปัจจุบันขึ้นต้นด้วย path ใด path หนึ่งใน array หรือไม่
    return checkPaths.some((path) => location.pathname.startsWith(path));
  };

  // ฟังก์ชันออกจากระบบ
  const handleLogout = () => {
    Swal.fire({
      title: "ยืนยันการออกจากระบบ",
      text: "คุณต้องการออกจากระบบใช่หรือไม่?",
      icon: "question",
      showCancelButton: true,
      confirmButtonColor: "#3085d6",
      cancelButtonColor: "#d33",
      confirmButtonText: "ออกจากระบบ",
      cancelButtonText: "ยกเลิก",
      reverseButtons: true,
    }).then((result) => {
      if (result.isConfirmed) {
        Swal.fire({
          title: "กำลังออกจากระบบ...",
          timer: 800,
          timerProgressBar: true,
          showConfirmButton: false,
          willClose: () => {
            // ล้างข้อมูลที่เกี่ยวข้องทั้งหมด
            localStorage.removeItem("token");
            localStorage.removeItem("rememberMe");
            localStorage.removeItem("savedUsername");
            localStorage.removeItem("savedPassword");
            sessionStorage.clear();
            navigate("/"); // ไปหน้า Login หรือหน้าหลัก
          },
        });
      }
    });
  };

  // CSS classes สำหรับ Link
  const linkBaseClasses =
    "flex items-center p-2 rounded-md hover:bg-white/20 transition duration-200";
  const linkActiveClasses = "bg-white/20 font-semibold";
  const linkInactiveClasses = "";

  return (
    <>
      {/* ---------- Sidebar ---------- */}
      <div
        id="sidebar"
        className="w-64 bg-[#3E3269] text-white p-4 flex flex-col h-screen fixed lg:block z-50 shadow-lg" // เพิ่ม shadow
      >
        <h2 className="text-xl font-bold text-center mb-4 tracking-wider">CPSS</h2> {/* ปรับ title */}
        <hr className="border-gray-500 mb-4" /> {/* ปรับระยะห่าง */}
        {/* ---------- หมวดจัดการแผนการเรียน ---------- */}
        <span className="text-xs uppercase text-gray-400 font-semibold px-2 mb-2 block">
          จัดการแผนการเรียน
        </span>
        <ul className="flex flex-col space-y-1 mb-4"> {/* ลด space-y */}
          {/* ข้อมูลหลักสูตร */}
          <li>
            <Link
              to="/createstudyplan"
              className={`${linkBaseClasses} ${
                // ทำให้ Active เมื่ออยู่หน้า createstudyplan, courseinfo, courseadd
                isActive(["/createstudyplan", "/courseinfo", "/courseadd"])
                  ? linkActiveClasses
                  : linkInactiveClasses
              }`}
            >
              <LucideIcons.BookOpen className="w-5 h-5 mr-2" />
              ข้อมูลหลักสูตร
            </Link>
          </li>
          {/* ดูโครงสร้าง */}
          <li>
            <Link
              to="/intomohou"
              className={`${linkBaseClasses} ${
                // ทำให้ Active เมื่ออยู่หน้า intomohou, redirectmohou
                isActive(["/intomohou", "/redirectmohou"])
                  ? linkActiveClasses
                  : linkInactiveClasses
              }`}
            >
              <LucideIcons.LayoutDashboard className="w-5 h-5 mr-2" />
              ดูโครงสร้างแผน
            </Link>
          </li>
          {/* กลุ่มเรียน */}
          <li>
            <Link
              to="/intogroupinfo"
              className={`${linkBaseClasses} ${
                // ทำให้ Active เมื่ออยู่หน้า intogroupinfo, groupinfo
                isActive(["/intogroupinfo", "/groupinfo"])
                  ? linkActiveClasses
                  : linkInactiveClasses
              }`}
            >
              <LucideIcons.Users className="w-5 h-5 mr-2" />
              ข้อมูลกลุ่มเรียน
            </Link>
          </li>
          {/* สร้างแผนการเรียน */}
          <li>
            <Link
              to="/intoplan"
              className={`${linkBaseClasses} ${
                // ทำให้ Active เมื่ออยู่หน้า intoplan, plan, add-subject
                isActive(["/intoplan", "/plan", "/add-subject"])
                  ? linkActiveClasses
                  : linkInactiveClasses
              }`}
            >
              <LucideIcons.FilePlus className="w-5 h-5 mr-2" />
              สร้างแผนการเรียน
            </Link>
          </li>
          {/* พิมพ์แผนการเรียน */}
          <li>
            <Link
              to="/intoprintplan"
              className={`${linkBaseClasses} ${
                // ทำให้ Active เมื่ออยู่หน้า intoprintplan, printplan
                isActive(["/intoprintplan", "/printplan"])
                  ? linkActiveClasses
                  : linkInactiveClasses
              }`}
            >
              <LucideIcons.Printer className="w-5 h-5 mr-2" />
              พิมพ์แผนการเรียน
            </Link>
          </li>
        </ul>

        <hr className="border-gray-500 my-4" />

        {/* ---------- หมวดสร้างตารางเรียน ---------- */}
        <span className="text-xs uppercase text-gray-400 font-semibold px-2 mb-2 block">
          สร้างตารางเรียน
        </span>
        <ul className="flex flex-col space-y-1 flex-grow"> {/* ลด space-y */}
          {/* (ย้ายมา) เพิ่มหมวดหมู่ */}
   
          {/* (ย้ายมา) เพิ่มครูผู้สอน */}
          <li>
            <Link
              to="/Teacheradd" // ! (เปลี่ยน Path ตรงนี้ตาม Route ของคุณ)
              className={`${linkBaseClasses} ${
                isActive("/Teacheradd") ? linkActiveClasses : linkInactiveClasses
              }`}
            >
              <LucideIcons.UserPlus className="w-5 h-5 mr-2" />
              เพิ่มครูผู้สอน
            </Link>
          </li>
          {/* (ย้ายมา) เพิ่มห้องเรียน */}
          <li>
            <Link
              to="/Studentroomadd" // ! (เปลี่ยน Path ตรงนี้ตาม Route ของคุณ)
              className={`${linkBaseClasses} ${
                isActive("/Studentroomadd") ? linkActiveClasses : linkInactiveClasses
              }`}
            >
              <LucideIcons.Building2 className="w-5 h-5 mr-2" />
              เพิ่มห้องเรียน
            </Link>
          </li>

          {/* (ของเดิม) ข้อมูลตารางเรียน */}
          <li>
            <Link
              to="/talangplan" // Path สำหรับดูข้อมูลตารางเรียน
              className={`${linkBaseClasses} ${
                isActive("/talangplan") ? linkActiveClasses : linkInactiveClasses
              }`}
            >
              <LucideIcons.Database className="w-5 h-5 mr-2" />
              ข้อมูลตารางเรียน
            </Link>
          </li>
          {/* (ของเดิม) จัดตารางเรียนใหม่ */}
          <li>
            <Link
              to="/talangstudy" // Path สำหรับสร้างตารางเรียน
              className={`${linkBaseClasses} ${
                isActive("/talangstudy") ? linkActiveClasses : linkInactiveClasses
              }`}
            >
              <LucideIcons.CalendarPlus className="w-5 h-5 mr-2" />
              จัดตารางเรียนใหม่
            </Link>
          </li>
          {/* สามารถเพิ่มเมนู "ดูตารางเรียนทั้งหมด" ตรงนี้ได้ */}
          {/* <li>
              <Link
                to="/scheduleview" // Path สมมติสำหรับดูตารางทั้งหมด
                className={`${linkBaseClasses} ${isActive("/scheduleview") ? linkActiveClasses : linkInactiveClasses}`}
              >
                <LucideIcons.CalendarDays className="w-5 h-5 mr-2" />
                ดูตารางเรียนทั้งหมด
              </Link>
            </li> */}
        </ul>

        {/* ---------- ปุ่ม Logout ---------- */}
        <div className="mt-auto"> {/* ดัน Logout ไปล่างสุด */}
          <hr className="border-gray-500 my-4" />
          <button
            onClick={handleLogout}
            className={`${linkBaseClasses} w-full`}
          >
            <LucideIcons.LogOut className="w-5 h-5 mr-2" />
            <strong>ออกจากระบบ</strong>
          </button>
        </div>
      </div>

      {/* ---------- ปุ่มเปิด/ปิด sidebar (มือถือ) ---------- */}
      <button
        onClick={toggleSidebar}
        className="lg:hidden fixed top-4 left-4 bg-[#3E3269] text-white p-2 rounded-md z-[60] shadow-md" // เพิ่ม z-index และ shadow
      >
        <LucideIcons.Menu size={20} /> {/* ใช้ไอคอน Menu */}
      </button>
    </>
  );
}

export default Sidebar;