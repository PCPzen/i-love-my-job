import React, { useState, useEffect } from "react";
import Sidebar from "../components/Sidebar";
import { getTeachers, getRooms, getGroupInformation, getCourseInfo } from "../services/getService";
import Swal from 'sweetalert2';
import { Save, Trash2 } from 'lucide-react';

// วันหลัก
const DAYS = ["จันทร์", "อังคาร", "พุธ", "พฤหัสบดี", "ศุกร์"];

// ช่วงคาบตามเอกสารจริง (เก็บไว้เป็น Preset)
// ปรับปรุงใหม่: ใช้รูปแบบมาตรฐานเดียวกันทุกวัน
const STANDARD_BLOCKS = [
    { start: 1, end: 2, label: "คาบ 1-2" },
    { start: 2, end: 3, label: "คาบ 2-3" },
    { start: 3, end: 4, label: "คาบ 3-4" },
    { start: 5, end: 6, label: "คาบ 5-6" },
    { start: 6, end: 7, label: "คาบ 6-7" },
    { start: 8, end: 9, label: "คาบ 8-9" },
    { start: 9, end: 10, label: "คาบ 9-10" },
];

// สร้าง schedule ว่าง
function createEmptySchedule() {
    const result = {};
    for (const day of DAYS) {
        result[day] = {};
        // ไม่ต้อง Pre-fill ตาม BLOCK_CONFIG แล้ว เพราะเราจะ Render แบบ Dynamic
        // แต่ถ้าอยากให้มี Default ตาม Config ก็ทำได้ แต่ในที่นี้เอาแบบว่างๆ แล้วให้ User กรอก หรือใช้ Preset เอา
    }
    return result;
}

// Helper load/save localStorage
const loadState = (key, defaultValue) => {
    try {
        const saved = localStorage.getItem(key);
        return saved ? JSON.parse(saved) : defaultValue;
    } catch (e) {
        console.error("Failed to load state from localStorage:", e);
        return defaultValue;
    }
};

