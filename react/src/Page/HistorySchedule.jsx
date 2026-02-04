import React, { useState, useEffect } from 'react';
import Sidebar from '../components/Sidebar';
import axios from 'axios';
import { useNavigate } from 'react-router-dom';
import { Eye, Edit, Trash2 } from 'lucide-react';
import Swal from 'sweetalert2';

export default function HistorySchedule() {
    const navigate = useNavigate();

    const handleDelete = async (item) => {
        const result = await Swal.fire({
            title: 'ยืนยันการลบ?',
            text: "ข้อมูลตารางเรียนนี้จะถูกลบถาวร!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#3085d6',
            confirmButtonText: 'ใช่, ลบเลย!',
            cancelButtonText: 'ยกเลิก'
        });

        if (result.isConfirmed) {
            try {
                const response = await axios.post(`${import.meta.env.VITE_API_BASE_URL.replace(/\/+$/, '')}/api/Delete/DeleteScheduleHistory.php`, {
                    infoid: item.infoid,
                    term: item.term,
                    group: item.group_section // Pass group if available
                });

                if (response.data.status === 'success') {
                    Swal.fire('ลบสำเร็จ!', 'ข้อมูลถูกลบเรียบร้อยแล้ว.', 'success');
                    fetchHistory(); // Refresh list
                } else {
                    Swal.fire('เกิดข้อผิดพลาด', response.data.message || 'ไม่สามารถลบข้อมูลได้', 'error');
                }
            } catch (err) {
                console.error(err);
                Swal.fire('เกิดข้อผิดพลาด', 'เชื่อมต่อเซิร์ฟเวอร์ไม่ได้', 'error');
            }
        }
    };
    const [historyList, setHistoryList] = useState([]);
    const [selectedSchedule, setSelectedSchedule] = useState(null);
    const [scheduleData, setScheduleData] = useState({});
    const [loading, setLoading] = useState(false);

    // DAYS constant for rendering
    const DAYS = ["จันทร์", "อังคาร", "พุธ", "พฤหัสบดี", "ศุกร์"];

    // API Base URL
    const RAW_BASE = import.meta.env.VITE_API_BASE_URL;
    const BASE_URL = RAW_BASE ? RAW_BASE.replace(/\/+$/, '') : 'http://localhost/i-love-my-job-main/server';

    useEffect(() => {
        fetchHistory();
    }, []);

    const fetchHistory = async () => {
        try {
            const res = await axios.get(`${BASE_URL}/api/GET/GetHistoryList.php`);
            if (Array.isArray(res.data)) {
                console.log("DEBUG: History List (HistorySchedule):", res.data);
                setHistoryList(res.data);
            }
        } catch (err) {
            console.error("Error fetching history:", err);
        }
    };

    const handleSelectSchedule = async (item) => {
        setLoading(true);
        setSelectedSchedule(item);
        try {
            const res = await axios.get(`${BASE_URL}/api/GET/GetScheduleByInfo.php?infoid=${item.infoid}&term=${item.term}&group=${encodeURIComponent(item.group_section)}`);
            console.log("DEBUG: Selected Schedule Details:", res.data);
            if (res.data && Array.isArray(res.data.schedule)) {
                processScheduleData(res.data.schedule);
            } else if (Array.isArray(res.data)) {
                processScheduleData(res.data);
            }
        } catch (err) {
            console.error("Error fetching schedule:", err);
        } finally {
            setLoading(false);
        }
    };

    const processScheduleData = (rawData) => {
        // Transform flat DB rows into nested schedule object for rendering
        const newSchedule = {
            "จันทร์": {}, "อังคาร": {}, "พุธ": {}, "พฤหัสบดี": {}, "ศุกร์": {}
        };

        // 1. Group by Day + StartTime
        const grouped = {};
        rawData.forEach(row => {
            const key = `${row.date}-${row.start_time}`;
            if (!grouped[key]) grouped[key] = [];
            grouped[key].push(row);
        });

        // 2. Helper Map Time -> Period (Matches SaveTotalSchedule)
        const timeToPeriod = (timeInt) => {
            const t = parseInt(timeInt);
            // 800->1, 900->2, 1000->3... 1200->5? (Lunch?)
            // Based on SaveTotalSchedule:
            // 800->1, 900->2, 1000->3, 1100->4, 1300->5 ...
            if (t === 800) return 1;
            if (t === 900) return 2;
            if (t === 1000) return 3;
            if (t === 1100) return 4;
            if (t === 1200) return 5;
            if (t === 1300) return 5; // Standard afternoon start
            if (t === 1400) return 6;
            if (t === 1500) return 7;
            if (t === 1600) return 8;
            if (t === 1700) return 9;
            if (t === 1800) return 10;
            return 0;
        };

        Object.values(grouped).forEach(items => {
            const first = items[0];
            const startP = timeToPeriod(first.start_time);
            if (startP === 0) return;

            // Determine Span
            // end_time 900 -> period 2 (start of 2). 
            // If item is 800-1000 (2 hrs). start=1. end_time=1000 -> 3.
            // Span = 3 - 1 = 2. Correct.
            const endP_Time = parseInt(first.end_time);
            const endP = timeToPeriod(endP_Time);
            // Correct span calculation for times like 1000 (which maps to 3), so 1000-800 = 2 hours.
            // Using direct calculation might be safer: (end - start) / 100.
            const span = (parseInt(first.end_time) - parseInt(first.start_time)) / 100;

            // Formatter Helpers
            const getTName = (r) => r.teacher_first_name ? `อ.${r.teacher_first_name} ${r.teacher_last_name?.charAt(0) || ''}.` : "";
            // Use item_group if avail, else group_section
            const getGName = (r) => `(${r.item_group || r.group_section || '-'})`;

            const getTop = (r) => `${r.course_code} ${r.course_name}`;
            // Correct Order: Teacher Room Group
            const getBottom = (r) => `${getTName(r)} ${r.room_name || '-'} ${getGName(r)}`.trim();

            if (items.length > 1) {
                // "Both Timed" or Split - Show Both
                // Assume max 2 for simplicity, or join all?
                const item1 = items[0];
                const item2 = items[1];

                // Check if spans differ (Both Timed vs Split) logic if needed, 
                // but for View just checking length is usually enough.

                newSchedule[first.date][startP] = {
                    isSplit: true,
                    data1: { top: getTop(item1), bottom: getBottom(item1) },
                    data2: { top: getTop(item2), bottom: getBottom(item2) },
                    span: span || 1
                };
            } else {
                // Single
                newSchedule[first.date][startP] = {
                    top: getTop(first),
                    bottom: getBottom(first),
                    span: span || 1
                };
            }
        });

        setScheduleData(newSchedule);
    };

    const closeView = () => {
        setSelectedSchedule(null);
        setScheduleData({});
    };

    // Render Table Helper (Simplified version of Talangstudy)
    const renderTable = () => {
        return (
            <div className="overflow-x-auto mt-4 border border-gray-300 rounded shadow">
                <div className="min-w-[1000px] bg-white text-center">
                    {/* Header Info */}
                    <div className="p-4 bg-gray-100 border-b">
                        <h2 className="text-xl font-bold">
                            ตารางเรียน {selectedSchedule.sublevel} กลุ่ม {selectedSchedule.group_name}
                        </h2>
                        <p>ปีการศึกษา {selectedSchedule.year} ภาคเรียนที่ {selectedSchedule.term}</p>
                    </div>

                    <table className="w-full border-collapse border border-black">
                        <thead>
                            <tr className="bg-blue-200">
                                <th className="border border-black p-2 w-20">วัน/คาบ</th>
                                {[...Array(10)].map((_, i) => (
                                    <th key={i} className="border border-black p-2 text-sm">{i + 1}</th>
                                ))}
                            </tr>
                        </thead>
                        <tbody>
                            {DAYS.map(day => (
                                <tr key={day}>
                                    <td className="border border-black font-bold p-2 bg-gray-50">{day}</td>
                                    {renderDayRow(day)}
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </div>
            </div>
        );
    };

    const renderDayRow = (day) => {
        const cells = [];
        const dayData = scheduleData[day] || {};
        let currentPeriod = 1;

        while (currentPeriod <= 10) {
            if (dayData[currentPeriod]) {
                const item = dayData[currentPeriod];
                const span = item.span || 1;

                cells.push(
                    <td key={currentPeriod} colSpan={span} className="border border-black p-1 align-top text-xs h-16">
                        {item.isSplit ? (
                            <div className="flex flex-col h-full justify-between">
                                <div className="mb-1 pb-1 border-b border-dashed border-gray-400">
                                    <div className="font-semibold text-blue-800">{item.data1.top}</div>
                                    <div className="text-gray-600">{item.data1.bottom}</div>
                                </div>
                                <div>
                                    <div className="font-semibold text-blue-800">{item.data2.top}</div>
                                    <div className="text-gray-600">{item.data2.bottom}</div>
                                </div>
                            </div>
                        ) : (
                            <>
                                <div className="font-semibold text-blue-800">{item.top}</div>
                                <div className="text-gray-600 mt-1">{item.bottom}</div>
                            </>
                        )}
                    </td>
                );
                currentPeriod += span;
            } else {
                // Empty cell
                // Check if we need to skip due to previous colspan? No, we iterate linearly.
                // Wait, if a cell at 1 has span 2, we increment currentPeriod by 2.
                // But what if data is sparse? e.g. Period 1 and Period 5.
                // We fill 2, 3, 4 with empty cells.

                // However, we need to check if *this* slot is covered by a previous item?
                // My simple loop logic: if data exists at 'currentPeriod', render it and jump 'span'.
                // If not, render empty and jump 1.
                // This assumes sorted data and no overlaps starting in middle.

                cells.push(
                    <td key={currentPeriod} className="border border-black bg-gray-50"></td>
                );
                currentPeriod++;
            }
        }
        return cells;
    };

    return (
        <div className="flex min-h-screen">
            <Sidebar />
            <div className="ml-64 w-full p-6 bg-gray-50 flex-1">

                {!selectedSchedule ? (
                    <>
                        <h1 className="text-2xl font-bold mb-6 text-gray-800">ประวัติการจัดตารางเรียน</h1>

                        {/* List View */}
                        {historyList.length === 0 ? (
                            <div className="text-center text-gray-500 mt-10">ไม่พบประวัติการจัดตาราง</div>
                        ) : (
                            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                                {historyList.map((item, idx) => (
                                    <div
                                        key={`${item.infoid}-${item.term}-${idx}`}
                                        className="bg-white p-6 rounded-xl shadow-md border border-gray-100 relative group hover:shadow-lg transition-all"
                                    >
                                        <div className="flex justify-between items-start mb-4">
                                            <span className="bg-blue-100 text-blue-800 text-xs font-semibold px-2.5 py-0.5 rounded">
                                                ปี {item.year} / เทอม {item.term}
                                            </span>

                                            {/* Action Buttons */}
                                            <div className="flex gap-2">
                                                <button
                                                    onClick={(e) => {
                                                        e.stopPropagation();
                                                        navigate(`/view-schedule/${item.infoid}/${item.term}?group=${item.group_section || ''}`);
                                                    }}
                                                    className="p-2 bg-blue-50 text-blue-600 rounded-lg hover:bg-blue-100 transition-colors"
                                                    title="ดูตาราง"
                                                >
                                                    <Eye size={18} />
                                                </button>
                                                <button
                                                    onClick={(e) => {
                                                        e.stopPropagation();
                                                        navigate(`/talangstudy?mode=edit&infoid=${item.infoid}&term=${item.term}&group=${item.group_section || ''}`);
                                                    }}
                                                    className="p-2 bg-yellow-50 text-yellow-600 rounded-lg hover:bg-yellow-100 transition-colors"
                                                    title="แก้ไข"
                                                >
                                                    <Edit size={18} />
                                                </button>
                                                <button
                                                    onClick={(e) => {
                                                        e.stopPropagation();
                                                        handleDelete(item);
                                                    }}
                                                    className="p-2 bg-red-50 text-red-600 rounded-lg hover:bg-red-100 transition-colors"
                                                    title="ลบ"
                                                >
                                                    <Trash2 size={18} />
                                                </button>
                                            </div>
                                        </div>

                                        <div onClick={() => navigate(`/view-schedule/${item.infoid}/${item.term}?group=${item.group_section || ''}`)} className="cursor-pointer">
                                            <h3 className="text-xl font-bold text-gray-800 mb-2">
                                                {item.sublevel}
                                            </h3>
                                            <p className="text-gray-600">กลุ่ม: {item.group_section || item.group_name}</p>
                                        </div>
                                    </div>
                                ))}
                            </div>
                        )}
                    </>
                ) : (
                    /* Detail View */
                    <div className="animate-fade-in">
                        <button
                            onClick={closeView}
                            className="mb-4 flex items-center text-gray-600 hover:text-blue-600 transition-colors"
                        >
                            ← ย้อนกลับ
                        </button>

                        {loading ? (
                            <div className="text-center p-10">กำลังโหลด...</div>
                        ) : (
                            renderTable()
                        )}
                    </div>
                )}

            </div>
        </div>
    );
}
