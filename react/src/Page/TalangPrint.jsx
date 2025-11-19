import React, { useEffect, useRef, useState } from 'react';
import axios from 'axios';
import Sidebar from '../components/Sidebar';

// ตรวจสอบให้แน่ใจว่า API URL ถูกต้อง
const API = import.meta.env.VITE_API_URL || 'http://localhost/CPSS/server/api';

// ฟังก์ชันสำหรับจัดรูปแบบข้อมูลที่ได้จาก API ให้อยู่ในรูปตาราง
const formatScheduleData = (data, timeslots) => {
  // สร้างตารางเปล่าๆ ตามโครงสร้าง [คาบ][วัน]
  const grid = {};
  timeslots.forEach(slot => {
    grid[slot.id] = {
      "จันทร์": null, "อังคาร": null, "พุธ": null, "พฤหัสบดี": null, "ศุกร์": null, "เสาร์": null, "อาทิตย์": null
    };
  });

  // นำข้อมูลที่ได้จาก API มาใส่ในตาราง
  data.forEach(item => {
    // หาว่า start_time นี้ ตรงกับ timeslot_id ไหน
    const timeslot = timeslots.find(slot => slot.start_time_int === item.start_time);
    if (timeslot && grid[timeslot.id]) {
      grid[timeslot.id][item.date] = item;
    }
  });
  return grid;
};

