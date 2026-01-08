import React, { useState, useEffect } from "react";
import { useParams, useNavigate, useLocation } from "react-router-dom";
import api from "../services/api";
import Sidebar from "../components/Sidebar";
import { ArrowLeft } from "lucide-react";

// Days Match Talangstudy
const DAYS = ["จันทร์", "อังคาร", "พุธ", "พฤหัสบดี", "ศุกร์"];

// Helper to map numeric time (e.g. 830, 900) to Period Index (1-10)
const timeToPeriod = (startInt) => {
    // 0800 -> 1
    // 0900 -> 2
    // 1000 -> 3
    // 1100 -> 4
    // 1200 -> Lunch
    // 1300 -> 5 (13.00-14.00)
    // 1400 -> 6
    // 1500 -> 7
    // 1600 -> 8
    // 1700 -> 9
    // 1800 -> 10
    if (startInt >= 800 && startInt < 900) return 1;
    if (startInt >= 900 && startInt < 1000) return 2;
    if (startInt >= 1000 && startInt < 1100) return 3;
    if (startInt >= 1100 && startInt < 1200) return 4;
    // 1200 is lunch, usually skipped in grid assignment
    if (startInt >= 1300 && startInt < 1400) return 5;
    if (startInt >= 1400 && startInt < 1500) return 6;
    if (startInt >= 1500 && startInt < 1600) return 7;
    if (startInt >= 1600 && startInt < 1700) return 8;
    if (startInt >= 1700 && startInt < 1800) return 9;
    if (startInt >= 1800 && startInt < 1900) return 10;
    return null;
};

// Helper to calculate span (duration in hours)
const calculateSpan = (startInt, endInt) => {
    // Simple approx: (End - Start) / 100
    // e.g. 1000 - 800 = 200 -> 2 hours -> Span 2
    // 1030 - 830 = 200 -> 2
    return Math.round((endInt - startInt) / 100);
};

