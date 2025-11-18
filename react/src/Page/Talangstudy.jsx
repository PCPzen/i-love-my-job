// src/Page/talangstudy.jsx
import React, { useEffect, useRef, useState } from 'react';
import axios from 'axios';
import Sidebar from '../components/Sidebar';

const API = import.meta.env.VITE_API_URL || 'http://localhost/CPSS/api';

export default function ScheduleCreate() {
  const ran = useRef(false);
  const [loading, setLoading] = useState(true);
  const [groups, setGroups] = useState([]);
  const [subjects, setSubjects] = useState([]);
  const [teachers, setTeachers] = useState([]);
  const [rooms, setRooms] = useState([]);
  const [times, setTimes] = useState([]);

  const [form, setForm] = useState({
    term: '', year: '',
    group_id: '', subject_id: '',
    teacher_id: '', room_id: '',
    day_of_week: '', timeslot_id: ''
  });

  useEffect(() => {
    if (ran.current) return;
    ran.current = true;
    const ctrl = new AbortController();

    (async () => {
      try {
        const [g, s, t, r, tm] = await Promise.all([
          axios.get(`${API}/get_groups.php`, { signal: ctrl.signal }),
          axios.get(`${API}/get_subjects.php`, { signal: ctrl.signal }),
          axios.get(`${API}/get_teachers.php`, { signal: ctrl.signal }),
          axios.get(`${API}/get_rooms.php`, { signal: ctrl.signal }),
          axios.get(`${API}/get_timeslots.php`, { signal: ctrl.signal }),
        ]);
        setGroups(g.data || []);
        setSubjects(s.data || []);
        setTeachers(t.data || []);
        setRooms(r.data || []);
        setTimes(tm.data || []);
      } catch (e) {
        console.error(e);
        alert('โหลดข้อมูลพื้นฐานไม่สำเร็จ');
      } finally {
        setLoading(false);
      }
    })();

    return () => ctrl.abort();
  }, []);

  const onChange = (e) => setForm({ ...form, [e.target.name]: e.target.value });

  const onSubmit = async (e) => {
    e.preventDefault();
    try {
      const res = await axios.post(`${API}/save_schedule.php`, form);
      if (res.data?.success) {
        alert('บันทึกสำเร็จ');
        setForm({
          term: '', year: '',
          group_id: '', subject_id: '',
          teacher_id: '', room_id: '',
          day_of_week: '', timeslot_id: ''
        });
      } else {
        alert(res.data?.message || 'บันทึกล้มเหลว');
      }
    } catch (e) {
      console.error(e);
      alert('เชื่อมต่อเซิร์ฟเวอร์ไม่ได้');
    }
  };

  if (loading) return <div className="p-6">กำลังโหลดข้อมูล…</div>;

  // ✅ ตรงนี้คือ return ที่อยู่ในฟังก์ชัน
  return (
    <div className="min-h-screen flex bg-gray-50">
      <Sidebar />
      <main className="flex-1 lg:ml-64 flex justify-center p-6">
        <div className="w-full max-w-3xl">
          <h1 className="text-2xl font-semibold text-[#3E3269] mb-4">สร้างตารางเรียน</h1>
          <form onSubmit={onSubmit} className="grid gap-4">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
              <input className="border p-2 rounded" name="year" placeholder="ปีการศึกษา (เช่น 2568)" value={form.year} onChange={onChange} required />
              <input className="border p-2 rounded" name="term" placeholder="ภาคเรียน (เช่น 1/2568)" value={form.term} onChange={onChange} required />
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
              <select className="border p-2 rounded" name="group_id" value={form.group_id} onChange={onChange} required>
                <option value="">-- เลือกกลุ่มเรียน --</option>
                {groups.map(g => <option key={g.id} value={g.id}>{g.name}</option>)}
              </select>

              <select className="border p-2 rounded" name="subject_id" value={form.subject_id} onChange={onChange} required>
                <option value="">-- เลือกรายวิชา --</option>
                {subjects.map(s => <option key={s.id} value={s.id}>{s.code} - {s.name}</option>)}
              </select>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
              <select className="border p-2 rounded" name="teacher_id" value={form.teacher_id} onChange={onChange} required>
                <option value="">-- เลือกอาจารย์ --</option>
                {teachers.map(t => <option key={t.id} value={t.id}>{t.name}</option>)}
              </select>

              <select className="border p-2 rounded" name="room_id" value={form.room_id} onChange={onChange} required>
                <option value="">-- เลือกห้องเรียน --</option>
                {rooms.map(r => <option key={r.id} value={r.id}>{r.name} (ความจุ {r.capacity})</option>)}
              </select>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
              <select className="border p-2 rounded" name="day_of_week" value={form.day_of_week} onChange={onChange} required>
                <option value="">-- เลือกวัน --</option>
                <option value="1">จันทร์</option>
                <option value="2">อังคาร</option>
                <option value="3">พุธ</option>
                <option value="4">พฤหัสบดี</option>
                <option value="5">ศุกร์</option>
                <option value="6">เสาร์</option>
                <option value="0">อาทิตย์</option>
              </select>

              <select className="border p-2 rounded" name="timeslot_id" value={form.timeslot_id} onChange={onChange} required>
                <option value="">-- เลือกช่วงเวลา --</option>
                {times.map(t => <option key={t.id} value={t.id}>{t.label} ({t.start_time}–{t.end_time})</option>)}
              </select>
            </div>

            <button className="bg-[#3E3269] text-white px-4 py-2 rounded hover:opacity-90">
              บันทึกตาราง
            </button>
          </form>
        </div>
      </main>
    </div>
  );
}