export default function TalangPrint() {
  const [loading, setLoading] = useState(false);
  
  // State สำหรับเก็บข้อมูลใน Dropdown
  const [plans, setPlans] = useState([]); // แผนก (study_plans)
  const [levels, setLevels] = useState([]); // ระดับชั้น (sublevel)
  const [groups, setGroups] = useState([]); // กลุ่ม (group_name)
  const [timeslots, setTimeslots] = useState([]); // คาบเวลา

  // State สำหรับเก็บค่าที่เลือก
  const [selected, setSelected] = useState({
    planid: '',
    sublevel: '',
    infoid: '', // นี่คือ group_id ที่เราจะส่งไป
    term: '',
    year: ''
  });

  // State สำหรับเก็บข้อมูลตารางเรียนที่จะแสดง
  const [scheduleData, setScheduleData] = useState({});

  // 1. ดึงข้อมูลแผนก (study_plans) และ คาบเวลา (timeslots)
  useEffect(() => {
    const fetchData = async () => {
      try {
        const [planRes, timeRes] = await Promise.all([
          axios.get(`${API}/GET/Getstudyplan.php`),
          axios.get(`${API}/GET/get_timeslots.php`) // (ต้องสร้าง API นี้)
        ]);
        setPlans(planRes.data || []);
        
        // แปลงเวลาเป็น Int เพื่อเทียบกับ DB
        const slotsWithIntTime = timeRes.data.map(slot => ({
          ...slot,
          start_time_int: parseInt(slot.start_time.replace(':', ''), 10)
        }));
        setTimeslots(slotsWithIntTime || []);
        
      } catch (e) {
        console.error("Failed to fetch initial data", e);
      }
    };
    fetchData();
  }, []);

  // 2. ดึงระดับชั้น เมื่อเลือกแผนก
  useEffect(() => {
    if (!selected.planid) {
      setLevels([]);
      setGroups([]);
      setSelected(s => ({ ...s, sublevel: '', infoid: '' }));
      return;
    }
    const fetchLevels = async () => {
      try {
        // (เราต้องสร้าง API นี้ เพื่อดึง sublevel ที่ไม่ซ้ำกัน)
        const res = await axios.get(`${API}/GET/get_levels_by_plan.php?planid=${selected.planid}`);
        setLevels(res.data || []);
      } catch (e) {
        console.error("Failed to fetch levels", e);
      }
    };
    fetchLevels();
  }, [selected.planid]);

  // 3. ดึงกลุ่ม เมื่อเลือกระดับชั้น (นี่คือส่วนที่คุณต้องการ)
  useEffect(() => {
    if (!selected.sublevel || !selected.planid) {
      setGroups([]);
      setSelected(s => ({ ...s, infoid: '' }));
      return;
    }
    const fetchGroups = async () => {
      try {
        // API นี้จะดึงกลุ่มทั้งหมดที่ตรงกับ แผนก และ ระดับชั้น
        // ซึ่งจะรวม "กลุ่ม 1", "กลุ่ม 2", และ "กลุ่ม 1-2" ถ้ามีใน DB
        const res = await axios.get(`${API}/GET/get_groups_by_level.php?planid=${selected.planid}&sublevel=${selected.sublevel}`);
        setGroups(res.data || []);
      } catch (e) {
        console.error("Failed to fetch groups", e);
      }
    };
    fetchGroups();
  }, [selected.planid, selected.sublevel]);


  const handleChange = (e) => {
    const { name, value } = e.target;
    setSelected(prev => ({
      ...prev,
      [name]: value
    }));
  };

  // 4. ฟังก์ชันค้นหา
  const handleSearch = async (e) => {
    e.preventDefault();
    setLoading(true);
    try {
      const { infoid, term, year } = selected;
      if (!infoid || !term || !year) {
        alert("กรุณาเลือกข้อมูลให้ครบ (กลุ่ม, ภาคเรียน, ปีการศึกษา)");
        setLoading(false);
        return;
      }
      
      const res = await axios.get(`${API}/GET/GetPrintSchedule.php?infoid=${infoid}&term=${term}&year=${year}`);
      
      if (res.data.status === 'error') {
        alert(res.data.message);
        setScheduleData({});
      } else {
        // จัดรูปแบบข้อมูลที่ได้มาใหม่
        const formattedData = formatScheduleData(res.data, timeslots);
        setScheduleData(formattedData);
      }
    } catch (e) {
      console.error("Failed to fetch schedule", e);
      alert("เกิดข้อผิดพลาดในการดึงข้อมูลตารางเรียน");
      setScheduleData({});
    } finally {
      setLoading(false);
    }
  };

  // 5. ฟังก์ชันพิมพ์
  const handlePrint = () => {
    window.print();
  };
  
  const days = ["จันทร์", "อังคาร", "พุธ", "พฤหัสบดี", "ศุกร์", "เสาร์", "อาทิตย์"];

  return (
    <div className="min-h-screen flex bg-gray-50">
      <Sidebar />
      <main className="flex-1 lg:ml-64 p-6 print-content">
        
        {/* ส่วนที่ 1: ตัวเลือก (จะถูกซ่อนตอนพิมพ์) */}
        <div className="w-full max-w-6xl mx-auto p-4 bg-white rounded-lg shadow no-print">
          <h1 className="text-2xl font-semibold text-[#3E3269] mb-4">พิมพ์ตารางเรียน</h1>
          <form onSubmit={handleSearch} className="grid grid-cols-1 md:grid-cols-6 gap-3">
            
            <select name="planid" value={selected.planid} onChange={handleChange} className="border p-2 rounded md:col-span-2">
              <option value="">-- เลือกแผนก --</option>
              {plans.map(p => <option key={p.planid} value={p.planid}>{p.course} {p.year}</option>)}
            </select>
            
            <select name="sublevel" value={selected.sublevel} onChange={handleChange} className="border p-2 rounded" disabled={!selected.planid}>
              <option value="">-- เลือกระดับชั้น --</option>
              {levels.map(l => <option key={l.sublevel} value={l.sublevel}>{l.sublevel}</option>)}
            </select>

            {/* นี่คือ Dropdown ที่คุณต้องการ */}
            <select name="infoid" value={selected.infoid} onChange={handleChange} className="border p-2 rounded" disabled={!selected.sublevel}>
              <option value="">-- เลือกกลุ่ม --</option>
              {groups.map(g => <option key={g.infoid} value={g.infoid}>กลุ่ม {g.group_name}</option>)}
            </select>

            <input type="text" name="term" value={selected.term} onChange={handleChange} placeholder="ภาคเรียน (เช่น 1)" className="border p-2 rounded" />
            <input type="text" name="year" value={selected.year} onChange={handleChange} placeholder="ปีการศึกษา (เช่น 2567)" className="border p-2 rounded" />

            <button type="submit" className="bg-[#3E3269] text-white px-4 py-2 rounded hover:opacity-90 md:col-span-3">
              {loading ? 'กำลังค้นหา...' : 'ค้นหา'}
            </button>
            <button type="button" onClick={handlePrint} className="bg-green-600 text-white px-4 py-2 rounded hover:opacity-90 md:col-span-3">
              พิมพ์
            </button>
          </form>
        </div>

        {/* ส่วนที่ 2: ตาราง (จะแสดงเต็มหน้าตอนพิมพ์) */}
        <div className="printable-area mt-6">
          <div className="text-center mb-4">
            <h2 className="text-xl font-bold">ตารางเรียน</h2>
            {/* คุณสามารถเพิ่ม Header ที่นี่ (เช่น ชื่อแผนก, กลุ่ม, ปีการศึกษา) */}
          </div>
          
          <table className="min-w-full border-collapse border border-gray-400">
            <thead>
              <tr className="bg-gray-200">
                <th className="border border-gray-300 p-2 w-1/12">คาบที่</th>
                <th className="border border-gray-300 p-2 w-1/12">เวลา</th>
                {days.map(day => (
                  <th key={day} className="border border-gray-300 p-2">{day}</th>
                ))}
              </tr>
            </thead>
            <tbody>
              {timeslots.map((slot, index) => (
                <tr key={slot.id}>
                  <td className="border border-gray-300 p-2 text-center">{index + 1}</td>
                  <td className="border border-gray-300 p-2 text-center text-sm">{slot.start_time}-{slot.end_time}</td>
                  
                  {days.map(day => {
                    const item = scheduleData[slot.id] ? scheduleData[slot.id][day] : null;
                    return (
                      <td key={day} className="border border-gray-300 p-2 text-xs h-24 align-top">
                        {item ? (
                          <div>
                            <div className="font-bold">{item.course_code}</div>
                            <div>{item.course_name}</div>
                            <div className="text-blue-600">{item.first_name} {item.last_name}</div>
                            <div className="text-green-700">({item.room_name})</div>
                          </div>
                        ) : (
                          <span>&nbsp;</span> // ว่าง
                        )}
                      </td>
                    );
                  })}
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </main>
    </div>
  );
}