export default function ScheduleCreate() {
    // Header info (Load from localStorage)
    const [headerInfo, setHeaderInfo] = useState(() =>
        loadState("talang_headerInfo", {
            level: "ปวช.3",
            department: "ช่างเทคนิคคอมพิวเตอร์",
            group: "1-2",
            studentCount: "",
            term: "2",
            year: "2568",
            infoid: "", // Add infoid
        })
    );

    // ตาราง dynamic (Load from localStorage)
    const [schedule, setSchedule] = useState(() =>
        loadState("talang_schedule", createEmptySchedule())
    );

    // เพิ่ม State สำหรับเก็บข้อมูลครูและห้อง
    const [teacherList, setTeacherList] = useState([]);
    const [roomList, setRoomList] = useState([]);
    const [studyPlans, setStudyPlans] = useState([]); // Store fetched plans
    const [availableSubjects, setAvailableSubjects] = useState([]); // Subjects from selected plan

    // Fetch Teachers, Rooms, and Plans on mount
    useEffect(() => {
        const fetchResources = async () => {
            try {
                // Fetch Teachers
                const teachers = await getTeachers();
                if (Array.isArray(teachers)) {
                    setTeacherList(teachers);
                }

                // Fetch Rooms
                const rooms = await getRooms();
                if (Array.isArray(rooms)) {
                    setRoomList(rooms);
                }

                // Fetch Study Plans
                const plans = await getGroupInformation();
                if (Array.isArray(plans)) {
                    setStudyPlans(plans);
                }
            } catch (err) {
                console.error("Error fetching resources:", err);
            }
        };
        fetchResources();
    }, []);

    // wizard จัดตาราง
    const [step, setStep] = useState(1);
    const [editor, setEditor] = useState({
        day: "จันทร์",
        start: 1,
        end: 2,
        position: "top", // top / bottom / both
        subjectCode: "",
        subjectName: "",
        courseid: "", // Add courseid
        detail: "",
        teacher: "",

        // ชุดที่ 2 (เฉพาะกรณี position = "both")
        subjectCode2: "",
        subjectName2: "",
        courseid2: "", // Add courseid2
        detail2: "",
        teacher2: "",
    });


    // Save to localStorage on change
    useEffect(() => {
        localStorage.setItem("talang_headerInfo", JSON.stringify(headerInfo));
    }, [headerInfo]);

    useEffect(() => {
        localStorage.setItem("talang_schedule", JSON.stringify(schedule));
    }, [schedule]);

    // สำหรับอัปเดต start/end ให้ตรงวันเวลาเปลี่ยน
    const syncBlockWithDay = (newDay) => {
        // ใช้ STANDARD_BLOCKS เสมอ
        if (STANDARD_BLOCKS.length === 0) return { start: 1, end: 1 };
        return { start: STANDARD_BLOCKS[0].start, end: STANDARD_BLOCKS[0].end };
    };

    const handleHeaderChange = (e) => {
        const { name, value } = e.target;
        setHeaderInfo((prev) => ({ ...prev, [name]: value }));
    };

    const handleEditorChange = (e) => {
        const { name, value } = e.target;
        setEditor((prev) => ({ ...prev, [name]: value }));
    };

    // Auto-fetch subjects when Header Info matches a plan
    useEffect(() => {
        const autoFetchSubjects = async () => {
            let targetPlanId = null;

            // 1. Try to find planid from the selected infoid (Group) in studyPlans
            if (headerInfo.infoid) {
                const match = studyPlans.find(p => p.infoid == headerInfo.infoid);
                if (match) targetPlanId = match.planid;
            }

            // 2. Fallback: Find matching plan by Level/Group/Year
            if (!targetPlanId && headerInfo.level && headerInfo.group && headerInfo.year) {
                let match = studyPlans.find(p =>
                    p.sublevel == headerInfo.level &&
                    p.group_name == headerInfo.group &&
                    p.year == headerInfo.year &&
                    p.term == headerInfo.term
                );

                if (!match) {
                    match = studyPlans.find(p =>
                        p.sublevel == headerInfo.level &&
                        p.group_name == headerInfo.group &&
                        p.year == headerInfo.year
                    );
                }
                if (match) targetPlanId = match.planid;
            }

            if (targetPlanId) {
                console.log("Auto-fetching subjects for Plan ID:", targetPlanId);
                try {
                    const subs = await getCourseInfo(targetPlanId);
                    // Filter subjects: Match Term OR (Term 1 requested AND subject term is empty)
                    const targetTerm = headerInfo.term;
                    const filteredSubs = subs.filter(s =>
                        s.term == targetTerm ||
                        (targetTerm == '1' && !s.term)
                    );
                    setAvailableSubjects(filteredSubs || []);
                } catch (err) {
                    console.error("Auto-fetch failed:", err);
                    setAvailableSubjects([]);
                }
            } else {
                setAvailableSubjects([]);
            }
        };
        const timer = setTimeout(autoFetchSubjects, 500); // Debounce
        return () => clearTimeout(timer);
    }, [headerInfo.level, headerInfo.group, headerInfo.year, headerInfo.term, studyPlans, headerInfo.infoid]);

    // เลือกวัน (step 1)
    const handleSelectDay = (day) => {
        const { start, end } = syncBlockWithDay(day);
        setEditor((prev) => ({
            ...prev,
            day,
            start,
            end,
            // Reset fields when switching day/new entry
            subjectCode: "",
            subjectName: "",
            detail: "",
            teacher: "",
            subjectCode2: "",
            subjectName2: "",
            detail2: "",
            teacher2: "",
        }));
    };

    // เลือก block (step 2)
    const handleSelectBlock = (block) => {
        setEditor((prev) => ({
            ...prev,
            start: block.start,
            end: block.end,
        }));
    };

    // บันทึกข้อมูลลง schedule
    const handleSaveToSchedule = () => {
        // Helpers for converting IDs to Names
        const getTeacherName = (id) => {
            if (!id) return "";
            const t = teacherList.find(t => t.teacher_id == id);
            return t ? `${t.first_name} ${t.last_name}` : id;
        };
        const getRoomName = (id) => {
            if (!id) return "";
            const r = roomList.find(r => r.room_id == id);
            return r ? r.room_name : id;
        };

        setSchedule((prev) => {
            const copy = { ...prev };
            const dayData = { ...(copy[editor.day] || {}) };

            // ลบ key ที่อยู่ในช่วง start+1 ถึง end (ถ้ามี) เพื่อไม่ให้ render ซ้ำ
            for (let i = editor.start + 1; i <= editor.end; i++) {
                delete dayData[i];
            }

            const cell = {
                ...(dayData[editor.start] || { top: "", bottom: "" }),
                end: editor.end, // บันทึก end ลงไปด้วย
                raw: { ...editor } // เก็บข้อมูลดิบไว้สำหรับ Edit
            };

            // Construct Text 1
            const text1Line1 = `${editor.subjectCode || ""} ${editor.subjectName || ""}`.trim();
            let text1Line2 = `${getRoomName(editor.detail) || ""}`;
            if (editor.group) text1Line2 += ` ก.${editor.group}`;
            if (editor.teacher) text1Line2 += ` อ.${getTeacherName(editor.teacher)}`;
            text1Line2 = text1Line2.trim();
            const fullText1 = [text1Line1, text1Line2].filter(Boolean).join(" ");

            if (editor.position === "both_timed") {
                // กรณี ทั้งบนและล่าง แบบกำหนดเวลา
                cell.isBothTimed = true;
                cell.group = editor.group || "";
                cell.group2 = editor.group2 || "";

                // Top Data
                let text1Line2 = "";
                if (editor.teacher) text1Line2 += `อ.${getTeacherName(editor.teacher)} `;
                if (editor.group) text1Line2 += `ก.${editor.group} `;
                text1Line2 += `${getRoomName(editor.detail) || ""}`;
                cell.top = [text1Line1, text1Line2.trim()].filter(Boolean).join(" ");
                cell.topSubject = text1Line1;
                cell.topLine2 = text1Line2.trim(); // Teacher + Group + Room
                cell.topEndPeriod = editor.topEndPeriod ? parseInt(editor.topEndPeriod) : editor.end;
                cell.centralRoom = getRoomName(editor.centralRoom) || "";
                cell.topRoom = getRoomName(editor.detail) || "";
                cell.courseid = editor.courseid || ""; // Save courseid

                // Bottom Data
                const text2Line1 = `${editor.subjectCode2 || ""} ${editor.subjectName2 || ""}`.trim();
                let text2Line2 = "";
                if (editor.teacher2) text2Line2 += `อ.${getTeacherName(editor.teacher2)} `;
                if (editor.group2) text2Line2 += `ก.${editor.group2} `;
                text2Line2 += `${getRoomName(editor.detail2) || ""}`;
                cell.bottom = [text2Line1, text2Line2.trim()].filter(Boolean).join(" ");
                cell.bottomSubject = text2Line1;
                cell.bottomLine2 = text2Line2.trim(); // Teacher + Group + Room
                cell.bottomEndPeriod = editor.bottomEndPeriod ? parseInt(editor.bottomEndPeriod) : editor.end;
                cell.bottomRoom = getRoomName(editor.detail2) || "";
                cell.courseid2 = editor.courseid2 || ""; // Save courseid2

            } else if (editor.position === "both") {
                // กรณี ทั้งบนและล่าง: แยกคนละวิชา
                cell.top = fullText1;

                // ชุดที่ 2
                const text2Line1 = `${editor.subjectCode2 || ""} ${editor.subjectName2 || ""}`.trim();
                let text2Line2 = `${getRoomName(editor.detail2) || ""}`;
                if (editor.group2) text2Line2 += ` ก.${editor.group2}`;
                if (editor.teacher2) text2Line2 += ` อ.${getTeacherName(editor.teacher2)}`;
                text2Line2 = text2Line2.trim();
                const fullText2 = [text2Line1, text2Line2].filter(Boolean).join(" ");

                cell.bottom = fullText2;

            } else if (editor.position === "ctn") {
                // กรณี CTN: ห้องอยู่ซ้าย, ครู/กลุ่มอยู่ขวา
                const topText = `${editor.subjectCode || ""} ${editor.subjectName || ""}`.trim();
                cell.top = topText;
                cell.courseid = editor.courseid || ""; // Save courseid

                // เก็บข้อมูลแยกสำหรับ CTN layout
                cell.isCTN = true;
                cell.room = getRoomName(editor.detail) || "";
                let teacherGroup = "";
                if (editor.teacher) teacherGroup = `อ.${getTeacherName(editor.teacher)}`;
                if (editor.group) teacherGroup += (teacherGroup ? " " : "") + `ก.${editor.group}`;
                cell.teacherGroup = teacherGroup;

                // เก็บ bottom เป็น combined text สำหรับ fallback/editing
                let bottomText = getRoomName(editor.detail) || "";
                if (editor.teacher) bottomText += (bottomText ? " " : "") + `อ.${getTeacherName(editor.teacher)}`;
                if (editor.group) bottomText += (bottomText ? " " : "") + `ก.${editor.group}`;
                cell.bottom = bottomText.trim();

            } else {
                // กรณี Top หรือ Bottom
                const topText = `${editor.subjectCode || ""} ${editor.subjectName || ""}`.trim();

                if (editor.position === "top") {
                    // สามัญ: ห้อง/ครู/กลุ่มรวมกันทางขวา
                    cell.top = topText;
                    cell.courseid = editor.courseid || ""; // Save courseid
                    cell.isSamarn = true;
                    cell.room = ""; // ไม่แสดงห้องทางซ้าย

                    // รวมห้อง + อาจารย์ + กลุ่ม ทางขวา
                    let teacherGroup = "";
                    if (editor.detail) teacherGroup = getRoomName(editor.detail); // ห้อง
                    if (editor.teacher) teacherGroup += (teacherGroup ? " " : "") + `อ.${getTeacherName(editor.teacher)}`;
                    if (editor.group) teacherGroup += (teacherGroup ? " " : "") + `ก.${editor.group}`;
                    cell.teacherGroup = teacherGroup;

                    // เก็บ bottom สำหรับ fallback/editing
                    let bottomText = getRoomName(editor.detail) || "";
                    if (editor.teacher) bottomText += (bottomText ? " " : "") + `อ.${getTeacherName(editor.teacher)}`;
                    if (editor.group) bottomText += (bottomText ? " " : "") + `ก.${editor.group}`;
                    cell.bottom = bottomText.trim();
                } else if (editor.position === "single_samarn" || editor.position === "single_ctn") {
                    // จัดคาบเดียว: รหัส/กลุ่มตรงกลาง, เส้นประ, ห้อง/ครูล่าง
                    cell.isSinglePeriod = true;
                    cell.singleType = editor.position; // single_samarn หรือ single_ctn
                    cell.subjectCode = editor.subjectCode || "";
                    cell.group = editor.group || "";
                    cell.teacher = getTeacherName(editor.teacher) || "";
                    cell.room = getRoomName(editor.detail) || "";

                    // เก็บ top/bottom สำหรับ fallback
                    cell.top = editor.subjectCode || "";
                    let bottomText = "";
                    if (editor.detail) bottomText = getRoomName(editor.detail);
                    if (editor.teacher) bottomText += (bottomText ? " " : "") + `อ.${getTeacherName(editor.teacher)}`;
                    if (editor.group) bottomText += (bottomText ? " " : "") + `ก.${editor.group}`;
                    cell.bottom = bottomText.trim();
                } else {
                    // Bottom mode (ถ้ามีอยู่)
                    const bottomText = `${getRoomName(editor.detail) || ""}${editor.teacher ? ` อ.${getTeacherName(editor.teacher)}` : ""}`.trim();
                    cell.bottom = bottomText;
                    if (topText) cell.top = topText;
                }
            }

            dayData[editor.start] = cell;
            copy[editor.day] = dayData;
            return copy;
        });

        setStep(1);
    };

    // ลบข้อมูลจาก Editor (ใช้กับปุ่มลบใน Wizard)
    const handleDeleteFromEditor = () => {
        if (!editor.day || !editor.start) return;

        // ถามยืนยัน
        if (window.confirm(`คุณต้องการลบข้อมูลของวัน${editor.day} คาบที่ ${editor.start} ใช่หรือไม่?`)) {
            setSchedule(prev => {
                const copy = { ...prev };
                const dayData = { ...(copy[editor.day] || {}) };

                // ลบข้อมูลช่วงเวลานี้
                for (let i = editor.start; i <= editor.end; i++) {
                    delete dayData[i];
                }

                copy[editor.day] = dayData;
                return copy;
            });
            setStep(1); // กลับไปหน้าแรกหลังลบเสร็จ
        }
    };

    // ล้างข้อมูลตาราง (Reset)
    // ล้างข้อมูลตาราง (Reset)
    const handleReset = async () => {
        const result = await Swal.fire({
            title: 'ยืนยันการล้างข้อมูล',
            text: "คุณต้องการล้างข้อมูลตารางเรียนทั้งหมดใช่หรือไม่? (การกระทำนี้ไม่สามารถย้อนกลับได้)",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonText: 'ล้างข้อมูล',
            cancelButtonText: 'ยกเลิก',
            confirmButtonColor: '#d33',
            cancelButtonColor: '#3085d6'
        });

        if (result.isConfirmed) {
            const empty = createEmptySchedule();
            setSchedule(empty);
            setStep(1);
            Swal.fire(
                'ล้างข้อมูลเสร็จสิ้น',
                'ตารางเรียนถูกรีเซ็ตเรียบร้อยแล้ว',
                'success'
            );
        }
    };

    // บันทึกข้อมูลลงฐานข้อมูล (Save to Database)
    const handleSaveToDatabase = async () => {
        if (!headerInfo.infoid) {
            Swal.fire({
                icon: 'warning',
                title: 'กรุณาเลือกแผนการเรียน',
                text: 'ต้องเลือกแผนการเรียน (Import) ก่อนบันทึก เพื่อระบุว่าตารางนี้เป็นของแผนใด'
            });
            return;
        }

        const result = await Swal.fire({
            title: 'ยืนยันการบันทึก',
            text: "คุณต้องการบันทึกตารางเรียนลงฐานข้อมูลใช่หรือไม่? (ข้อมูลเดิมของแผนการเรียนนี้จะถูกทับ)",
            icon: 'question',
            showCancelButton: true,
            confirmButtonText: 'บันทึกข้อมูล',
            cancelButtonText: 'ยกเลิก',
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33'
        });

        if (!result.isConfirmed) return;

        const payload = [];

        // Traverse schedule
        for (const day of DAYS) {
            const dayData = schedule[day] || {};
            for (const startPeriod in dayData) {
                const cell = dayData[startPeriod];
                if (!cell) continue;

                // Common data
                const baseItem = {
                    day: day,
                    term: headerInfo.term,
                    year: headerInfo.year
                };

                // Helper to push item (parse IDs from cell/raw)
                const pushItem = (cid, tid, rid, start, end) => {
                    if (!cid) return; // Skip if no subject
                    payload.push({
                        ...baseItem,
                        courseid: cid,
                        teacher_id: tid,
                        room_id: rid,
                        start_period: parseInt(start),
                        end_period: parseInt(end)
                    });
                };

                // Use raw data from editor state saved in cell
                const raw = cell.raw || {};

                if (cell.isBothTimed) {
                    // Top
                    pushItem(cell.courseid, raw.teacher, raw.detail, cell.start || startPeriod, cell.topEndPeriod || cell.end);
                    // Bottom
                    pushItem(cell.courseid2, raw.teacher2, raw.detail2, cell.start || startPeriod, cell.bottomEndPeriod || cell.end);
                } else if (cell.isBoth) {
                    // Top
                    pushItem(cell.courseid, raw.teacher, raw.detail, cell.start || startPeriod, cell.end);
                    // Bottom
                    pushItem(cell.courseid2, raw.teacher2, raw.detail2, cell.start || startPeriod, cell.end);
                } else if (cell.isCTN) {
                    // CTN Layout
                    pushItem(cell.courseid, raw.teacher, raw.detail, cell.start || startPeriod, cell.end);
                } else {
                    // Single / Normal / Top / Bottom (Standard)
                    pushItem(cell.courseid, raw.teacher, raw.detail, cell.start || startPeriod, cell.end);
                }
            }
        }

        // Send API
        try {
            const res = await fetch("http://localhost/i-love-my-job-main/server/api/POST/SaveTotalSchedule.php", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ infoid: headerInfo.infoid, schedule: payload, term: headerInfo.term })
            });
            const data = await res.json();
            if (data.status === "success") {
                Swal.fire({
                    icon: 'success',
                    title: 'บันทึกข้อมูลเรียบร้อย',
                    text: 'ข้อมูลตารางเรียนถูกบันทึกลงฐานข้อมูลแล้ว',
                    timer: 2000,
                    showConfirmButton: false
                });
            } else {
                Swal.fire({
                    icon: 'error',
                    title: 'เกิดข้อผิดพลาด',
                    text: data.message || 'ไม่สามารถบันทึกข้อมูลได้'
                });
            }
        } catch (e) {
            console.error(e);
            Swal.fire({
                icon: 'error',
                title: 'ข้อผิดพลาดการเชื่อมต่อ',
                text: 'ไม่สามารถเชื่อมต่อกับ Server ได้'
            });
        }
    };

    // คลิกที่ Cell เพื่อแก้ไข (Click to Edit)
    const handleCellClick = (day, startPeriod, cellData) => {
        if (cellData && (cellData.top || cellData.bottom)) {
            // มีข้อมูล -> โหลดข้อมูลเดิมมาแก้ไข
            if (cellData.raw) {
                setEditor(cellData.raw);
            } else {
                // Fallback กรณีไม่มี raw data (ข้อมูลเก่า)
                setEditor({
                    day,
                    start: startPeriod,
                    end: cellData.end || startPeriod,
                    position: "top",
                    subjectCode: "",
                    subjectName: cellData.top || "",
                    detail: cellData.bottom || "",
                    teacher: "",
                    // Init 2nd set empty
                    subjectCode2: "",
                    subjectName2: "",
                    detail2: "",
                    teacher2: "",
                });
            }
            setStep(4); // ไปหน้ากรอกข้อมูลเลย
        } else {
            // ช่องว่าง -> เริ่มสร้างใหม่ที่ช่องนี้
            setEditor(prev => ({
                ...prev,
                day,
                start: startPeriod,
                end: startPeriod, // Default 1 ช่อง
                subjectCode: "",
                subjectName: "",
                detail: "",
                teacher: "",
                subjectCode2: "",
                subjectName2: "",
                detail2: "",
                teacher2: "",
            }));
            setStep(2); // ไปหน้าเลือกช่วงเวลา
        }
    };

    // Helper render ช่วงเวลา (Dynamic)
    // Helper render ช่วงเวลา (Dynamic + เส้นขั้นแนวนอนระหว่างข้อความ)
    // Helper render ช่วงเวลา
    const renderPeriodRange = (day, startPeriod, endPeriod) => {
        // Helper function to scale text based on length
        const getScaleClass = (text, span = 1) => {
            if (!text) return "text-[16px] whitespace-nowrap overflow-hidden";
            const len = text.length;
            const adjustedLen = len / span;

            // "Longer = Expands": Allow text to grow if there is space (Low adjustedLen)
            if (adjustedLen < 2) return "text-[24px] font-bold leading-tight whitespace-nowrap overflow-hidden";
            if (adjustedLen < 4) return "text-[20px] font-bold leading-tight whitespace-nowrap overflow-hidden";
            if (adjustedLen < 6) return "text-[18px] font-semibold leading-tight whitespace-nowrap overflow-hidden";

            // Normal range
            if (adjustedLen < 12) return "text-[16px] whitespace-nowrap overflow-hidden";

            // Shrinking range (Relaxed thresholds)
            if (adjustedLen > 40) return "text-[6px] leading-tight whitespace-nowrap overflow-hidden";
            if (adjustedLen > 30) return "text-[8px] leading-tight whitespace-nowrap overflow-hidden";
            if (adjustedLen > 22) return "text-[10px] leading-tight whitespace-nowrap overflow-hidden";
            if (adjustedLen > 16) return "text-[12px] leading-tight whitespace-nowrap overflow-hidden";

            return "text-[14px] leading-tight whitespace-nowrap overflow-hidden";
        };
        const dayData = schedule[day] || {};
        const cells = [];

        let current = startPeriod;
        while (current <= endPeriod) {
            const cellData = dayData[current];

            if (cellData) {
                // ช่องที่มีข้อมูล
                const span = (cellData.end || current) - current + 1;
                const hasTop = !!cellData.top;
                const hasBottom = !!cellData.bottom;

                cells.push(
                    <td
                        key={`${day}-${current}`}
                        colSpan={span}
                        className="border border-black p-0 align-top cursor-pointer hover:bg-blue-50 transition-colors h-[70px] max-h-[70px] overflow-hidden whitespace-nowrap"
                        onClick={() => handleCellClick(day, current, cellData)}
                        onContextMenu={(e) => handleCellRightClick(e, day, current, cellData)}
                        title="คลิกซ้าย: แก้ไข | คลิกขวา: ลบ"
                    >
                        {cellData.isSinglePeriod ? (
                            /* === Single Period Layout === */
                            <div className="w-full h-full min-h-[70px] flex flex-col leading-tight relative">
                                {/* Top Part: Subject Code */}
                                <div className="w-full flex-[1.2] flex flex-col justify-center items-center">
                                    {/* รหัสวิชา ตรงกลาง */}
                                    {cellData.subjectCode && (
                                        <div className={`text-center font-semibold ${getScaleClass(cellData.subjectCode, span)}`}>{cellData.subjectCode}</div>
                                    )}
                                </div>

                                {/* Center Part: Group (Matches Both Timed Center Room) */}
                                <div className="flex justify-center items-center text-center w-full leading-none py-1 z-10 bg-white text-[12px] whitespace-nowrap overflow-hidden">
                                    {/* กลุ่ม ตรงกลาง */}
                                    {cellData.group && (
                                        <div className="text-center text-[12px]">ก.{cellData.group}</div>
                                    )}
                                </div>

                                {/* Separator (Matches Both Timed Bottom Separator) */}
                                <div className="w-full flex items-center justify-center">
                                    <svg width="6" height="6" viewBox="0 0 10 10" className="flex-shrink-0"><path d="M10 0 L0 5 L10 10 Z" fill="black" stroke="none" /></svg>
                                    <div className="flex-1 border-t border-black h-px"></div>
                                    <svg width="6" height="6" viewBox="0 0 10 10" className="flex-shrink-0"><path d="M0 0 L10 5 L0 10 Z" fill="black" stroke="none" /></svg>
                                </div>

                                {/* Bottom Part: Room/Teacher */}
                                <div className="w-full flex-[0.8] flex flex-col justify-center items-center">
                                    {/* ห้อง/ครู (ลำดับต่างตาม type) */}
                                    {cellData.singleType === "single_samarn" ? (
                                        <div className="flex justify-center items-center gap-1 w-full flex-wrap px-1">
                                            {cellData.room && <div className={getScaleClass(cellData.room, span)}>{cellData.room}</div>}
                                            {cellData.teacher && <div className={getScaleClass("อ." + cellData.teacher, span)}>อ.{cellData.teacher}</div>}
                                        </div>
                                    ) : (
                                        <div className="flex justify-center items-center gap-1 w-full flex-wrap px-1">
                                            {cellData.teacher && <div className={getScaleClass("อ." + cellData.teacher, span)}>อ.{cellData.teacher}</div>}
                                            {cellData.room && <div className={getScaleClass(cellData.room, span)}>{cellData.room}</div>}
                                        </div>
                                    )}
                                </div>
                            </div>
                        ) : cellData.isBothTimed ? (
                            /* === Both Timed Layout === */
                            <div className="w-full h-full min-h-[70px] flex flex-col leading-tight relative">
                                {/* Top Part */}
                                <div className="relative w-full flex-1 grid z-10" style={{ gridTemplateColumns: `repeat(${span}, minmax(0, 1fr))` }}>
                                    <div
                                        className="flex flex-col pl-1 h-full pt-1 relative min-w-0"
                                        style={{
                                            gridColumn: `span ${cellData.topEndPeriod - current + 1}`
                                        }}
                                    >
                                        <div className="w-full overflow-hidden">
                                            <div className={`w-full text-left whitespace-nowrap ${getScaleClass(cellData.top, cellData.topEndPeriod - current + 1)}`}>{cellData.top}</div>
                                        </div>
                                        {/* Vertical Line for Top Section Only */}
                                        {((cellData.topEndPeriod - current + 1) < span) && (
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
                                            gridColumn: `span ${cellData.topEndPeriod - current + 1}`
                                        }}
                                    >
                                        <svg width="6" height="6" viewBox="0 0 10 10" className="flex-shrink-0"><path d="M10 0 L0 5 L10 10 Z" fill="black" stroke="none" /></svg>
                                        <div className="flex-1 border-t border-black h-px"></div>
                                        <svg width="6" height="6" viewBox="0 0 10 10" className="flex-shrink-0"><path d="M0 0 L10 5 L0 10 Z" fill="black" stroke="none" /></svg>
                                    </div>
                                </div>

                                {/* Center Room */}
                                <div className="flex justify-center items-center text-center w-full leading-none py-1 z-10 bg-white text-[12px] whitespace-nowrap overflow-hidden">
                                    {cellData.centralRoom && (
                                        <span className={getScaleClass(cellData.centralRoom, span)}>
                                            {cellData.centralRoom}
                                        </span>
                                    )}
                                </div>

                                {/* Separator 2 - Grid based */}
                                <div className="grid w-full relative z-10" style={{ gridTemplateColumns: `repeat(${span}, minmax(0, 1fr))` }}>
                                    <div
                                        className="flex items-center justify-center relative min-w-0"
                                        style={{
                                            gridColumn: `span ${cellData.bottomEndPeriod - current + 1}`
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
                                            gridColumn: `span ${cellData.bottomEndPeriod - current + 1}`
                                        }}
                                    >
                                        <div className="w-full overflow-hidden">
                                            <div className={`w-full text-left whitespace-nowrap ${getScaleClass(cellData.bottom, cellData.bottomEndPeriod - current + 1)}`}>{cellData.bottom}</div>
                                        </div>
                                        {/* Vertical Line for Bottom Section Only */}
                                        {((cellData.bottomEndPeriod - current + 1) < span) && (
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
                            /* === Normal Layout === */
                            <div className="w-full h-[70px] flex flex-col justify-between leading-tight p-0">
                                {/* ข้อความด้านบน - ชิดซ้ายด้านบน */}
                                {hasTop && (
                                    <div className="w-full text-left px-1 pt-1 flex-1 basis-0 flex flex-col justify-center">
                                        <div className={`${getScaleClass(cellData.top, span)}`}>{cellData.top}</div>
                                    </div>
                                )}

                                {/* เส้นขั้นแนวนอนระหว่างข้อความ พร้อมลูกศร */}
                                {hasTop && hasBottom && (
                                    <div className="w-full flex items-center justify-center my-[2px]">
                                        <svg width="6" height="6" viewBox="0 0 10 10" className="flex-shrink-0"><path d="M10 0 L0 5 L10 10 Z" fill="black" stroke="none" /></svg>
                                        <div className="flex-1 border-t border-black h-px"></div>
                                        <svg width="6" height="6" viewBox="0 0 10 10" className="flex-shrink-0"><path d="M0 0 L10 5 L0 10 Z" fill="black" stroke="none" /></svg>
                                    </div>
                                )}

                                {/* ข้อความด้านล่าง - แยก layout สำหรับ Samarn และ CTN */}
                                {hasBottom && (
                                    cellData.isSamarn ? (
                                        <div className="w-full text-right pl-1 pr-2 pb-0.5 flex-1 basis-0 flex flex-col justify-end items-end">
                                            <div className={`${getScaleClass(cellData.room + " " + cellData.teacherGroup, span)}`}>
                                                {cellData.room} {cellData.teacherGroup}
                                            </div>
                                        </div>
                                    ) : cellData.isCTN ? (
                                        <div className="w-full text-left px-1 pb-1 flex-1 flex flex-col justify-center">
                                            <div className={`${getScaleClass(cellData.room + " " + cellData.teacherGroup, span)}`}>
                                                {cellData.room} {cellData.teacherGroup}
                                            </div>
                                        </div>
                                    ) : (
                                        <div className="w-full text-left px-1 pb-1 flex-1 flex flex-col justify-center">
                                            <div className={`${getScaleClass(cellData.bottom, span)}`}>{cellData.bottom}</div>
                                        </div>
                                    )
                                )}
                            </div>
                        )
                        }
                    </td >
                );

                current += span;
            } else {
                // ช่องว่าง (ไม่มีข้อมูล)
                cells.push(
                    <td
                        key={`${day}-${current}`}
                        className="border border-black p-0 align-top cursor-pointer hover:bg-gray-100 transition-colors h-[70px] max-h-[70px] overflow-hidden"
                        onClick={() => handleCellClick(day, current, null)}
                        title="คลิกเพื่อเพิ่มวิชา"
                    >
                        <div className="w-full h-[70px]" />
                    </td>
                );
                current++;
            }
        }

        return cells;
    };


    return (
        <div className="min-h-screen flex bg-gray-50">
            <Sidebar />

            <main className="flex-1 lg:ml-64 p-4 md:p-6 overflow-x-auto">
                <div className="min-w-[1000px] bg-white p-4 md:p-6 shadow-lg rounded-lg">
                    <div className="mb-6 p-4 bg-blue-50 rounded-lg border border-blue-100 relative">
                        <h3 className="text-lg font-bold text-blue-800 mb-3 flex justify-between items-center">
                            <span>กรอกข้อมูลหัวตาราง</span>
                            <div className="flex items-center gap-2">
                                <button
                                    onClick={handleSaveToDatabase}
                                    className="flex items-center gap-2 bg-green-600 hover:bg-green-700 text-white px-3 py-1.5 rounded shadow text-sm font-medium transition-colors"
                                >
                                    <Save size={16} />
                                    <Save size={16} />
                                    บันทึกลง Database
                                </button>
                                <button
                                    onClick={handleReset}
                                    className="flex items-center gap-2 bg-red-600 hover:bg-red-700 text-white px-3 py-1.5 rounded shadow text-sm font-medium transition-colors"
                                >
                                    <Trash2 size={16} />
                                    ล้างข้อมูล
                                </button>
                                {/* Import Button */}
                                <select
                                    className="text-xs font-normal border border-blue-300 rounded px-2 py-1.5 bg-white text-blue-600 focus:ring-2 focus:ring-blue-200 outline-none"
                                    onChange={async (e) => {
                                        const planId = e.target.value;
                                        const selected = studyPlans.find(p => p.infoid == planId);
                                        if (selected) {
                                            setHeaderInfo(prev => ({
                                                ...prev,
                                                level: selected.sublevel || prev.level,
                                                group: selected.group_name || prev.group,
                                                year: selected.year || prev.year,
                                                term: selected.term || prev.term,
                                                infoid: selected.infoid || prev.infoid,
                                            }));

                                            // Auto-fetch subjects for the selected plan (Using Study Plan API)
                                            try {
                                                const res = await fetch(`/i-love-my-job-main/server/api/GET/Getcourse.php?infoid=${planId}`);
                                                const data = await res.json();
                                                // Map API data to availableSubjects structure if needed
                                                // API returns: [{ subject_id, course_code, course_name, term }, ...]
                                                // Frontend likely expects similar structure
                                                if (Array.isArray(data)) {
                                                    setAvailableSubjects(data);
                                                    Swal.fire({
                                                        icon: 'success',
                                                        title: 'ดึงข้อมูลสำเร็จ',
                                                        text: `พบ ${data.length} วิชาในแผนการเรียน`,
                                                        timer: 1500,
                                                        showConfirmButton: false
                                                    });
                                                }
                                            } catch (err) {
                                                console.error("Failed to fetch subjects:", err);
                                                Swal.fire({
                                                    icon: 'error',
                                                    title: 'ดึงข้อมูลล้มเหลว',
                                                    text: 'ไม่สามารถเชื่อมต่อกับฐานข้อมูลได้'
                                                });
                                            }
                                        } else {
                                            // Clear if no selection? Or keep previous?
                                            // If user selects "Select Plan" (empty), maybe clear infoid
                                            setHeaderInfo(prev => ({ ...prev, infoid: "" }));
                                            setAvailableSubjects([]);
                                        }
                                    }}
                                >
                                    <option value="">-- ดึงข้อมูลแผนการเรียน --</option>
                                    {studyPlans.map(p => (
                                        <option key={p.infoid} value={p.infoid}>
                                            {p.sublevel} ก.{p.group_name} ({p.year}) เทอม {p.term}
                                        </option>
                                    ))}
                                </select>
                            </div>
                        </h3>
                        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                            <div>
                                <label className="block text-sm font-medium text-gray-700">
                                    ระดับชั้น
                                </label>
                                <select
                                    name="level"
                                    value={headerInfo.level}
                                    onChange={handleHeaderChange}
                                    className="mt-1 block w-full border border-gray-300 rounded-md shadow-sm p-2 focus:ring-blue-500 focus:border-blue-500"
                                >
                                    <option value="ปวช.1">ปวช.1</option>
                                    <option value="ปวช.2">ปวช.2</option>
                                    <option value="ปวช.3">ปวช.3</option>
                                    <option value="ปวส.1">ปวส.1</option>
                                    <option value="ปวส.2">ปวส.2</option>
                                    <option value="ปวส.ม6">ปวส.ม6</option>
                                </select>
                            </div>

                            <div>
                                <label className="block text-sm font-medium text-gray-700">
                                    แผนกวิชา
                                </label>
                                <select
                                    name="department"
                                    value={headerInfo.department}
                                    onChange={handleHeaderChange}
                                    className="mt-1 block w-full border border-gray-300 rounded-md shadow-sm p-2 focus:ring-blue-500 focus:border-blue-500"
                                >
                                    <option value="ช่างเทคนิคคอมพิวเตอร์">
                                        ช่างเทคนิคคอมพิวเตอร์
                                    </option>
                                </select>
                            </div>

                            <div>
                                <label className="block text-sm font-medium text-gray-700">
                                    กลุ่ม
                                </label>
                                <select
                                    name="group"
                                    value={headerInfo.group}
                                    onChange={handleHeaderChange}
                                    className="mt-1 block w-full border border-gray-300 rounded-md shadow-sm p-2 focus:ring-blue-500 focus:border-blue-500"
                                >
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="1-2">1-2</option>
                                    <option value="3">3</option>
                                </select>
                            </div>

                            <div>
                                <label className="block text-sm font-medium text-gray-700">
                                    จำนวนนักเรียน (คน)
                                </label>
                                <input
                                    type="number"
                                    name="studentCount"
                                    value={headerInfo.studentCount}
                                    onChange={handleHeaderChange}
                                    className="mt-1 block w-full border border-gray-300 rounded-md shadow-sm p-2 focus:ring-blue-500 focus:border-blue-500"
                                />
                            </div>

                            <div>
                                <label className="block text-sm font-medium text-gray-700">
                                    ภาคเรียนที่
                                </label>
                                <select
                                    name="term"
                                    value={headerInfo.term}
                                    onChange={handleHeaderChange}
                                    className="mt-1 block w-full border border-gray-300 rounded-md shadow-sm p-2 focus:ring-blue-500 focus:border-blue-500"
                                >
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                </select>
                            </div>

                            <div>
                                <label className="block text-sm font-medium text-gray-700">
                                    ปีการศึกษา
                                </label>
                                <input
                                    type="text"
                                    name="year"
                                    value={headerInfo.year}
                                    onChange={handleHeaderChange}
                                    className="mt-1 block w-full border border-gray-300 rounded-md shadow-sm p-2 focus:ring-blue-500 focus:border-blue-500"
                                />
                            </div>
                        </div>
                    </div>

                    {/* ---------- หัวกระดาษ + เอกสารหมายเลข 6 ---------- */}
                    <div className="relative mb-4 py-4">
                        <div className="absolute right-0 top-0 border border-black px-4 py-1 text-sm">
                            เอกสารหมายเลข 6
                        </div>
                        <div className="text-center">
                            <h1 className="text-xl font-bold">วิทยาลัยเทคนิคแพร่</h1>
                            <h2 className="text-lg leading-snug mt-1">
                                ตารางสอนชั้นเรียน ระดับชั้น
                                <span className="text-blue-600 font-semibold">
                                    {" "}
                                    {headerInfo.level}
                                </span>{" "}
                                แผนกวิชา
                                <span className="text-blue-600 font-semibold">
                                    {" "}
                                    {headerInfo.department}
                                </span>{" "}
                                กลุ่ม
                                <span className="text-blue-600 font-semibold">
                                    {" "}
                                    {headerInfo.group}
                                </span>{" "}
                                จำนวนนักเรียน
                                <span className="text-blue-600 font-semibold">
                                    {" "}
                                    {headerInfo.studentCount || "......."}
                                </span>{" "}
                                คน
                            </h2>
                            <h3 className="text-md leading-snug mt-1">
                                ภาคเรียนที่
                                <span className="text-blue-600 font-semibold">
                                    {" "}
                                    {headerInfo.term}
                                </span>{" "}
                                ปีการศึกษา
                                <span className="text-blue-600 font-semibold">
                                    {" "}
                                    {headerInfo.year}
                                </span>
                            </h3>
                        </div>
                    </div>

                    {/* ---------- ตารางแบบเอกสารจริง (ใช้ logic block + arrow) ---------- */}
                    <div className="w-full overflow-x-auto mb-8">
                        <table className="w-full border-collapse border border-black text-[13px] text-center leading-tight table-fixed">



                            <thead>
                                <tr className="bg-white h-[48px]">
                                    <th className="border border-black p-1 align-middle" style={{ width: 'calc(100% / 13)' }}>เวลา</th>
                                    <th className="border border-black p-1" style={{ width: 'calc(100% / 13)' }}>
                                        07.30
                                        <br />
                                        08.00
                                    </th>
                                    <th className="border border-black p-1" style={{ width: 'calc(100% / 13)' }}>
                                        08.00
                                        <br />
                                        09.00
                                    </th>
                                    <th className="border border-black p-1" style={{ width: 'calc(100% / 13)' }}>
                                        09.00
                                        <br />
                                        10.00
                                    </th>
                                    <th className="border border-black p-1" style={{ width: 'calc(100% / 13)' }}>
                                        10.00
                                        <br />
                                        11.00
                                    </th>
                                    <th className="border border-black p-1" style={{ width: 'calc(100% / 13)' }}>
                                        11.00
                                        <br />
                                        12.00
                                    </th>
                                    <th className="border border-black p-1" style={{ width: 'calc(100% / 13)' }}>
                                        12.00
                                        <br />
                                        13.00
                                    </th>
                                    <th className="border border-black p-1" style={{ width: 'calc(100% / 13)' }}>
                                        13.00
                                        <br />
                                        14.00
                                    </th>
                                    <th className="border border-black p-1" style={{ width: 'calc(100% / 13)' }}>
                                        14.00
                                        <br />
                                        15.00
                                    </th>
                                    <th className="border border-black p-1" style={{ width: 'calc(100% / 13)' }}>
                                        15.00
                                        <br />
                                        16.00
                                    </th>
                                    <th className="border border-black p-1" style={{ width: 'calc(100% / 13)' }}>
                                        16.00
                                        <br />
                                        17.00
                                    </th>
                                    <th className="border border-black p-1" style={{ width: 'calc(100% / 13)' }}>
                                        17.00
                                        <br />
                                        18.00
                                    </th>
                                    <th className="border border-black p-1" style={{ width: 'calc(100% / 13)' }}>
                                        18.00
                                        <br />
                                        19.00
                                    </th>
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
                                {DAYS.map((day) => (
                                    <tr key={day} className="h-[70px] align-top">
                                        <td className="border border-black p-2 font-bold">{day}</td>

                                        {/* เสาธง (เฉพาะวันจันทร์ rowSpan 5 หรือ render ทุกวัน? ตามโค้ดเดิมคือ rowSpan 5 ที่วันจันทร์) */}
                                        {day === "จันทร์" && (
                                            <td rowSpan={5} className="border border-black p-1 overflow-hidden h-[350px] max-h-[350px]">
                                                <div className="h-full flex items-center justify-center transform -rotate-90 text-[12px] whitespace-nowrap">
                                                    กิจกรรมหน้าเสาธง / หัวหน้าแผนก
                                                </div>
                                            </td>
                                        )}

                                        {/* คาบ 1-4 */}
                                        {renderPeriodRange(day, 1, 4)}

                                        {/* พักเที่ยง (เฉพาะวันจันทร์ rowSpan 5) */}
                                        {day === "จันทร์" && (
                                            <td rowSpan={5} className="border border-black p-1 overflow-hidden h-[350px] max-h-[350px]">
                                                <div className="h-full flex items-center justify-center transform -rotate-90 text-[12px] whitespace-nowrap">
                                                    พักรับประทานอาหารกลางวัน
                                                </div>
                                            </td>
                                        )}

                                        {/* คาบ 5-10 */}
                                        {renderPeriodRange(day, 5, 10)}
                                    </tr>
                                ))}
                            </tbody>
                        </table>
                    </div>

                    {/* ---------- Wizard จัดตาราง (ใช้ logic ใหม่) ---------- */}
                    <div className="border border-gray-300 rounded-lg p-4 bg-gray-50">
                        <h3 className="font-bold mb-3">ฟังก์ชันจัดตารางเรียนCTN</h3>

                        {/* Step แถบ */}
                        <div className="flex flex-wrap gap-2 mb-4 text-sm">
                            {[1, 2, 3, 4].map((s) => (
                                <div
                                    key={s}
                                    className={`px-3 py-1 rounded-full border ${step === s
                                        ? "bg-blue-600 text-white border-blue-600"
                                        : "bg-white text-gray-700 border-gray-300"
                                        }`}
                                >
                                    ขั้นที่ {s}
                                </div>
                            ))}
                        </div>

                        {/* STEP 1: เลือกวัน */}
                        {step === 1 && (
                            <div className="space-y-3 text-sm">
                                <p className="font-semibold">ขั้นที่ 1 : เลือกวัน</p>
                                <div className="flex flex-wrap gap-2">
                                    {DAYS.map((day) => (
                                        <button
                                            key={day}
                                            type="button"
                                            onClick={() => handleSelectDay(day)}
                                            className={`px-4 py-2 rounded border ${editor.day === day
                                                ? "bg-blue-600 text-white border-blue-600"
                                                : "bg-white hover:bg-blue-50 border-gray-300"
                                                }`}
                                        >
                                            {day}
                                        </button>
                                    ))}
                                </div>
                                <div className="flex justify-end mt-4">
                                    <button
                                        onClick={() => setStep(2)}
                                        className="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700"
                                    >
                                        ถัดไป: เลือกช่วงคาบ
                                    </button>
                                </div>
                            </div>
                        )}

                        {/* STEP 2: เลือก block (Manual + Preset) */}
                        {step === 2 && (
                            <div className="space-y-3 text-sm">
                                <p className="font-semibold">
                                    ขั้นที่ 2 : เลือกช่วงคาบ (กำหนดเอง หรือ เลือกจาก Preset)
                                </p>

                                {/* Manual Input */}
                                <div className="flex items-center gap-4 p-3 bg-white border rounded">
                                    <div className="flex items-center gap-2">
                                        <label>คาบเริ่มต้น:</label>
                                        <input
                                            type="number"
                                            min="1"
                                            max="10"
                                            name="start"
                                            value={editor.start}
                                            onChange={handleEditorChange}
                                            className="border border-gray-300 rounded px-2 py-1 w-16 text-center"
                                        />
                                    </div>
                                    <div className="flex items-center gap-2">
                                        <label>ถึงคาบ:</label>
                                        <input
                                            type="number"
                                            min="1"
                                            max="10"
                                            name="end"
                                            value={editor.end}
                                            onChange={handleEditorChange}
                                            className="border border-gray-300 rounded px-2 py-1 w-16 text-center"
                                        />
                                    </div>
                                </div>

                                {/* Available Subjects List */}
                                {availableSubjects.length > 0 && (
                                    <div className="mt-4 p-3 bg-blue-50 border border-blue-200 rounded">
                                        <p className="font-semibold mb-2 text-blue-800">รายวิชาในแผนการเรียน (คลิกเพื่อเลือก):</p>
                                        <div className="flex flex-wrap gap-2 max-h-40 overflow-y-auto">
                                            {availableSubjects.map((subj) => (
                                                <button
                                                    key={subj.subject_id}
                                                    type="button"
                                                    onClick={() => setEditor(prev => ({
                                                        ...prev,
                                                        courseid: subj.subject_id, // Critical: capture ID for DB
                                                        subjectCode: subj.course_code || "",
                                                        subjectName: subj.course_name || "",
                                                        courseid2: subj.subject_id, // Auto-fill bottom too?
                                                        subjectCode2: subj.course_code || "",
                                                        subjectName2: subj.course_name || ""
                                                    }))}
                                                    className="text-xs px-2 py-1 bg-white border border-blue-300 rounded hover:bg-blue-100 text-left"
                                                    title={`${subj.course_code} ${subj.course_name}`}
                                                >
                                                    <span className="font-bold">{subj.course_code}</span> {subj.course_name}
                                                </button>
                                            ))}
                                        </div>
                                    </div>
                                )}

                                {/* Standard blocks selection removed */}

                                <div className="flex justify-between mt-4">
                                    <button
                                        onClick={() => setStep(1)}
                                        className="px-4 py-2 bg-gray-200 text-gray-700 rounded hover:bg-gray-300"
                                    >
                                        ย้อนกลับ
                                    </button>
                                    <button
                                        onClick={() => setStep(3)}
                                        className="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700"
                                    >
                                        ถัดไป: เลือกด้านบน/ล่าง
                                    </button>
                                </div>
                            </div>
                        )}

                        {/* STEP 3: เลือก position (เพิ่ม Option 'Both') */}
                        {step === 3 && (
                            <div className="space-y-3 text-sm">
                                <p className="font-semibold">
                                    ขั้นที่ 3 : เลือกตำแหน่งในช่อง (ด้านบน / ด้านล่าง / ทั้งสอง)
                                </p>

                                <div className="flex flex-col gap-2">
                                    <label className="flex items-center gap-2 cursor-pointer p-2 border rounded hover:bg-gray-50">
                                        <input
                                            type="radio"
                                            name="position"
                                            value="top"
                                            checked={editor.position === "top"}
                                            onChange={handleEditorChange}
                                        />
                                        <span className="font-semibold text-purple-700">จัดตารางเรียน สามัญ</span>
                                        <span className="text-gray-500">- ห้อง/ครู/กลุ่มแสดงขวา</span>
                                    </label>

                                    <label className="flex items-center gap-2 cursor-pointer p-2 border rounded hover:bg-gray-50">
                                        <input
                                            type="radio"
                                            name="position"
                                            value="ctn"
                                            checked={editor.position === "ctn"}
                                            onChange={handleEditorChange}
                                        />
                                        <span className="font-semibold text-green-700">จัดตารางเรียน CTN</span>
                                        <span className="text-gray-500">- ห้องแสดงซ้าย, ครู/กลุ่มแสดงขวา</span>
                                    </label>

                                    <label className="flex items-center gap-2 cursor-pointer p-2 border rounded hover:bg-gray-50">
                                        <input
                                            type="radio"
                                            name="position"
                                            value="single_samarn"
                                            checked={editor.position === "single_samarn"}
                                            onChange={handleEditorChange}
                                        />
                                        <span className="font-semibold text-orange-700">จัดคาบเดียว สามัญ</span>
                                        <span className="text-gray-500">- รหัส/กลุ่มตรงกลาง, ห้อง/ครูล่าง</span>
                                    </label>

                                    <label className="flex items-center gap-2 cursor-pointer p-2 border rounded hover:bg-gray-50">
                                        <input
                                            type="radio"
                                            name="position"
                                            value="single_ctn"
                                            checked={editor.position === "single_ctn"}
                                            onChange={handleEditorChange}
                                        />
                                        <span className="font-semibold text-teal-700">จัดคาบเดียว CTN</span>
                                        <span className="text-gray-500">- รหัส/กลุ่มตรงกลาง, ครู/ห้องล่าง</span>
                                    </label>

                                    <label className="flex items-center gap-2 cursor-pointer p-2 border rounded hover:bg-gray-50">
                                        <input
                                            type="radio"
                                            name="position"
                                            value="both"
                                            checked={editor.position === "both"}
                                            onChange={handleEditorChange}
                                        />
                                        <span className="font-semibold text-blue-700">ทั้งด้านบนและด้านล่าง (แยกวิชา)</span>
                                        <span className="text-gray-500">- สำหรับกรณีเรียนวันคู่/วันคี่ หรือแบ่งกลุ่มเรียน</span>
                                    </label>

                                    <label className="flex items-center gap-2 cursor-pointer p-2 border rounded hover:bg-purple-50">
                                        <input
                                            type="radio"
                                            name="position"
                                            value="both_timed"
                                            checked={editor.position === "both_timed"}
                                            onChange={handleEditorChange}
                                        />
                                        <span className="font-semibold text-purple-700">ทั้งด้านบนและด้านล่าง (แยกวิชา แบบกำหนดเวลา)</span>
                                        <span className="text-gray-500">- กลุ่มตรงกลาง, มีเส้นประแยก, กำหนดคาบแยกบน/ล่างได้</span>
                                    </label>
                                </div>

                                <div className="flex justify-between mt-4">
                                    <button
                                        onClick={() => setStep(2)}
                                        className="px-4 py-2 bg-gray-200 text-gray-700 rounded hover:bg-gray-300"
                                    >
                                        ย้อนกลับ
                                    </button>
                                    <button
                                        onClick={() => setStep(4)}
                                        className="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700"
                                    >
                                        ถัดไป: กรอกรายวิชา
                                    </button>
                                </div>
                            </div>
                        )}

                        {/* STEP 4: กรอกรายวิชา + ครู (Dual Inputs if 'Both') */}
                        {step === 4 && (
                            <div className="space-y-3 text-sm">
                                <p className="font-semibold">
                                    ขั้นที่ 4 : กรอกข้อมูลรายวิชา / รายละเอียด / ครูผู้สอน
                                </p>





                                {editor.position === "both_timed" ? (
                                    /* --- Both Timed Form --- */
                                    <div className="flex flex-col gap-4 bg-purple-50 p-4 border rounded">
                                        <div className="border-b pb-4">
                                            <h4 className="font-bold text-purple-700 mb-2">ส่วนที่ 1 (ด้านบน)</h4>

                                            {/* Top Auto Fill */}
                                            <div className="mb-2 bg-purple-100 p-2 rounded border border-purple-200">
                                                <label className="block text-xs font-bold text-gray-700 mb-1">
                                                    ดึงข้อมูลจากรายวิชา (Auto Fill ส่วนบน): {availableSubjects.length > 0 && <span className="text-green-600 font-normal ml-2">({availableSubjects.length})</span>}
                                                </label>
                                                <select
                                                    className="w-full border border-gray-300 rounded px-2 py-1 text-xs"
                                                    onChange={(e) => {
                                                        const val = e.target.value;
                                                        if (val) {
                                                            const [code, name, cid] = val.split("|");
                                                            setEditor(prev => ({ ...prev, subjectCode: code, subjectName: name, courseid: cid }));
                                                        }
                                                    }}
                                                >
                                                    <option value="">-- เลือกรายวิชา --</option>
                                                    {availableSubjects.map((subj, i) => (
                                                        <option key={`top-${subj.course_code}-${i}`} value={`${subj.course_code}|${subj.course_name}|${subj.courseid}`}>
                                                            {subj.course_code} - {subj.course_name}
                                                        </option>
                                                    ))}
                                                </select>
                                            </div>

                                            <div className="grid grid-cols-2 gap-4">
                                                <div><label className="block mb-1 text-xs font-semibold">รหัสวิชา</label><input name="subjectCode" value={editor.subjectCode} onChange={handleEditorChange} className="w-full border rounded px-2 py-1" /></div>
                                                <div><label className="block mb-1 text-xs font-semibold">ชื่อวิชา</label><input name="subjectName" value={editor.subjectName} onChange={handleEditorChange} className="w-full border rounded px-2 py-1" /></div>
                                                <div>
                                                    <label className="block mb-1 text-xs font-semibold">ห้อง</label>
                                                    <select name="detail" value={editor.detail} onChange={handleEditorChange} className="w-full border rounded px-2 py-1">
                                                        <option value="">-- เลือกห้อง --</option>
                                                        {roomList.map(r => (
                                                            <option key={r.room_id} value={r.room_id}>{r.room_name}</option>
                                                        ))}
                                                    </select>
                                                </div>
                                                <div>
                                                    <label className="block mb-1 text-xs font-semibold">ครู</label>
                                                    <select name="teacher" value={editor.teacher} onChange={handleEditorChange} className="w-full border rounded px-2 py-1">
                                                        <option value="">-- เลือกครู --</option>
                                                        {teacherList.map(t => (
                                                            <option key={t.teacher_id} value={t.teacher_id}>{t.first_name} {t.last_name}</option>
                                                        ))}
                                                    </select>
                                                </div>
                                                <div><label className="block mb-1 text-xs font-semibold">กลุ่ม</label><select name="group" value={editor.group} onChange={handleEditorChange} className="w-full border rounded px-2 py-1"><option value="">-- ไม่ระบุ --</option><option value="1">กลุ่ม 1</option><option value="1-2">กลุ่ม 1-2</option><option value="3">กลุ่ม 3</option></select></div>
                                                <div className="col-span-2"><label className="block mb-1 text-xs font-semibold text-purple-700">ถึงคาบที่</label><select name="topEndPeriod" value={editor.topEndPeriod || editor.end} onChange={handleEditorChange} className="w-full border rounded px-2 py-1">{Array.from({ length: parseInt(editor.end) - parseInt(editor.start) + 1 }, (_, i) => { const p = parseInt(editor.start) + i; return <option key={p} value={p}>คาบ {p}</option>; })}</select></div>
                                            </div>
                                        </div>
                                        <div className="py-2 text-center border-b border-dashed">
                                            <label className="block mb-1 text-xs font-semibold">ห้องเรียน (ตรงกลาง)</label>
                                            <select name="centralRoom" value={editor.centralRoom} onChange={handleEditorChange} className="w-1/2 mx-auto border rounded px-2 py-1">
                                                <option value="">-- เลือกห้อง --</option>
                                                {roomList.map(r => (
                                                    <option key={r.room_id} value={r.room_id}>{r.room_name}</option>
                                                ))}
                                            </select>
                                        </div>
                                        <div>
                                            <h4 className="font-bold text-purple-700 mb-2">ส่วนที่ 2 (ด้านล่าง)</h4>

                                            {/* Bottom Auto Fill */}
                                            <div className="mb-2 bg-purple-100 p-2 rounded border border-purple-200">
                                                <label className="block text-xs font-bold text-gray-700 mb-1">
                                                    ดึงข้อมูลจากรายวิชา (Auto Fill ส่วนล่าง):
                                                </label>
                                                <select
                                                    className="w-full border border-gray-300 rounded px-2 py-1 text-xs"
                                                    onChange={(e) => {
                                                        const val = e.target.value;
                                                        if (val) {
                                                            const [code, name, cid] = val.split("|");
                                                            setEditor(prev => ({
                                                                ...prev,
                                                                subjectCode2: code,
                                                                subjectName2: name,
                                                                courseid2: cid
                                                            }));
                                                        }
                                                    }}
                                                >
                                                    <option value="">-- เลือกรายวิชา --</option>
                                                    {availableSubjects.map((subj, i) => (
                                                        <option key={`bottom-${subj.course_code}-${i}`} value={`${subj.course_code}|${subj.course_name}|${subj.courseid}`}>
                                                            {subj.course_code} - {subj.course_name}
                                                        </option>
                                                    ))}
                                                </select>
                                            </div>

                                            <div className="grid grid-cols-2 gap-4">
                                                <div><label className="block mb-1 text-xs font-semibold">รหัสวิชา</label><input name="subjectCode2" value={editor.subjectCode2} onChange={handleEditorChange} className="w-full border rounded px-2 py-1" /></div>
                                                <div><label className="block mb-1 text-xs font-semibold">ชื่อวิชา</label><input name="subjectName2" value={editor.subjectName2} onChange={handleEditorChange} className="w-full border rounded px-2 py-1" /></div>
                                                <div>
                                                    <label className="block mb-1 text-xs font-semibold">ห้อง</label>
                                                    <select name="detail2" value={editor.detail2} onChange={handleEditorChange} className="w-full border rounded px-2 py-1">
                                                        <option value="">-- เลือกห้อง --</option>
                                                        {roomList.map(r => (
                                                            <option key={r.room_id} value={r.room_id}>{r.room_name}</option>
                                                        ))}
                                                    </select>
                                                </div>
                                                <div>
                                                    <label className="block mb-1 text-xs font-semibold">ครู</label>
                                                    <select name="teacher2" value={editor.teacher2} onChange={handleEditorChange} className="w-full border rounded px-2 py-1">
                                                        <option value="">-- เลือกครู --</option>
                                                        {teacherList.map(t => (
                                                            <option key={t.teacher_id} value={t.teacher_id}>{t.first_name} {t.last_name}</option>
                                                        ))}
                                                    </select>
                                                </div>
                                                <div><label className="block mb-1 text-xs font-semibold">กลุ่ม</label><select name="group2" value={editor.group2} onChange={handleEditorChange} className="w-full border rounded px-2 py-1"><option value="">-- ไม่ระบุ --</option><option value="1">กลุ่ม 1</option><option value="1-2">กลุ่ม 1-2</option><option value="3">กลุ่ม 3</option></select></div>
                                                <div className="col-span-2"><label className="block mb-1 text-xs font-semibold text-purple-700">ถึงคาบที่</label><select name="bottomEndPeriod" value={editor.bottomEndPeriod || editor.end} onChange={handleEditorChange} className="w-full border rounded px-2 py-1">{Array.from({ length: parseInt(editor.end) - parseInt(editor.start) + 1 }, (_, i) => { const p = parseInt(editor.start) + i; return <option key={p} value={p}>คาบ {p}</option>; })}</select></div>
                                            </div>
                                        </div>
                                    </div>
                                ) : editor.position === "both" ? (
                                    /* --- กรณีแบบ Both (2 ส่วน) --- */
                                    <div className="grid grid-cols-1 md:grid-cols-2 gap-6 bg-gray-50 p-4 border rounded text-left">
                                        {/* ส่วนที่ 1 (Top) */}
                                        <div className="space-y-2 border-r pr-0 md:pr-4 border-gray-300">
                                            <h4 className="font-bold text-blue-700 border-b pb-1 mb-2 pl-1">ส่วนที่ 1 (ด้านบน)</h4>

                                            {/* Top Auto Fill */}
                                            <div className="mb-2 bg-blue-50 p-2 rounded border border-blue-200">
                                                <label className="block text-xs font-bold text-gray-700 mb-1">
                                                    ดึงข้อมูลจากรายวิชา (Auto Fill): {availableSubjects.length > 0 && <span className="text-green-600 font-normal ml-2">({availableSubjects.length})</span>}
                                                </label>
                                                <select
                                                    className="w-full border border-gray-300 rounded px-2 py-1 text-xs"
                                                    onChange={(e) => {
                                                        const val = e.target.value;
                                                        if (val) {
                                                            const [code, name] = val.split("|");
                                                            setEditor(prev => ({ ...prev, subjectCode: code, subjectName: name }));
                                                        }
                                                    }}
                                                >
                                                    <option value="">-- เลือกรายวิชา --</option>
                                                    {availableSubjects.map((subj, i) => (
                                                        <option key={`top-2-${subj.course_code}-${i}`} value={`${subj.course_code}|${subj.course_name}`}>
                                                            {subj.course_code} - {subj.course_name}
                                                        </option>
                                                    ))}
                                                </select>
                                            </div>
                                            <div>
                                                <label className="block mb-1 text-xs font-semibold pl-1">รหัสวิชา</label>
                                                <input
                                                    name="subjectCode"
                                                    value={editor.subjectCode}
                                                    onChange={handleEditorChange}
                                                    className="w-full border border-gray-300 rounded px-2 py-1"
                                                />
                                            </div>
                                            <div>
                                                <label className="block mb-1 text-xs font-semibold pl-1">ชื่อวิชา</label>
                                                <input
                                                    name="subjectName"
                                                    value={editor.subjectName}
                                                    onChange={handleEditorChange}
                                                    className="w-full border border-gray-300 rounded px-2 py-1"
                                                />
                                            </div>
                                            <div>
                                                <label className="block mb-1 text-xs font-semibold pl-1">รายละเอียด / ห้อง</label>
                                                <select
                                                    name="detail"
                                                    value={editor.detail}
                                                    onChange={handleEditorChange}
                                                    className="w-full border border-gray-300 rounded px-2 py-1"
                                                >
                                                    <option value="">-- เลือกห้อง --</option>
                                                    {roomList.map(r => (
                                                        <option key={r.room_id} value={r.room_id}>{r.room_name}</option>
                                                    ))}
                                                </select>
                                            </div>
                                            <div>
                                                <label className="block mb-1 text-xs font-semibold pl-1">ครูผู้สอน</label>
                                                <select
                                                    name="teacher"
                                                    value={editor.teacher}
                                                    onChange={handleEditorChange}
                                                    className="w-full border border-gray-300 rounded px-2 py-1"
                                                >
                                                    <option value="">-- เลือกครู --</option>
                                                    {teacherList.map(t => (
                                                        <option key={t.teacher_id} value={t.teacher_id}>{t.first_name} {t.last_name}</option>
                                                    ))}
                                                </select>
                                            </div>
                                            <div>
                                                <label className="block mb-1 text-xs font-semibold pl-1">กลุ่ม (ถ้ามี)</label>
                                                <select
                                                    name="group"
                                                    value={editor.group}
                                                    onChange={handleEditorChange}
                                                    className="w-full border border-gray-300 rounded px-2 py-1"
                                                >
                                                    <option value="">-- ไม่ระบุ --</option>
                                                    <option value="1">กลุ่ม 1</option>
                                                    <option value="1-2">กลุ่ม 1-2</option>
                                                    <option value="3">กลุ่ม 3</option>
                                                </select>
                                            </div>
                                        </div>

                                        {/* ส่วนที่ 2 (Bottom) */}
                                        <div className="space-y-2">
                                            <h4 className="font-bold text-green-700 border-b pb-1 mb-2 pl-1">ส่วนที่ 2 (ด้านล่าง)</h4>

                                            {/* Bottom Auto Fill */}
                                            <div className="mb-2 bg-green-50 p-2 rounded border border-green-200">
                                                <label className="block text-xs font-bold text-gray-700 mb-1">
                                                    ดึงข้อมูลจากรายวิชา (Auto Fill):
                                                </label>
                                                <select
                                                    className="w-full border border-gray-300 rounded px-2 py-1 text-xs"
                                                    onChange={(e) => {
                                                        const val = e.target.value;
                                                        if (val) {
                                                            const [code, name] = val.split("|");
                                                            setEditor(prev => ({
                                                                ...prev,
                                                                subjectCode2: code,
                                                                subjectName2: name
                                                            }));
                                                        }
                                                    }}
                                                >
                                                    <option value="">-- เลือกรายวิชา --</option>
                                                    {availableSubjects.map((subj, i) => (
                                                        <option key={`bottom-2-${subj.course_code}-${i}`} value={`${subj.course_code}|${subj.course_name}`}>
                                                            {subj.course_code} - {subj.course_name}
                                                        </option>
                                                    ))}
                                                </select>
                                            </div>
                                            <div>
                                                <label className="block mb-1 text-xs font-semibold pl-1">รหัสวิชา</label>
                                                <input
                                                    name="subjectCode2"
                                                    value={editor.subjectCode2}
                                                    onChange={handleEditorChange}
                                                    className="w-full border border-gray-300 rounded px-2 py-1"
                                                />
                                            </div>
                                            <div>
                                                <label className="block mb-1 text-xs font-semibold pl-1">ชื่อวิชา</label>
                                                <input
                                                    name="subjectName2"
                                                    value={editor.subjectName2}
                                                    onChange={handleEditorChange}
                                                    className="w-full border border-gray-300 rounded px-2 py-1"
                                                />
                                            </div>
                                            <div>
                                                <label className="block mb-1 text-xs font-semibold pl-1">รายละเอียด / ห้อง</label>
                                                <select
                                                    name="detail2"
                                                    value={editor.detail2}
                                                    onChange={handleEditorChange}
                                                    className="w-full border border-gray-300 rounded px-2 py-1"
                                                >
                                                    <option value="">-- เลือกห้อง --</option>
                                                    {roomList.map(r => (
                                                        <option key={r.room_id} value={r.room_id}>{r.room_name}</option>
                                                    ))}
                                                </select>
                                            </div>
                                            <div>
                                                <label className="block mb-1 text-xs font-semibold pl-1">ครูผู้สอน</label>
                                                <select
                                                    name="teacher2"
                                                    value={editor.teacher2}
                                                    onChange={handleEditorChange}
                                                    className="w-full border border-gray-300 rounded px-2 py-1"
                                                >
                                                    <option value="">-- เลือกครู --</option>
                                                    {teacherList.map(t => (
                                                        <option key={t.teacher_id} value={t.teacher_id}>{t.first_name} {t.last_name}</option>
                                                    ))}
                                                </select>
                                            </div>
                                            <div>
                                                <label className="block mb-1 text-xs font-semibold pl-1">กลุ่ม (ถ้ามี)</label>
                                                <select
                                                    name="group2"
                                                    value={editor.group2}
                                                    onChange={handleEditorChange}
                                                    className="w-full border border-gray-300 rounded px-2 py-1"
                                                >
                                                    <option value="">-- ไม่ระบุ --</option>
                                                    <option value="1">กลุ่ม 1</option>
                                                    <option value="1-2">กลุ่ม 1-2</option>
                                                    <option value="3">กลุ่ม 3</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                ) : editor.position === "ctn" ? (
                                    /* --- กรณีแบบ CTN (เหมือน Top แต่ layout ต่าง) --- */
                                    <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
                                        <div className="md:col-span-2 mb-2 bg-gray-100 p-2 rounded border border-gray-200">
                                            <label className="block text-xs font-bold text-gray-700 mb-1">Auto Fill: {availableSubjects.length > 0 && <span className="text-green-600 font-normal ml-2">({availableSubjects.length})</span>}</label>
                                            <select className="w-full border rounded px-2 py-1 text-xs" onChange={(e) => { const val = e.target.value; if (val) { const [code, name, cid] = val.split("|"); setEditor(prev => ({ ...prev, subjectCode: code, subjectName: name, courseid: cid })); } }}>
                                                <option value="">-- เลือกรายวิชา --</option>
                                                {availableSubjects.map((subj, i) => (<option key={`ctn-${subj.course_code}-${i}`} value={`${subj.course_code}|${subj.course_name}|${subj.courseid}`}>{subj.course_code} - {subj.course_name}</option>))}
                                            </select>
                                        </div>
                                        <div>
                                            <label className="block mb-1">รหัสวิชา</label>
                                            <input
                                                name="subjectCode"
                                                value={editor.subjectCode}
                                                onChange={handleEditorChange}
                                                className="w-full border border-gray-300 rounded px-2 py-1"
                                                placeholder="เช่น 20128-2113"
                                            />
                                        </div>
                                        <div>
                                            <label className="block mb-1">ชื่อวิชา</label>
                                            <input
                                                name="subjectName"
                                                value={editor.subjectName}
                                                onChange={handleEditorChange}
                                                className="w-full border border-gray-300 rounded px-2 py-1"
                                                placeholder="เช่น ระบบเครือข่ายคอมพิวเตอร์เบื้องต้น"
                                            />
                                        </div>
                                        <div>
                                            <label className="block mb-1">ห้อง (แสดงด้านซ้ายล่าง)</label>
                                            <select
                                                name="detail"
                                                value={editor.detail}
                                                onChange={handleEditorChange}
                                                className="w-full border border-gray-300 rounded px-2 py-1"
                                            >
                                                <option value="">-- เลือกห้อง --</option>
                                                {roomList.map(r => (
                                                    <option key={r.room_id} value={r.room_id}>{r.room_name}</option>
                                                ))}
                                            </select>
                                        </div>
                                        <div>
                                            <label className="block mb-1">ครูผู้สอน (แสดงด้านขวาล่าง)</label>
                                            <select
                                                name="teacher"
                                                value={editor.teacher}
                                                onChange={handleEditorChange}
                                                className="w-full border border-gray-300 rounded px-2 py-1"
                                            >
                                                <option value="">-- เลือกครู --</option>
                                                {teacherList.map(t => (
                                                    <option key={t.teacher_id} value={t.teacher_id}>{t.first_name} {t.last_name}</option>
                                                ))}
                                            </select>
                                        </div>
                                        <div>
                                            <label className="block mb-1">กลุ่ม (แสดงด้านขวาล่าง)</label>
                                            <select
                                                name="group"
                                                value={editor.group}
                                                onChange={handleEditorChange}
                                                className="w-full border border-gray-300 rounded px-2 py-1"
                                            >
                                                <option value="">-- ไม่ระบุ --</option>
                                                <option value="1">กลุ่ม 1</option>
                                                <option value="1-2">กลุ่ม 1-2</option>
                                                <option value="3">กลุ่ม 3</option>
                                            </select>
                                        </div>
                                    </div>
                                ) : (editor.position === "single_samarn" || editor.position === "single_ctn") ? (
                                    /* --- กรณี Single Period (จัดคาบเดียว) --- */
                                    <div className="grid grid-cols-1 md:grid-cols-2 gap-3 bg-amber-50 p-4 border rounded">
                                        <div className="md:col-span-2 mb-2 bg-white p-2 rounded border border-amber-200">
                                            <label className="block text-xs font-bold text-gray-700 mb-1">Auto Fill: {availableSubjects.length > 0 && <span className="text-green-600 font-normal ml-2">({availableSubjects.length})</span>}</label>
                                            <select className="w-full border rounded px-2 py-1 text-xs" onChange={(e) => { const val = e.target.value; if (val) { const [code, name] = val.split("|"); setEditor(prev => ({ ...prev, subjectCode: code, subjectName: name })); } }}>
                                                <option value="">-- เลือกรายวิชา --</option>
                                                {availableSubjects.map((subj, i) => (<option key={`single-${subj.course_code}-${i}`} value={`${subj.course_code}|${subj.course_name}`}>{subj.course_code} - {subj.course_name}</option>))}
                                            </select>
                                        </div>
                                        <div>
                                            <label className="block mb-1 font-semibold">รหัสวิชา</label>
                                            <input
                                                name="subjectCode"
                                                value={editor.subjectCode}
                                                onChange={handleEditorChange}
                                                className="w-full border border-gray-300 rounded px-2 py-1"
                                                placeholder="เช่น 20128-2113"
                                            />
                                        </div>
                                        <div>
                                            <label className="block mb-1 font-semibold">กลุ่ม</label>
                                            <select
                                                name="group"
                                                value={editor.group}
                                                onChange={handleEditorChange}
                                                className="w-full border border-gray-300 rounded px-2 py-1"
                                            >
                                                <option value="">-- ไม่ระบุ --</option>
                                                <option value="1">กลุ่ม 1</option>
                                                <option value="1-2">กลุ่ม 1-2</option>
                                                <option value="3">กลุ่ม 3</option>
                                            </select>
                                        </div>
                                        <div>
                                            <label className="block mb-1 font-semibold">ห้อง</label>
                                            <select
                                                name="detail"
                                                value={editor.detail}
                                                onChange={handleEditorChange}
                                                className="w-full border border-gray-300 rounded px-2 py-1"
                                            >
                                                <option value="">-- เลือกห้อง --</option>
                                                {roomList.map(r => (
                                                    <option key={r.room_id} value={r.room_id}>{r.room_name}</option>
                                                ))}
                                            </select>
                                        </div>
                                        <div>
                                            <label className="block mb-1 font-semibold">ครูผู้สอน</label>
                                            <select
                                                name="teacher"
                                                value={editor.teacher}
                                                onChange={handleEditorChange}
                                                className="w-full border border-gray-300 rounded px-2 py-1"
                                            >
                                                <option value="">-- เลือกครู --</option>
                                                {teacherList.map(t => (
                                                    <option key={t.teacher_id} value={t.teacher_id}>{t.first_name} {t.last_name}</option>
                                                ))}
                                            </select>
                                        </div>
                                        <div className="md:col-span-2">
                                            <div className="bg-blue-50 p-2 rounded text-xs">
                                                <strong>หมายเหตุ:</strong> {editor.position === "single_samarn" ? (
                                                    <span>จัดคาบเดียวสามัญ - แสดงห้องก่อนครู</span>
                                                ) : (
                                                    <span>จัดคาบเดียว CTN - แสดงครูก่อนห้อง</span>
                                                )}
                                            </div>
                                        </div>
                                    </div>
                                ) : (
                                    /* --- กรณีแบบปกติ (Single) --- */
                                    <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
                                        <div className="md:col-span-2 mb-2 bg-gray-100 p-2 rounded border border-gray-200">
                                            <label className="block text-xs font-bold text-gray-700 mb-1">Auto Fill: {availableSubjects.length > 0 && <span className="text-green-600 font-normal ml-2">({availableSubjects.length})</span>}</label>
                                            <select className="w-full border rounded px-2 py-1 text-xs" onChange={(e) => { const val = e.target.value; if (val) { const [code, name, cid] = val.split("|"); setEditor(prev => ({ ...prev, subjectCode: code, subjectName: name, courseid: cid })); } }}>
                                                <option value="">-- เลือกรายวิชา --</option>
                                                {availableSubjects.map((subj, i) => (<option key={`normal-${subj.course_code}-${i}`} value={`${subj.course_code}|${subj.course_name}|${subj.courseid}`}>{subj.course_code} - {subj.course_name}</option>))}
                                            </select>
                                        </div>
                                        <div>
                                            <label className="block mb-1">รหัสวิชา</label>
                                            <input
                                                name="subjectCode"
                                                value={editor.subjectCode}
                                                onChange={handleEditorChange}
                                                className="w-full border border-gray-300 rounded px-2 py-1"
                                                placeholder="เช่น 20128-2113"
                                            />
                                        </div>
                                        <div>
                                            <label className="block mb-1">ชื่อวิชา</label>
                                            <input
                                                name="subjectName"
                                                value={editor.subjectName}
                                                onChange={handleEditorChange}
                                                className="w-full border border-gray-300 rounded px-2 py-1"
                                                placeholder="เช่น ระบบเครือข่ายคอมพิวเตอร์เบื้องต้น"
                                            />
                                        </div>
                                        <div>
                                            <label className="block mb-1">
                                                รายละเอียด / ห้อง
                                            </label>
                                            <select
                                                name="detail"
                                                value={editor.detail}
                                                onChange={handleEditorChange}
                                                className="w-full border border-gray-300 rounded px-2 py-1"
                                            >
                                                <option value="">-- เลือกห้อง --</option>
                                                {roomList.map(r => (
                                                    <option key={r.room_id} value={r.room_id}>{r.room_name}</option>
                                                ))}
                                            </select>
                                        </div>
                                        <div>
                                            <label className="block mb-1">ครูผู้สอน</label>
                                            <select
                                                name="teacher"
                                                value={editor.teacher}
                                                onChange={handleEditorChange}
                                                className="w-full border border-gray-300 rounded px-2 py-1"
                                            >
                                                <option value="">-- เลือกครู --</option>
                                                {teacherList.map(t => (
                                                    <option key={t.teacher_id} value={t.teacher_id}>{t.first_name} {t.last_name}</option>
                                                ))}
                                            </select>
                                        </div>
                                        <div>
                                            <label className="block mb-1">กลุ่ม (ถ้ามี)</label>
                                            <select
                                                name="group"
                                                value={editor.group}
                                                onChange={handleEditorChange}
                                                className="w-full border border-gray-300 rounded px-2 py-1"
                                            >
                                                <option value="">-- ไม่ระบุ --</option>
                                                <option value="1">กลุ่ม 1</option>
                                                <option value="1-2">กลุ่ม 1-2</option>
                                                <option value="3">กลุ่ม 3</option>
                                            </select>
                                        </div>
                                    </div>
                                )
                                }

                                <div className="flex justify-between mt-4">
                                    <button
                                        onClick={handleDeleteFromEditor}
                                        className="px-4 py-2 bg-red-100 text-red-700 rounded hover:bg-red-200"
                                    >
                                        ลบข้อมูลช่วงเวลานี้
                                    </button>
                                    <div className="flex gap-2">
                                        <button
                                            onClick={() => setStep(3)}
                                            className="px-4 py-2 bg-gray-200 text-gray-700 rounded hover:bg-gray-300"
                                        >
                                            ย้อนกลับ
                                        </button>
                                        <button
                                            onClick={handleSaveToSchedule}
                                            className="px-4 py-2 bg-green-600 text-white rounded hover:bg-green-700"
                                        >
                                            บันทึกลงตาราง
                                        </button>
                                    </div>
                                </div>
                            </div>
                        )}
                    </div>

                    {/* ลายเซ็น */}
                    <div className="mt-6 text-right text-sm">
                        <p>ลงชื่อ .................................................... หัวหน้าแผนกวิชา</p>
                        <p className="mt-2">
                            ลงชื่อ .................................................... งานพัฒนาหลักสูตรฯ
                        </p>
                        <p className="mt-2">
                            ลงชื่อ .................................................... ผู้อำนวยการวิทยาลัย
                        </p>
                    </div>
                </div>
            </main >
        </div >
    );
}
