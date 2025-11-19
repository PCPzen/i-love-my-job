import { Routes, Route, Navigate } from "react-router-dom";

// Pages (ชื่อไฟล์ต้องตรง / default export ต้องมี)
import TalangStudy from "./Page/Talangstudy"; // แก้ path ให้ตรง case sensitive (ถ้าไฟล์จริงชื่อ Talangstudy.jsx)
import TalangPrint from "./Page/TalangPrint";
import Teacheradd from "./Page/Teacheradd";
import TalangPlan from "./Page/Talangplan";
import LoginPage from "./Page/LoginPage";
import Createstudyplan from "./Page/Createstudyplan";
import Groupinfo from "./Page/Groupinfo";
import StudyPlan from "./Page/study-plan";
import Plan from "./Page/plan";
import Plansubject from "./Page/add-subject";
import Intogroupinfo from "./Page/Intogroupinfo";
import Intoplan from "./Page/Intoplan";
import Intoprintplan from "./Page/intoprintplan";
import Printplan from "./Page/printplan";
import Courseinfo from "./Page/Courseinfo";
import Courseadd from "./Page/Courseadd";
import Redirectmohou from "./Page/Redirectmohou";
import Intomohou from "./Page/Intomohou";

// *** เพิ่มบรรทัดนี้ เพื่อแก้ Error ReferenceError ***
import Studentroomadd from "./Page/Studentroomadd"; 

export default function App() {
  return (
    <Routes>
      {/* default: ไปหน้า courseinfo */}
      <Route path="/" element={<Navigate to="/courseinfo" replace />} />

      {/* ใช้ path เป็นตัวพิมพ์เล็กทั้งหมด */}
      <Route path="/studentroomadd" element={<Studentroomadd />} />
      <Route path="/talangprint" element={<TalangPrint />} />
      <Route path="/teacheradd" element={<Teacheradd />} />
      <Route path="/loginpage" element={<LoginPage />} />
      <Route path="/courseinfo" element={<Courseinfo />} />
      <Route path="/courseinfo/:planid" element={<Courseinfo />} />
      <Route path="/courseadd" element={<Courseadd />} />
      <Route path="/createstudyplan" element={<Createstudyplan />} />
      <Route path="/groupinfo/:planid" element={<Groupinfo />} />
      <Route path="/study-plan/:planid" element={<StudyPlan />} />
      <Route path="/plan/:infoid" element={<Plan />} />
      <Route path="/add-subject" element={<Plansubject />} />
      <Route path="/intogroupinfo" element={<Intogroupinfo />} />
      <Route path="/intoplan" element={<Intoplan />} />
      <Route path="/intoprintplan" element={<Intoprintplan />} />
      <Route path="/printplan" element={<Printplan />} />
      <Route path="/intomohou" element={<Intomohou />} />
      <Route path="/redirectmohou/:planid" element={<Redirectmohou />} />

      {/* ตารางเรียน */}
      <Route path="/talangstudy" element={<TalangStudy />} />
      <Route path="/talangplan" element={<TalangPlan />} />

      {/* 404 */}
      <Route path="*" element={<h1 style={{textAlign:"center",marginTop:50}}>404 - ไม่พบหน้า</h1>} />
    </Routes>
  );
}