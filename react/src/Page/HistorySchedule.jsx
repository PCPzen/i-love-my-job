import React, { useState, useEffect } from 'react';
import Sidebar from '../components/Sidebar';
import axios from 'axios';
import { useNavigate } from 'react-router-dom';

export default function HistorySchedule() {
    const navigate = useNavigate();
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
            const res = await axios.get(`${BASE_URL}/api/GET/GetScheduleByInfo.php?infoid=${item.infoid}&term=${item.term}`);
            if (Array.isArray(res.data)) {
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
        // Structure: schedule[day][start_period] = { ...data }
        const newSchedule = {
            "จันทร์": {}, "อังคาร": {}, "พุธ": {}, "พฤหัสบดี": {}, "ศุกร์": {}
        };

        rawData.forEach(row => {
            // Map time to period (approximate) or use raw time?
            // Talangstudy uses period index (1-10).
            // We need to reverse map time 830 -> 1, 930 -> 2, etc. or trust the DB if we saved period?
            // Wait, SaveTotalSchedule saves start_time (int) AND originally used start_period to look it up.
            // But we didn't save start_period index directly in create_study_table?
            // Creating a helper to map time back to period index for display.

            const timeToPeriod = (timeInt) => {
                // Standard mapping based on typical school times
                if (timeInt === 830) return 1;
                if (timeInt === 930) return 2;
                if (timeInt === 1030) return 3;
                if (timeInt === 1130) return 4;
                if (timeInt === 1230) return 5;
                if (timeInt === 1330) return 6;
                if (timeInt === 1430) return 7;
                if (timeInt === 1530) return 8;
                if (timeInt === 1630) return 9;
                if (timeInt === 1730) return 10;
                return 0; // Unknown
            };

            const startP = timeToPeriod(parseInt(row.start_time));
            // Calculate duration for colspan
            const endP = timeToPeriod(parseInt(row.end_time));
            // Note: end_time in DB is the END of the period. e.g. period 1 is 08:30-09:30.
            // If DB says start 830 end 930, that's Period 1.
            // If start 830 end 1030, that's Period 1-2.

            if (startP > 0) {
                // Construct display strings
                const courseText = `${row.course_code} ${row.course_name}`;
                const roomText = row.room_name || "";
                const teacherText = row.teacher_first_name ? `อ.${row.teacher_first_name} ${row.teacher_last_name || ''}` : "";

                // This simple processor handles basic conflict/overwrite by just setting the cell
                // Complex logic (CTN/Samarn layouts) might be lost if we don't store layout type.
                // But for "History View", simple display is usually enough.

                newSchedule[row.date][startP] = {
                    top: courseText,
                    bottom: `${roomText} ${teacherText}`.trim(),
                    end: endP > startP ? endP : startP, // Wait. If 830-930, endP=2. Span = 2-1 = 1. Correct.
                    // If 830-1030 (2 hrs), endP=3. Span = 3-1 = 2.
                    span: (endP > startP ? endP : (startP + 1)) - startP
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
                        <div className="font-semibold text-blue-800">{item.top}</div>
                        <div className="text-gray-600 mt-1">{item.bottom}</div>
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
                                        onClick={() => navigate(`/view-schedule/${item.infoid}/${item.term}?group=${item.group_section || ''}`)}
                                        className="bg-white p-6 rounded-xl shadow-md cursor-pointer hover:shadow-lg hover:scale-105 transition-all border border-gray-100"
                                    >
                                        <div className="flex justify-between items-start mb-4">
                                            <span className="bg-blue-100 text-blue-800 text-xs font-semibold px-2.5 py-0.5 rounded">
                                                ปี {item.year} / เทอม {item.term}
                                            </span>
                                        </div>
                                        <h3 className="text-xl font-bold text-gray-800 mb-2">
                                            {item.sublevel}
                                        </h3>
                                        <p className="text-gray-600">กลุ่ม: {item.group_name}</p>
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