export default function ScheduleView() {
    const { infoid, term } = useParams();
    const navigate = useNavigate();
    const location = useLocation(); // Add location
    const [schedule, setSchedule] = useState({});
    const [loading, setLoading] = useState(true);

    const [headerInfo, setHeaderInfo] = useState(null);

    useEffect(() => {
        if (infoid && term) {
            fetchData();
        }
    }, [infoid, term, location.search]);

    const fetchData = async () => {
        try {
            const query = new URLSearchParams(location.search);
            const group = query.get("group") || "";

            const res = await api.get(`/api/GET/GetScheduleByInfo.php?infoid=${infoid}&term=${term}&group=${encodeURIComponent(group)}`);

            if (res.data) {
                if (res.data.header_info) {
                    setHeaderInfo(res.data.header_info);
                }
                if (res.data.schedule) {
                    processScheduleData(res.data.schedule);
                } else if (Array.isArray(res.data)) {
                    // Legacy fallback
                    processScheduleData(res.data);
                }
            }
        } catch (err) {
            console.error("Error fetching view:", err);
        } finally {
            setLoading(false);
        }
    };

    const processScheduleData = (data) => {
        const newSchedule = {};

        // Group by Day -> Period
        // We need conflict detection to handle "Both" (2 items in same slot)
        // Temporary storage: temp[day][period] = [item1, item2...]
        const temp = {};

        data.forEach(item => {
            const day = item.date;
            const startP = timeToPeriod(parseInt(item.start_time));
            if (!startP) return;

            if (!temp[day]) temp[day] = {};
            if (!temp[day][startP]) temp[day][startP] = [];
            temp[day][startP].push(item);
        });

        // Convert temp to render-friendly schedule state
        Object.keys(temp).forEach(day => {
            newSchedule[day] = {};
            Object.keys(temp[day]).forEach(p => {
                const items = temp[day][p];
                const first = items[0];
                const span = calculateSpan(parseInt(first.start_time), parseInt(first.end_time));

                // Base cell data
                const cell = {
                    start: parseInt(p),
                    end: parseInt(p) + span - 1,
                    span: span
                };

                if (items.length > 1) {
                    // Detect "Both" - Map to "Both Timed" Layout structure
                    cell.isBothTimed = true; // Use this flag to trigger the correct renderer
                    cell.isBoth = true; // Keep for safety

                    // Top Item
                    cell.top = `${items[0].course_code} ${items[0].course_name}`;
                    cell.courseid = items[0].courseid;
                    cell.teacher = items[0].teacher_first_name; // Use fetched name
                    cell.room = items[0].room_name;
                    cell.topEndPeriod = parseInt(p) + span - 1; // Assume same span for now

                    // Bottom Item
                    cell.bottom = `${items[1].course_code} ${items[1].course_name}`;
                    cell.courseid2 = items[1].courseid;
                    cell.teacher2 = items[1].teacher_first_name;
                    cell.bottomEndPeriod = parseInt(p) + span - 1;

                    // Center - In "Both Timed" usually implies Group or Shared Room
                    // We will map Group here as it's the most common "Center" element
                    cell.centralRoom = items[0].group_section ? `ก.${items[0].group_section}` : "";

                } else {
                    // Single
                    cell.isSinglePeriod = (span === 1);
                    cell.subjectCode = first.course_code;
                    cell.subjectName = first.course_name;
                    cell.room = first.room_name;
                    cell.teacher = first.teacher_first_name;
                    cell.group = first.group_section;
                }
                newSchedule[day][p] = cell;
            });
        });

        setSchedule(newSchedule);
    };

    // simplified renderPeriodRange 
    const renderPeriodRange = (day, startPeriod, endPeriod) => {
        const dayData = schedule[day] || {};
        const cells = [];
        let current = startPeriod;

        while (current <= endPeriod) {
            const cell = dayData[current];
            if (cell) {
                const span = cell.span || 1;
                cells.push(
                    <td key={`${day}-${current}`} colSpan={span} className="border border-black p-0 align-top h-[70px] overflow-hidden">
                        {cell.isBothTimed ? (
                            /* === Both Timed Layout (Copied from Talangstudy) === */
                            <div className="w-full h-full min-h-[70px] flex flex-col leading-tight relative">
                                {/* Top Part */}
                                <div className="relative w-full flex-1 grid z-10" style={{ gridTemplateColumns: `repeat(${span}, minmax(0, 1fr))` }}>
                                    <div
                                        className="flex flex-col pl-1 h-full pt-1 relative min-w-0"
                                        style={{
                                            gridColumn: `span ${cell.topEndPeriod - current + 1}`
                                        }}
                                    >
                                        <div className="w-full overflow-hidden">
                                            <div className={`w-full text-left whitespace-nowrap text-[12px] leading-tight overflow-hidden`}>{cell.top}</div>
                                        </div>
                                        {/* Vertical Line for Top Section Only */}
                                        {((cell.topEndPeriod - current + 1) < span) && (
                                            <div
                                                className="absolute top-0 bottom-0 border-r border-black pointer-events-none"
                                                style={{
                                                    right: '-1px',
                                                    zIndex: 40
                                                }}
                                            />
                                        )}
                                    </div>
                                </div>

                                {/* Separator 1 - Grid based */}
                                <div className="grid w-full relative z-10" style={{ gridTemplateColumns: `repeat(${span}, minmax(0, 1fr))` }}>
                                    <div
                                        className="flex items-center justify-center relative min-w-0"
                                        style={{
                                            gridColumn: `span ${cell.topEndPeriod - current + 1}`
                                        }}
                                    >
                                        <svg width="6" height="6" viewBox="0 0 10 10" className="flex-shrink-0"><path d="M10 0 L0 5 L10 10 Z" fill="black" stroke="none" /></svg>
                                        <div className="flex-1 border-t border-black h-px"></div>
                                        <svg width="6" height="6" viewBox="0 0 10 10" className="flex-shrink-0"><path d="M0 0 L10 5 L0 10 Z" fill="black" stroke="none" /></svg>
                                    </div>
                                </div>

                                {/* Center Room */}
                                <div className="flex justify-center items-center text-center w-full leading-none py-1 z-10 bg-white text-[12px] whitespace-nowrap overflow-hidden">
                                    {cell.centralRoom && (
                                        <span className="text-[10px] font-normal whitespace-nowrap overflow-hidden px-1">
                                            {cell.centralRoom}
                                        </span>
                                    )}
                                </div>

                                {/* Separator 2 - Grid based */}
                                <div className="grid w-full relative z-10" style={{ gridTemplateColumns: `repeat(${span}, minmax(0, 1fr))` }}>
                                    <div
                                        className="flex items-center justify-center relative min-w-0"
                                        style={{
                                            gridColumn: `span ${cell.bottomEndPeriod - current + 1}`
                                        }}
                                    >
                                        <svg width="6" height="6" viewBox="0 0 10 10" className="flex-shrink-0"><path d="M10 0 L0 5 L10 10 Z" fill="black" stroke="none" /></svg>
                                        <div className="flex-1 border-t border-black h-px"></div>
                                        <svg width="6" height="6" viewBox="0 0 10 10" className="flex-shrink-0"><path d="M0 0 L10 5 L0 10 Z" fill="black" stroke="none" /></svg>
                                    </div>
                                </div>

                                {/* Bottom Part */}
                                <div className="relative w-full flex-1 grid items-end" style={{ gridTemplateColumns: `repeat(${span}, minmax(0, 1fr))` }}>
                                    <div
                                        className="flex flex-col justify-end pl-1 h-full pb-1 relative min-w-0"
                                        style={{
                                            gridColumn: `span ${cell.bottomEndPeriod - current + 1}`
                                        }}
                                    >
                                        <div className="w-full overflow-hidden">
                                            <div className={`w-full text-left whitespace-nowrap text-[12px] leading-tight overflow-hidden`}>{cell.bottom}</div>
                                        </div>
                                        {/* Vertical Line for Bottom Section Only */}
                                        {((cell.bottomEndPeriod - current + 1) < span) && (
                                            <div
                                                className="absolute top-0 bottom-0 border-r border-black pointer-events-none"
                                                style={{
                                                    right: '-1px',
                                                    zIndex: 40
                                                }}
                                            />
                                        )}
                                    </div>
                                </div>
                            </div>
                        ) : (
                            <div className="w-full h-full min-h-[70px] flex flex-col leading-tight relative text-[13px]">
                                {/* Top Part: Subject Code */}
                                <div className="w-full flex-[1.2] flex flex-col justify-center items-center">
                                    {cell.subjectCode && (
                                        <div className="text-center font-semibold text-[14px]">{cell.subjectCode}</div>
                                    )}
                                </div>
                                {/* Center Part: Group */}
                                <div className="flex justify-center items-center text-center w-full leading-none py-1 z-10 bg-white text-[12px] whitespace-nowrap overflow-hidden">
                                    {cell.group && (
                                        <div className="text-center text-[12px]">ก.{cell.group}</div>
                                    )}
                                </div>
                                {/* Separator */}
                                <div className="w-full flex items-center justify-center">
                                    <svg width="6" height="6" viewBox="0 0 10 10" className="flex-shrink-0"><path d="M10 0 L0 5 L10 10 Z" fill="black" stroke="none" /></svg>
                                    <div className="flex-1 border-t border-black h-px"></div>
                                    <svg width="6" height="6" viewBox="0 0 10 10" className="flex-shrink-0"><path d="M0 0 L10 5 L0 10 Z" fill="black" stroke="none" /></svg>
                                </div>
                                {/* Bottom Part: Room/Teacher */}
                                <div className="w-full flex-[0.8] flex flex-col justify-center items-center">
                                    <div className="flex justify-center items-center gap-1 w-full flex-wrap px-1">
                                        {cell.room && <div>{cell.room}</div>}
                                        {cell.teacher && <div>อ.{cell.teacher}</div>}
                                    </div>
                                </div>
                            </div>
                        )}
                    </td>
                );
                current += span;
            } else {
                cells.push(<td key={`${day}-${current}`} className="border border-black bg-gray-50"></td>);
                current++;
            }
        }
        return cells;
    };

    return (
        <div className="flex min-h-screen bg-gray-100">
            <Sidebar />
            <div className="flex-1 lg:ml-64 p-6">
                <button
                    onClick={() => navigate(-1)}
                    className="mb-4 flex items-center gap-2 text-gray-600 hover:text-blue-600 font-bold"
                >
                    <ArrowLeft /> ย้อนกลับ
                </button>

                {/* DEBUG SECTION - REMOVE AFTER FIX */}
                <div className="bg-yellow-100 p-4 mb-4 border border-yellow-400 text-sm font-mono whitespace-pre-wrap">
                    <strong>Debug Info:</strong>
                    <div>InfoID: {infoid}, Term: {term}</div>
                    <div>HeaderInfo: {JSON.stringify(headerInfo, null, 2)}</div>
                    <div>Has Schedule: {Object.keys(schedule).length > 0 ? "Yes" : "No"}</div>
                </div>

                <div className="bg-white p-6 shadow-lg rounded-lg min-w-[1300px] overflow-x-auto">

                    {/* Header Section */}
                    {headerInfo && (
                        <div className="relative mb-6 pt-2">
                            {/* Doc Number Box */}
                            <div className="absolute right-0 top-0 border border-black px-4 py-1 text-sm bg-white">
                                เอกสารหมายเลข 6
                            </div>

                            {/* Logo */}
                            <img
                                src="/vec_logo.png"
                                alt="Logo"
                                className="absolute left-10 top-0 w-16 h-16 object-contain opacity-80"
                                onError={(e) => (e.target.style.display = "none")}
                            />

                            <div className="text-center mt-6">
                                <h1 className="text-xl font-bold">วิทยาลัยเทคนิคแพร่</h1>
                                <h2 className="text-lg leading-snug mt-1 font-bold">
                                    ตารางสอนชั้นเรียน ระดับชั้น
                                    <span className="text-blue-600 font-semibold mx-2">
                                        {headerInfo.sublevel}
                                    </span>
                                    แผนกวิชา
                                    <span className="text-blue-600 font-semibold mx-2">
                                        ช่างเทคนิคคอมพิวเตอร์
                                    </span>
                                    กลุ่ม
                                    <span className="text-blue-600 font-semibold mx-2">
                                        {headerInfo.group_name}
                                    </span>
                                    จำนวนนักเรียน
                                    <span className="text-blue-600 font-semibold mx-2">
                                        {headerInfo.student_count || "-"}
                                    </span>
                                    คน
                                </h2>
                                <h3 className="text-md leading-snug mt-1 font-bold">
                                    ภาคเรียนที่
                                    <span className="text-blue-600 font-semibold mx-2">
                                        {headerInfo.term}
                                    </span>
                                    ปีการศึกษา
                                    <span className="text-blue-600 font-semibold mx-2">
                                        {headerInfo.year}
                                    </span>
                                </h3>
                            </div>
                        </div>
                    )}

                    <table className="w-full border-collapse border border-black text-[13px] text-center leading-tight table-fixed">
                        <thead>
                            <tr className="bg-white h-[48px]">
                                <th className="border border-black p-1 align-middle min-w-[100px] w-[100px]">เวลา</th>
                                <th className="border border-black p-1 min-w-[100px] w-[100px]">07.30<br />08.00</th>
                                <th className="border border-black p-1 min-w-[100px] w-[100px]">08.00<br />09.00</th>
                                <th className="border border-black p-1 min-w-[100px] w-[100px]">09.00<br />10.00</th>
                                <th className="border border-black p-1 min-w-[100px] w-[100px]">10.00<br />11.00</th>
                                <th className="border border-black p-1 min-w-[100px] w-[100px]">11.00<br />12.00</th>
                                <th className="border border-black p-1 min-w-[100px] w-[100px]">12.00<br />13.00</th>
                                <th className="border border-black p-1 min-w-[100px] w-[100px]">13.00<br />14.00</th>
                                <th className="border border-black p-1 min-w-[100px] w-[100px]">14.00<br />15.00</th>
                                <th className="border border-black p-1 min-w-[100px] w-[100px]">15.00<br />16.00</th>
                                <th className="border border-black p-1 min-w-[100px] w-[100px]">16.00<br />17.00</th>
                                <th className="border border-black p-1 min-w-[100px] w-[100px]">17.00<br />18.00</th>
                                <th className="border border-black p-1 min-w-[100px] w-[100px]">18.00<br />19.00</th>
                            </tr>
                            <tr className="bg-white h-[40px]">
                                <th className="border border-black p-1 align-middle">วัน / คาบ</th>
                                <th className="border border-black p-1"></th>
                                <th className="border border-black p-1">1</th>
                                <th className="border border-black p-1">2</th>
                                <th className="border border-black p-1">3</th>
                                <th className="border border-black p-1">4</th>
                                <th className="border border-black p-1">พัก</th>
                                <th className="border border-black p-1">5</th>
                                <th className="border border-black p-1">6</th>
                                <th className="border border-black p-1">7</th>
                                <th className="border border-black p-1">8</th>
                                <th className="border border-black p-1">9</th>
                                <th className="border border-black p-1">10</th>
                            </tr>
                        </thead>
                        <tbody>
                            {DAYS.map(day => (
                                <tr key={day} className="h-[70px] align-top">
                                    <td className="border border-black p-2 font-bold bg-gray-50">{day}</td>

                                    {/* เสาธง (เฉพาะวันจันทร์ rowSpan 5) */}
                                    {day === "จันทร์" && (
                                        <td rowSpan={5} className="border border-black p-1 overflow-hidden h-[350px] max-h-[350px]">
                                            <div className="h-full flex items-center justify-center transform -rotate-90 text-[12px] whitespace-nowrap">
                                                กิจกรรมหน้าเสาธง / หัวหน้าแผนก
                                            </div>
                                        </td>
                                    )}

                                    {renderPeriodRange(day, 1, 4)}

                                    {/* พักเที่ยง (เฉพาะวันจันทร์ rowSpan 5) */}
                                    {day === "จันทร์" && (
                                        <td rowSpan={5} className="border border-black p-1 overflow-hidden h-[350px] max-h-[350px]">
                                            <div className="h-full flex items-center justify-center transform -rotate-90 text-[12px] whitespace-nowrap">
                                                พักรับประทานอาหารกลางวัน
                                            </div>
                                        </td>
                                    )}

                                    {renderPeriodRange(day, 5, 10)}
                                </tr>
                            ))}
                        </tbody>
                    </table>
                    {loading && <div className="mt-4 text-center text-gray-500">กำลังโหลดข้อมูล...</div>}
                </div>
            </div>
        </div>
    );
}
