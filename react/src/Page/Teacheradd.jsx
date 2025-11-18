import React, { useState, useEffect } from "react";
import { UserPlus, Users, RefreshCw } from "lucide-react";
import Sidebar from "../components/Sidebar.jsx";
import axios from "axios";

function Teacheradd() {
  const [formData, setFormData] = useState({
    prefix: "อ.",
    first_name: "",
    last_name: "",
    department: "", // แผนกวิชา
    email: "",
    phone: "",
  });

  const [teachers, setTeachers] = useState([]); // เก็บข้อมูลครูสำหรับตาราง
  const [isLoading, setIsLoading] = useState(false);
  const [isFetching, setIsFetching] = useState(false); // Loading สำหรับตาราง
  const [message, setMessage] = useState(null);

  // URL ของ API
  const API_BASE_URL = import.meta.env.VITE_API_BASE_URL;
  
  console.log("Debug URL:", `${API_BASE_URL}/api/GET/get_teachers.php`); // <-- เพิ่มบรรทัดนี้
  
  

  // ดึงข้อมูลครูเมื่อ Component โหลด
  useEffect(() => {
    fetchTeachers();
      console.log("Debug URL:", `${API_BASE_URL}/api/GET/get_teachers.php`);
        
  }, []);

  
  // ฟังก์ชันดึงข้อมูลครู
  const fetchTeachers = async () => {
    setIsFetching(true);
    try {
      const response = await axios.get(`${API_BASE_URL}/api/GET/get_teachers.php`);
      if (Array.isArray(response.data)) {
        setTeachers(response.data);
      } else {
        console.error("Format ข้อมูลไม่ถูกต้อง:", response.data);
      }
    } catch (error) {
      console.error("Error fetching teachers:", error);
    } finally {
      setIsFetching(false);
    }
  };

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData((prevState) => ({ ...prevState, [name]: value }));
  };

  const showMessage = (type, text) => {
    setMessage({ type, text });
    setTimeout(() => {
      setMessage(null);
    }, 3000);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setIsLoading(true);
    setMessage(null);

    const apiUrl = `${API_BASE_URL}/api/POST/InsertTeacher.php`;

    try {
      const response = await axios.post(apiUrl, formData, {
        headers: {
          "Content-Type": "application/json",
        },
      });

      if (response.data.status === "success") {
        showMessage("success", "ข้อมูลครูผู้สอนถูกเพิ่มในระบบแล้ว");

        // ล้างฟอร์ม
        setFormData({
          prefix: "อ.",
          first_name: "",
          last_name: "",
          department: "",
          email: "",
          phone: "",
        });

        // อัปเดตตารางทันทีหลังบันทึกสำเร็จ
        fetchTeachers();

      } else {
        showMessage("error", response.data.message || "ไม่สามารถบันทึกข้อมูลได้");
      }
    } catch (error) {
      console.error("Error submitting form:", error);
      showMessage("error", "ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้");
    } finally {
      setIsLoading(false);
    }
  };

  

  return (
    <div className="flex h-screen bg-gray-100">
      <Sidebar />

      <main className="flex-1 lg:ml-64 overflow-y-auto">
        <div className="container mx-auto px-4 py-8">
          
          {/* ส่วนหัวข้อ */}
          <div className="flex items-center gap-4 mb-6">
            <h1 className="text-3xl font-bold text-gray-800">
              เพิ่มข้อมูลครูผู้สอน
            </h1>
            <UserPlus className="w-8 h-8 text-blue-600" />
          </div>

          {/* ฟอร์มเพิ่มข้อมูล */}
          <div className="bg-white p-6 rounded-lg shadow-md mb-8">
            <h2 className="text-xl font-semibold text-gray-700 mb-4 border-b pb-2">
              กรอกข้อมูลครูใหม่
            </h2>

            {message && (
              <div
                className={`mb-4 p-4 rounded-md ${
                  message.type === "success"
                    ? "bg-green-100 text-green-800"
                    : "bg-red-100 text-red-800"
                }`}
                role="alert"
              >
                {message.text}
              </div>
            )}

            <form onSubmit={handleSubmit} className="space-y-4">
              <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div>
                  <label htmlFor="prefix" className="block text-sm font-medium text-gray-700">
                    คำนำหน้า <span className="text-red-500">*</span>
                  </label>
                  <select
                    name="prefix"
                    id="prefix"
                    value={formData.prefix}
                    onChange={handleChange}
                    className="mt-1 block w-full px-3 py-2 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500"
                  >
                    <option value="อ.">อาจารย์</option>
                    <option value="ผศ.">ผู้ช่วยศาสตราจารย์</option>
                    <option value="รศ.">รองศาสตราจารย์</option>
                    <option value="ศ.">ศาสตราจารย์</option>
                    <option value="ดร.">ด็อกเตอร์</option>
                    <option value="นาย">นาย</option>
                    <option value="นาง">นาง</option>
                    <option value="น.ส.">นางสาว</option>
                  </select>
                </div>
                <div className="md:col-span-1">
                  <label htmlFor="first_name" className="block text-sm font-medium text-gray-700">
                    ชื่อ <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="text"
                    name="first_name"
                    id="first_name"
                    value={formData.first_name}
                    onChange={handleChange}
                    className="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500"
                    required
                  />
                </div>
                <div className="md:col-span-1">
                  <label htmlFor="last_name" className="block text-sm font-medium text-gray-700">
                    นามสกุล <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="text"
                    name="last_name"
                    id="last_name"
                    value={formData.last_name}
                    onChange={handleChange}
                    className="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500"
                    required
                  />
                </div>
              </div>

              <div>
                <label htmlFor="department" className="block text-sm font-medium text-gray-700">
                  แผนกวิชา
                </label>
                <input
                  type="text"
                  name="department"
                  id="department"
                  value={formData.department}
                  onChange={handleChange}
                  className="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500"
                  placeholder="เช่น เทคโนโลยีสารสนเทศ, การบัญชี"
                />
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label htmlFor="email" className="block text-sm font-medium text-gray-700">
                    อีเมล
                  </label>
                  <input
                    type="email"
                    name="email"
                    id="email"
                    value={formData.email}
                    onChange={handleChange}
                    className="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500"
                    placeholder="example@email.com"
                  />
                </div>
                <div>
                  <label htmlFor="phone" className="block text-sm font-medium text-gray-700">
                    เบอร์โทรศัพท์
                  </label>
                  <input
                    type="tel"
                    name="phone"
                    id="phone"
                    value={formData.phone}
                    onChange={handleChange}
                    className="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500"
                    placeholder="08X-XXX-XXXX"
                  />
                </div>
              </div>

              <div className="flex justify-end pt-4">
                <button
                  type="submit"
                  className="px-6 py-2 bg-blue-600 text-white font-semibold rounded-md shadow-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition duration-200 disabled:bg-gray-400"
                  disabled={isLoading}
                >
                  {isLoading ? "กำลังบันทึก..." : "บันทึกข้อมูลครูผู้สอน"}
                </button>
              </div>
            </form>
          </div>

          {/* ส่วนแสดงตารางข้อมูลครู */}
          <div className="bg-white p-6 rounded-lg shadow-md">
            <div className="flex justify-between items-center mb-4 border-b pb-2">
              <div className="flex items-center gap-2">
                <Users className="w-6 h-6 text-blue-500" />
                <h2 className="text-xl font-semibold text-gray-700">
                  รายชื่อครูในระบบ
                </h2>
              </div>
              <button 
                onClick={fetchTeachers} 
                className="text-gray-500 hover:text-blue-600 transition-colors p-2 rounded-full hover:bg-gray-100"
                title="รีเฟรชข้อมูล"
              >
                <RefreshCw className={`w-5 h-5 ${isFetching ? 'animate-spin' : ''}`} />
              </button>
            </div>

            <div className="overflow-x-auto">
              <table className="min-w-full divide-y divide-gray-200">
                <thead className="bg-gray-50">
                  <tr>
                    <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      ชื่อ-นามสกุล
                    </th>
                    <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      แผนกวิชา
                    </th>
                    <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      ติดต่อ (โทร/อีเมล)
                    </th>
                  </tr>
                </thead>
                <tbody className="bg-white divide-y divide-gray-200">
                  {isFetching && teachers.length === 0 ? (
                    <tr>
                      <td colSpan="3" className="px-6 py-4 text-center text-gray-500">
                        กำลังโหลดข้อมูล...
                      </td>
                    </tr>
                  ) : teachers.length > 0 ? (
                    teachers.map((teacher) => (
                      <tr key={teacher.teacher_id} className="hover:bg-gray-50 transition-colors">
                        <td className="px-6 py-4 whitespace-nowrap">
                          <div className="text-sm font-medium text-gray-900">
                            {teacher.prefix} {teacher.first_name} {teacher.last_name}
                          </div>
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap">
                          <div className="text-sm text-gray-500">
                            {teacher.department || "-"}
                          </div>
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap">
                          <div className="text-sm text-gray-500 flex flex-col">
                            <span>{teacher.phone || "-"}</span>
                            <span className="text-xs text-gray-400">{teacher.email}</span>
                          </div>
                        </td>
                      </tr>
                    ))
                  ) : (
                    <tr>
                      <td colSpan="3" className="px-6 py-4 text-center text-gray-500">
                        ไม่พบข้อมูลครูในระบบ
                      </td>
                    </tr>
                  )}
                </tbody>
              </table>
            </div>
          </div>

        </div>
      </main>
    </div>
  );
}

export default Teacheradd;