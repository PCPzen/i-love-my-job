import React, { useState, useEffect } from "react";
import Sidebar from "../components/Sidebar";
import { getTeachers, getRooms, getGroupInformation, getCourseInfo } from "../services/getService";
import Swal from 'sweetalert2';
import { Save, Trash2, ArrowLeft } from 'lucide-react'; // Added ArrowLeft
import { useLocation, useNavigate } from "react-router-dom"; // Added hooks
import axios from 'axios';

// วันหลัก
const DAYS = ["จันทร์", "อังคาร", "พุธ", "พฤหัสบดี", "ศุกร์"];

// API Helpers
const API_BASE = import.meta.env.VITE_API_BASE_URL || 'http://localhost/i-love-my-job-main/server';

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

// Time Map for Reverse Logic (Time -> Period)
const TIME_TO_PERIOD = {
    800: 1, 900: 2, 1000: 3, 1100: 4, 1200: 5, // Lunch gap usually 12-13? 
    1300: 5, 1400: 6, 1500: 7, 1600: 8, 1700: 9, 1800: 10
};

// สร้าง schedule ว่าง
function createEmptySchedule() {
    const result = {};
    for (const day of DAYS) {
        result[day] = {};
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
    const location = useLocation();
    const navigate = useNavigate();
    const query = new URLSearchParams(location.search);
    const isEditMode = query.get("mode") === "edit";
    const editInfoid = query.get("infoid");
    const editTerm = query.get("term");
    const editGroup = query.get("group");

    // Header info (Load from localStorage OR from Edit Params)
    const [headerInfo, setHeaderInfo] = useState(() =>
        loadState("talang_headerInfo", {
            level: "ปวช.3",
            department: "ช่างเทคนิคคอมพิวเตอร์",
            group: "1-2",
            studentCount: "",
            term: "2",
            year: "2568",
            infoid: "",
        })
    );

    // ตาราง dynamic
    const [schedule, setSchedule] = useState(() =>
        loadState("talang_schedule", createEmptySchedule())
    );
    const [fontOffsets, setFontOffsets] = useState({ top: 0, bottom: 0 }); // Independent Font Offsets
    const [activeFontTarget, setActiveFontTarget] = useState('top'); // 'top' or 'bottom'

    // เพิ่ม State สำหรับเก็บข้อมูลครูและห้อง
    const [teacherList, setTeacherList] = useState([]);
    const [roomList, setRoomList] = useState([]);
    const [studyPlans, setStudyPlans] = useState([]);
    const [availableSubjects, setAvailableSubjects] = useState([]);

    // Fetch Initial Data (Teachers, Rooms, Plans) AND Edit Data
    useEffect(() => {
        const fetchResources = async () => {
            try {
                // Fetch Resources
                const [teachers, rooms, plans] = await Promise.all([
                    getTeachers(),
                    getRooms(),
                    getGroupInformation()
                ]);

                if (Array.isArray(teachers)) setTeacherList(teachers);
                if (Array.isArray(rooms)) setRoomList(rooms);
                if (Array.isArray(plans)) setStudyPlans(plans);

                // If Edit Mode, Fetch Schedule Data
                if (isEditMode && editInfoid && editTerm) {
                    await fetchEditData(editInfoid, editTerm, editGroup, teachers, rooms);
                }

            } catch (err) {
                console.error("Error fetching resources:", err);
            }
        };
        fetchResources();
    }, [isEditMode, editInfoid, editTerm, editGroup]);

    // Function to load existing schedule into state
    const fetchEditData = async (infoid, term, group, teachers, rooms) => {
        try {
            console.log("🔍 [FETCH EDIT DATA] Starting...");
            console.log("📥 Input Parameters:", { infoid, term, group });

            const apiUrl = `${API_BASE}/api/GET/GetScheduleByInfo.php?infoid=${infoid}&term=${term}&group=${encodeURIComponent(group || '')}`;
            console.log("🌐 API URL:", apiUrl);

            const res = await axios.get(apiUrl);

            console.log("✅ [API RESPONSE] Full Response:", res.data);

            if (res.data) {
                // 1. Set Header Info
                const h = res.data.header_info;
                console.log("📋 [HEADER INFO] Raw from API:", h);

                if (h) {
                    const newHeaderInfo = {
                        level: h.sublevel,
                        department: h.department || "", // Not available in DB yet
                        group: h.group_section || group || h.group_name,
                        studentCount: h.student_count || "",
                        term: h.term || term,
                        year: h.year,
                        infoid: infoid
                    };

                    console.log("✏️ [HEADER INFO] Mapped for State:", newHeaderInfo);
                    setHeaderInfo(newHeaderInfo);
                    console.log("✅ [HEADER INFO] State Updated!");
                } else {
                    console.warn("⚠️ [HEADER INFO] No header_info in response!");
                }


                // 2. Map Schedule Data to Editor Format
                const scData = res.data.schedule || [];
                const newSchedule = createEmptySchedule();

                // Group by Day -> StartTime
                const grouped = {};
                scData.forEach(item => {
                    const key = `${item.date}-${item.start_time}`;
                    if (!grouped[key]) grouped[key] = [];
                    grouped[key].push(item);
                });

                Object.keys(grouped).forEach(key => {
                    const items = grouped[key];
                    const firstItem = items[0];
                    const day = firstItem.date;

                    // Map Time to Period
                    // Note: API returns Int (e.g. 800)
                    // We need to map 800 -> 1, 900 -> 2...
                    // Start logic:
                    // Map Time to Period
                    // Note: API returns Int (e.g. 800)
                    // map time to period
                    let startP = TIME_TO_PERIOD[firstItem.start_time] || 1;

                    // Duration logic for First Item
                    const duration1 = (firstItem.end_time - firstItem.start_time) / 100;
                    let endP = startP + duration1 - 1;

                    // Helper for Teacher Name
                    const getTName = (item) => item.teacher_first_name ? `${item.teacher_first_name} ${item.teacher_last_name || ''}`.trim() : "";

                    // Helper for Room Name
                    const getRName = (item) => item.room_name || "";

                    // Item 1 Data
                    const sc1 = firstItem.course_code || "";
                    const sn1 = firstItem.course_name || "";
                    const r1 = getRName(firstItem);
                    const r1Id = firstItem.room_id;
                    const t1Name = getTName(firstItem);
                    const t1Id = firstItem.teacher_id;
                    const g1 = firstItem.item_group || firstItem.group_section || "";
                    const centralId = firstItem.central_room || "";
                    const centralName = firstItem.central_room_name || "";

                    // Prepare Cell Data
                    const cell = {
                        start: startP,
                        end: endP,
                        position: items.length > 1 ? "both" : "top",

                        // Core Data
                        subjectCode: sc1,
                        subjectName: sn1,
                        detail: r1Id, // เก็บเป็น room ID
                        teacher: t1Id,
                        courseid: firstItem.courseid,
                        group: g1,
                        centralRoom: centralName,

                        // Display Data
                        top: `${sc1} ${sn1}`.trim(),
                        bottom: `${r1} ${t1Name ? 'อ.' + t1Name : ''}`.trim(),

                        // Raw Data for Editor
                        raw: {
                            day: day,
                            start: startP,
                            end: endP,
                            position: "top", // Will be updated below
                            subjectCode: sc1,
                            subjectName: sn1,
                            detail: r1Id, // เก็บเป็น ID
                            teacher: t1Id,
                            courseid: firstItem.courseid,
                            group: g1,
                            topEndPeriod: endP, // Default to same end
                            centralRoom: centralId,

                            // 2nd Item Defaults
                            subjectCode2: "",
                            subjectName2: "",
                            detail2: "",
                            teacher2: "",
                            courseid2: "",
                            group2: "",
                            bottomEndPeriod: endP
                        }
                    };

                    // Handle Second Item (if any)
                    if (items.length > 1) {
                        const secondItem = items[1];
                        const sc2 = secondItem.course_code || "";
                        const sn2 = secondItem.course_name || "";
                        const r2 = getRName(secondItem);
                        const r2Id = secondItem.room_id;
                        const t2Name = getTName(secondItem);
                        const t2Id = secondItem.teacher_id;
                        const g2 = secondItem.item_group || secondItem.group_section || "";

                        // Duration logic for Second Item
                        const duration2 = (secondItem.end_time - secondItem.start_time) / 100;
                        const endP2 = startP + duration2 - 1;

                        // Check if it's "Both Timed"
                        const isTimed = duration1 !== duration2 || !!centralId;
                        const pos = isTimed ? "both_timed" : "both";

                        // Update Max End Period for the cell wrapper
                        if (endP2 > endP) {
                            cell.end = endP2;
                            cell.raw.end = endP2;
                            endP = endP2;
                        }

                        cell.position = pos;
                        cell.raw.position = pos;

                        cell.subjectCode2 = sc2;
                        cell.subjectName2 = sn2;
                        cell.detail2 = r2Id; // เก็บเป็น ID
                        cell.teacher2 = t2Id;
                        cell.courseid2 = secondItem.courseid;
                        cell.group2 = g2;
                        cell.isBothTimed = isTimed;
                        if (isTimed) cell.isBoth = false; else cell.isBoth = true;

                        // Update Raw for Editor
                        cell.raw.subjectCode2 = sc2;
                        cell.raw.subjectName2 = sn2;
                        cell.raw.detail2 = r2Id; // เก็บเป็น ID
                        cell.raw.teacher2 = t2Id;
                        cell.raw.courseid2 = secondItem.courseid;
                        cell.raw.group2 = g2;

                        // Set timed periods for editor
                        cell.raw.topEndPeriod = startP + duration1 - 1;
                        cell.raw.bottomEndPeriod = endP2;
                        cell.topEndPeriod = startP + duration1 - 1;
                        cell.bottomEndPeriod = endP2;

                        // Update Display
                        if (isTimed) {
                            // Both Timed: แยกข้อมูลบน/ล่าง ชัดเจน
                            cell.top = `${sc1} ${sn1} ${t1Name ? 'อ.' + t1Name : ''} ${g1 ? 'ก.' + g1 : ''} ${r1}`.trim();
                            cell.bottom = `${sc2} ${sn2} ${t2Name ? 'อ.' + t2Name : ''} ${g2 ? 'ก.' + g2 : ''} ${r2}`.trim();

                            // สำหรับ both_timed เก็บข้อมูลแยกสำหรับแสดงผล
                            cell.topSubject = `${sc1} ${sn1}`.trim();
                            cell.topLine2 = `${t1Name ? 'อ.' + t1Name : ''} ${g1 ? 'ก.' + g1 : ''} ${r1}`.trim();
                            cell.topRoom = r1;
                            cell.bottomSubject = `${sc2} ${sn2}`.trim();
                            cell.bottomLine2 = `${t2Name ? 'อ.' + t2Name : ''} ${g2 ? 'ก.' + g2 : ''} ${r2}`.trim();
                            cell.bottomRoom = r2;
                        } else {
                            // Both (Same Time): รวมข้อมูลโดยใช้ /
                            cell.top = `${sc1} ${sn1} / ${sc2} ${sn2}`;
                            cell.bottom = `${r1} ${t1Name ? 'อ.' + t1Name : ''} / ${r2} ${t2Name ? 'อ.' + t2Name : ''}`;
                        }
                    } else {
                        // Single Item - กำหนด layout properties
                        cell.raw.position = "top";

                        // ตรวจสอบว่าเป็น layout แบบไหน:
                        // - ถ้ามีทั้ง top และ bottom แต่ไม่มี second item = top/samarn (ข้อมูลล่างมีห้อง/ครู)
                        // - ถ้ามี duration = 1 คาบ = single period

                        const hasBothTopBottom = !!sc1 && (!!r1 || !!t1Name);

                        if (duration1 === 1 && hasBothTopBottom) {
                            // Single Period (1 คาบ เท่านั้น)
                            cell.isSinglePeriod = true;
                            cell.singleType = "single_samarn"; // default, จะต้องเก็บใน DB ถ้าต้องการแยก CTN
                            cell.subjectCode = sc1;
                            cell.group = g1;
                            cell.teacher = t1Name;
                            cell.room = r1;
                            cell.top = sc1;

                            // Bottom: room/teacher
                            let bottomText = "";
                            if (r1) bottomText = r1;
                            if (t1Name) bottomText += (bottomText ? " " : "") + `อ.${t1Name}`;
                            if (g1) bottomText += (bottomText ? " " : "") + `ก.${g1}`;
                            cell.bottom = bottomText.trim();

                        } else if (hasBothTopBottom) {
                            // Normal top/bottom (ตรวจสอบว่าเป็น Samarn หรือ CTN)
                            // ถ้าข้อมูลในฐานข้อมูลไม่มีบันทึกว่าเป็น type ไหน จะ default เป็น top (normal)

                            // ตัวอย่าง: ถ้าข้อมูลล่างมีรูปแบบ "ห้อง ครู" = Samarn
                            // ถ้ามีรูปแบบ "ครู ห้อง" = CTN
                            // แต่เนื่องจากเราไม่ได้เก็บข้อมูลนี้ไว้ เราจะ default เป็น normal first

                            cell.isSamarn = true; // Default เป็น Samarn
                            cell.room = ""; // Samarn ไม่แสดงห้องทางซ้าย

                            // รวมห้อง + ครู + กลุ่ม ทางขวา
                            let teacherGroup = "";
                            if (r1) teacherGroup = r1;
                            if (t1Name) teacherGroup += (teacherGroup ? " " : "") + `อ.${t1Name}`;
                            if (g1) teacherGroup += (teacherGroup ? " " : "") + `ก.${g1}`;
                            cell.teacherGroup = teacherGroup;

                            // เก็บ bottom สำหรับ fallback
                            cell.bottom = teacherGroup;
                        } else {
                            // Only top, no bottom
                            cell.top = `${sc1} ${sn1}`.trim();
                        }
                    }

                    // Assign to Schedule State
                    newSchedule[day][startP] = cell;

                    // Mark subsequent slots as "occupied" if needed? 
                    // The editor logic deletes overlaps on save, but relies on key existence for rendering.
                    // We only set the START key.
                });

                setSchedule(newSchedule);
            }
        } catch (err) {
            console.error("Failed to load edit data", err);
            Swal.fire("Error", "โหลดข้อมูลตารางเรียนไม่สำเร็จ", "error");
        }
    };


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


    // Save to localStorage on change (SKIP IF EDIT MODE to avoid overwriting creation draft)
    useEffect(() => {
        if (!isEditMode) localStorage.setItem("talang_headerInfo", JSON.stringify(headerInfo));
    }, [headerInfo, isEditMode]);

    useEffect(() => {
        if (!isEditMode) localStorage.setItem("talang_schedule", JSON.stringify(schedule));
    }, [schedule, isEditMode]);


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
            console.log("🔄 [AUTO FILL] useEffect triggered");
            console.log("📋 [AUTO FILL] Header Info:", {
                level: headerInfo.level,
                group: headerInfo.group,
                year: headerInfo.year,
                term: headerInfo.term,
                infoid: headerInfo.infoid
            });
            console.log("📚 [AUTO FILL] Available Study Plans:", studyPlans);
            console.log("   Count:", studyPlans.length);

            let targetPlanId = null;

            // 1. Try to find planid from the selected infoid (Group) in studyPlans
            console.log("🔍 [AUTO FILL] Step 1: Looking for infoid match...");
            if (headerInfo.infoid) {
                console.log("   Searching for infoid:", headerInfo.infoid);
                const match = studyPlans.find(p => p.infoid == headerInfo.infoid);
                if (match) {
                    targetPlanId = match.infoid;
                    console.log("✅ [AUTO FILL] Found by infoid:", match);
                } else {
                    console.log("❌ [AUTO FILL] No match found for infoid:", headerInfo.infoid);
                }
            } else {
                console.log("⚠️ [AUTO FILL] headerInfo.infoid is empty");
            }

            // 2. Fallback: Find matching plan by Level/Group/Year
            console.log("🔍 [AUTO FILL] Step 2: Fallback matching by level/group/year...");
            if (!targetPlanId && headerInfo.level && headerInfo.group && headerInfo.year) {
                console.log("   Searching for:", {
                    sublevel: headerInfo.level,
                    group_name: headerInfo.group,
                    year: headerInfo.year,
                    term: headerInfo.term
                });

                let match = studyPlans.find(p =>
                    p.sublevel == headerInfo.level &&
                    p.group_name == headerInfo.group &&
                    p.year == headerInfo.year &&
                    p.term == headerInfo.term
                );

                if (!match) {
                    console.log("   No exact match with term, trying without term...");
                    match = studyPlans.find(p =>
                        p.sublevel == headerInfo.level &&
                        p.group_name == headerInfo.group &&
                        p.year == headerInfo.year
                    );
                }

                if (match) {
                    targetPlanId = match.infoid;
                    console.log("✅ [AUTO FILL] Found by level/group/year:", match);
                } else {
                    console.log("❌ [AUTO FILL] No match found for level/group/year");
                }
            } else {
                console.log("⚠️ [AUTO FILL] Insufficient data for fallback match");
            }

            console.log("🎯 [AUTO FILL] Target Plan ID:", targetPlanId);

            if (targetPlanId) {
                console.log("📡 [AUTO FILL] Fetching subjects for Plan ID:", targetPlanId);
                try {
                    const subs = await getCourseInfo(targetPlanId);
                    console.log("📥 [AUTO FILL] Raw subjects from API:", subs);
                    console.log("   Count:", subs ? subs.length : 0);

                    // 🔍 แสดง term ของแต่ละรายวิชา
                    if (subs && subs.length > 0) {
                        console.log("   📊 All subject terms:");
                        subs.forEach((s, idx) => {
                            console.log(`      [${idx}] ${s.subject_code || s.course_code || 'NO_CODE'} - term: "${s.term}" (type: ${typeof s.term})`);
                        });

                        // แสดง object เต็มๆ ของ 2 รายการแรกเพื่อดู structure
                        console.log("   🔬 Sample Objects (first 2):");
                        console.log("      [0]", subs[0]);
                        if (subs.length > 1) console.log("      [1]", subs[1]);

                        // แสดง keys ที่มีใน object
                        console.log("   🔑 Available Keys:", Object.keys(subs[0]));
                    }

                    // Filter subjects: Match Term OR (Term 1 requested AND subject term is empty)
                    const targetTerm = headerInfo.term;
                    console.log("🔍 [AUTO FILL] Filtering by term:", targetTerm, "(type:", typeof targetTerm, ")");

                    // ใช้ == แทน === เพื่อ handle type mismatch และแปลงเป็น String
                    const filteredSubs = subs.filter(s => {
                        const match = s.term == targetTerm ||
                            String(s.term) == String(targetTerm) ||
                            (targetTerm == '1' && !s.term);

                        if (!match) {
                            console.log(`      ❌ Skip: ${s.subject_code} (term: "${s.term}" ≠ "${targetTerm}")`);
                        }
                        return match;
                    });

                    console.log("✅ [AUTO FILL] Filtered subjects:", filteredSubs);
                    console.log("   Count:", filteredSubs.length);
                    if (filteredSubs.length > 0) {
                        console.log("   Sample:", filteredSubs.slice(0, 3).map(s => ({
                            code: s.subject_code,
                            name: s.subject_name,
                            term: s.term
                        })));
                    }

                    setAvailableSubjects(filteredSubs || []);
                    console.log("✅ [AUTO FILL] availableSubjects state updated!");
                } catch (err) {
                    console.error("❌ [AUTO FILL] Error fetching subjects:", err);
                    setAvailableSubjects([]);
                }
            } else {
                console.warn("⚠️ [AUTO FILL] No targetPlanId found, clearing subjects");
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
        // Validation: Must select course (Prevent Manual Typing without ID)
        if (!editor.courseid) {
            Swal.fire('ข้อผิดพลาด', 'กรุณาเลือกรายวิชาจากรายการตัวเลือกเท่านั้น (ห้ามพิมพ์เอง)', 'warning');
            return;
        }
        if ((editor.position === 'both' || editor.position === 'both_timed') && !editor.courseid2) {
            Swal.fire('ข้อผิดพลาด', 'กรุณาเลือกรายวิชาสำหรับส่วนที่ 2 จากรายการตัวเลือกเท่านั้น', 'warning');
            return;
        }

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
                cell.isBoth = true;
                cell.courseid = editor.courseid || "";
                cell.courseid2 = editor.courseid2 || "";
                cell.group = editor.group || "";
                cell.group2 = editor.group2 || "";

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
                cell.group = editor.group || "";

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
                    cell.group = editor.group || "";
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
                    cell.courseid = editor.courseid || "";

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
                const pushItem = (cid, tid, rid, start, end, grp, central) => {
                    if (!cid) return; // Skip if no subject
                    payload.push({
                        ...baseItem,
                        courseid: cid,
                        teacher_id: tid,
                        room_id: rid,
                        start_period: parseInt(start),
                        end_period: parseInt(end),
                        group_section: grp || headerInfo.group, // Use item group or fallback
                        central_room: central || null // Send central room ID
                    });
                };

                // Use raw data from editor state saved in cell
                const raw = cell.raw || {};

                if (cell.isBothTimed) {
                    // Top
                    pushItem(cell.courseid, raw.teacher, raw.detail, cell.start || startPeriod, cell.topEndPeriod || cell.end, cell.group, raw.centralRoom);
                    // Bottom
                    pushItem(cell.courseid2, raw.teacher2, raw.detail2, cell.start || startPeriod, cell.bottomEndPeriod || cell.end, cell.group2, raw.centralRoom);
                } else if (cell.isBoth) {
                    // Top
                    pushItem(cell.courseid, raw.teacher, raw.detail, cell.start || startPeriod, cell.end, cell.group);
                    // Bottom
                    pushItem(cell.courseid2, raw.teacher2, raw.detail2, cell.start || startPeriod, cell.end, cell.group2);
                } else if (cell.isCTN) {
                    // CTN Layout
                    pushItem(cell.courseid, raw.teacher, raw.detail, cell.start || startPeriod, cell.end, cell.group);
                } else {
                    // Single / Normal / Top / Bottom (Standard)
                    pushItem(cell.courseid, raw.teacher, raw.detail, cell.start || startPeriod, cell.end, cell.group);
                }
            }
        }

        // Send API
        try {
            const res = await fetch("http://localhost/i-love-my-job-main/server/api/POST/SaveTotalSchedule.php", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({
                    infoid: headerInfo.infoid,
                    schedule: payload,
                    term: headerInfo.term,
                    group: headerInfo.group,
                    studentCount: headerInfo.studentCount,
                    // New Fields for Updating Group Info
                    year: headerInfo.year,
                    sublevel: headerInfo.level,
                    department: headerInfo.department
                })
            });
            const data = await res.json();
            if (data.status === "success") {
                Swal.fire({
                    icon: 'success',
                    title: 'บันทึกข้อมูลเรียบร้อย',
                    text: 'ข้อมูลตารางเรียนถูกบันทึกลงฐานข้อมูลแล้ว',
                    timer: 2000,
                    showConfirmButton: false
                }).then(() => {
                    navigate("/history-schedule");
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
        const getScaleClass = (text, span = 1, bold = false, target = 'top') => {
            const currentOffset = fontOffsets[target] || 0;
            if (!text) return {
                className: "whitespace-normal break-words overflow-visible",
                style: {
                    fontSize: "13px",
                    transform: "scale(1)",
                    transformOrigin: "left top",  // ขยายจากซ้ายไปขวา, บนลงล่าง
                    display: "inline-block"
                }
            };

            const len = text.length;
            const adjustedLen = len / span;

            // ขนาดฐาน (จะไม่เปลี่ยน)
            const baseSize = 13;
            let baseSizeMultiplier = 1;
            let weight = "font-normal";

            // คำนวณ multiplier ตามความยาวข้อความ
            if (adjustedLen < 2) { baseSizeMultiplier = 1.8; weight = "font-bold"; }
            else if (adjustedLen < 4) { baseSizeMultiplier = 1.5; weight = "font-bold"; }
            else if (adjustedLen < 6) { baseSizeMultiplier = 1.3; weight = "font-semibold"; }
            else if (adjustedLen < 12) { baseSizeMultiplier = 1.2; weight = "font-normal"; }
            else if (adjustedLen > 40) { baseSizeMultiplier = 0.6; }
            else if (adjustedLen > 30) { baseSizeMultiplier = 0.75; }
            else if (adjustedLen > 22) { baseSizeMultiplier = 0.85; }
            else if (adjustedLen > 16) { baseSizeMultiplier = 0.9; }

            // คำนวณ scale จาก offset (ปุ่ม +/-)
            // offset +1 = +10% scale, offset -1 = -10% scale
            const offsetScale = 1 + (currentOffset * 0.1);

            // scale รวม = baseSizeMultiplier * offsetScale
            const finalScale = baseSizeMultiplier * offsetScale;

            // จำกัด scale ระหว่าง 0.5 - 2.0 เพื่อความปลอดภัย
            const constrainedScale = Math.min(Math.max(0.5, finalScale), 2.0);

            const baseClass = "leading-tight whitespace-normal break-words";

            return {
                className: `${baseClass} ${bold ? 'font-bold' : weight}`,
                style: {
                    fontSize: `${baseSize}px`,  // ล็อคที่ 13px
                    transform: `scale(${constrainedScale})`,
                    transformOrigin: "left top",  // ⭐ ขยายจากซ้ายไปขวา แบบเด็ดขาด
                    display: "inline-block",
                    maxWidth: "fit-content",
                }
            };
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
                        className="border border-black p-0 align-top cursor-pointer hover:bg-blue-50 transition-colors min-h-[70px] h-auto whitespace-normal break-words"
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
                                        <div
                                            className={`text-center font-semibold ${getScaleClass(cellData.subjectCode, span, false, 'top').className}`}
                                            style={getScaleClass(cellData.subjectCode, span, false, 'top').style}
                                            onClick={() => setActiveFontTarget('top')}
                                        >
                                            {cellData.subjectCode}
                                        </div>
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
                                            {cellData.room && <div className={getScaleClass(cellData.room, span, false, 'bottom').className} style={getScaleClass(cellData.room, span, false, 'bottom').style} onClick={() => setActiveFontTarget('bottom')}>{cellData.room}</div>}
                                            {cellData.teacher && <div className={getScaleClass("อ." + cellData.teacher, span, false, 'bottom').className} style={getScaleClass("อ." + cellData.teacher, span, false, 'bottom').style} onClick={() => setActiveFontTarget('bottom')}>อ.{cellData.teacher}</div>}
                                        </div>
                                    ) : (
                                        <div className="flex justify-center items-center gap-1 w-full flex-wrap px-1">
                                            {cellData.teacher && <div className={getScaleClass("อ." + cellData.teacher, span, false, 'bottom').className} style={getScaleClass("อ." + cellData.teacher, span, false, 'bottom').style} onClick={() => setActiveFontTarget('bottom')}>อ.{cellData.teacher}</div>}
                                            {cellData.room && <div className={getScaleClass(cellData.room, span, false, 'bottom').className} style={getScaleClass(cellData.room, span, false, 'bottom').style} onClick={() => setActiveFontTarget('bottom')}>{cellData.room}</div>}
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
                                            <div
                                                className={`w-full text-left whitespace-nowrap leading-tight overflow-hidden ${getScaleClass(cellData.top, cellData.topEndPeriod - current + 1, false, 'top').className}`}
                                                style={getScaleClass(cellData.top, cellData.topEndPeriod - current + 1, false, 'top').style}
                                                onClick={() => setActiveFontTarget('top')}
                                            >
                                                {cellData.top}
                                            </div>
                                        </div>
                                    </div>

                                    {/* ✅ Vertical Line - อิงจาก parent, ชดเชย padding */}
                                    {((cellData.topEndPeriod - current + 1) < span) && (
                                        <div
                                            className="absolute top-0 bottom-0 pointer-events-none"
                                            style={{
                                                width: '1px',
                                                backgroundColor: 'black',
                                                left: `calc(${((cellData.topEndPeriod - current + 1) / span) * 100}% - 0.25rem)`,  // ชดเชย pl-1
                                                zIndex: 40
                                            }}
                                        />
                                    )}
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
                                <div className="flex justify-center items-center text-center w-full leading-none z-10 bg-white text-[12px] whitespace-nowrap overflow-hidden">
                                    {cellData.centralRoom && (
                                        <span className="font-normal whitespace-normal break-words leading-none px-1" style={{ fontSize: "10px" }}>
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
                                            gridColumn: `span ${cellData.bottomEndPeriod - current + 1}`,
                                            // ✅ ใช้ borderRight แทน absolute div
                                            borderRight: ((cellData.bottomEndPeriod - current + 1) < span) ? '1px solid black' : 'none'
                                        }}
                                    >
                                        <div className="w-full overflow-hidden">
                                            <div
                                                className={`w-full text-left whitespace-nowrap leading-tight overflow-hidden ${getScaleClass(cellData.bottom, cellData.bottomEndPeriod - current + 1, false, 'bottom').className}`}
                                                style={getScaleClass(cellData.bottom, cellData.bottomEndPeriod - current + 1, false, 'bottom').style}
                                                onClick={() => setActiveFontTarget('bottom')}
                                            >
                                                {cellData.bottom}
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        ) : (
                            /* === Normal Layout === */
                            <div className="w-full h-[70px] flex flex-col justify-between leading-tight p-0">
                                {/* ข้อความด้านบน - ชิดซ้ายด้านบน */}
                                {hasTop && (
                                    <div className="w-full text-left px-1 pt-1 flex-1 basis-0 flex flex-col justify-center">
                                        <div className={`${getScaleClass(cellData.top, span, false, 'top').className}`} style={getScaleClass(cellData.top, span, false, 'top').style} onClick={() => setActiveFontTarget('top')}>{cellData.top}</div>
                                    </div>
                                )}

                                {/* เส้นขั้นแนวนอนระหว่างข้อความ พร้อมลูกศร */}
                                {hasTop && hasBottom && (
                                    <div className="w-full flex items-center justify-center my-[2px]">
                                        <svg width="6" height="6" viewBox="0 0 10 10" className="flex-shrink-0"><path d="M10 0 L0 5 L10 10 Z" fill="black" stroke="none" /></svg>
                                        <div className="flex-1 border-t border-solid border-black h-px"></div>
                                        <svg width="6" height="6" viewBox="0 0 10 10" className="flex-shrink-0"><path d="M0 0 L10 5 L0 10 Z" fill="black" stroke="none" /></svg>
                                    </div>
                                )}

                                {/* ข้อความด้านล่าง - แยก layout สำหรับ Samarn และ CTN */}
                                {hasBottom && (
                                    cellData.isSamarn ? (
                                        <div className="w-full text-right pl-1 pr-2 pb-0.5 flex-1 basis-0 flex flex-col justify-end items-end">
                                            <div className={`${getScaleClass(cellData.room + " " + cellData.teacherGroup, span, false, 'bottom').className}`} style={getScaleClass(cellData.room + " " + cellData.teacherGroup, span, false, 'bottom').style} onClick={() => setActiveFontTarget('bottom')}>
                                                {cellData.room} {cellData.teacherGroup}
                                            </div>
                                        </div>
                                    ) : cellData.isCTN ? (
                                        <div className="w-full text-left px-1 pb-1 flex-1 flex flex-col justify-center">
                                            <div className={`${getScaleClass(cellData.room + " " + cellData.teacherGroup, span, false, 'bottom').className}`} style={getScaleClass(cellData.room + " " + cellData.teacherGroup, span, false, 'bottom').style} onClick={() => setActiveFontTarget('bottom')}>
                                                {cellData.room} {cellData.teacherGroup}
                                            </div>
                                        </div>
                                    ) : (
                                        <div className="w-full text-left px-1 pb-1 flex-1 flex flex-col justify-center">
                                            <div className={`${getScaleClass(cellData.bottom, span, false, 'bottom').className}`} style={getScaleClass(cellData.bottom, span, false, 'bottom').style} onClick={() => setActiveFontTarget('bottom')}>{cellData.bottom}</div>
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
                                    className={`flex items-center gap-2 ${isEditMode ? 'bg-orange-600 hover:bg-orange-700' : 'bg-green-600 hover:bg-green-700'} text-white px-3 py-1.5 rounded shadow text-sm font-medium transition-colors`}
                                >
                                    <Save size={16} />
                                    {isEditMode ? 'บันทึกการแก้ไข' : 'บันทึกลง Database'}
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

                                            // The useEffect listening to headerInfo.infoid will handle the fetching
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

                    {/* Font Control & Header */}
                    {/* ✅ RE-ENABLED: ใช้ CSS Transform Scale ตารางไม่ยืดหด */}
                    <div className="flex justify-end items-center gap-2 mb-2 print:hidden">
                        <div className="flex bg-gray-100 rounded p-1 text-sm border border-gray-300">
                            <button
                                onClick={() => setActiveFontTarget('top')}
                                className={`px-2 py-0.5 rounded ${activeFontTarget === 'top' ? 'bg-white shadow text-blue-600 font-bold' : 'text-gray-500 hover:bg-gray-200'}`}
                            >
                                ปรับส่วนบน
                            </button>
                            <button
                                onClick={() => setActiveFontTarget('bottom')}
                                className={`px-2 py-0.5 rounded ${activeFontTarget === 'bottom' ? 'bg-white shadow text-blue-600 font-bold' : 'text-gray-500 hover:bg-gray-200'}`}
                            >
                                ปรับส่วนล่าง
                            </button>
                        </div>
                        <div className="flex gap-1">
                            <button
                                onClick={() => setFontOffsets(prev => ({ ...prev, [activeFontTarget]: (prev[activeFontTarget] || 0) - 1 }))}
                                className="bg-gray-200 hover:bg-gray-300 text-gray-800 px-3 py-1 rounded text-sm w-8"
                                title="ลดขนาด"
                            >
                                -
                            </button>
                            <span className="flex items-center justify-center text-sm font-medium w-6 text-center">
                                {fontOffsets[activeFontTarget] > 0 ? '+' : ''}{fontOffsets[activeFontTarget] || 0}
                            </span>
                            <button
                                onClick={() => setFontOffsets(prev => ({ ...prev, [activeFontTarget]: (prev[activeFontTarget] || 0) + 1 }))}
                                className="bg-gray-200 hover:bg-gray-300 text-gray-800 px-3 py-1 rounded text-sm w-8"
                                title="เพิ่มขนาด"
                            >
                                +
                            </button>
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
                    {/* 🔒 LOCKED TABLE: ล็อคขนาดตาราง ไม่ให้ยืดหด */}
                    <div
                        className="mb-8"
                        style={{
                            width: '1300px',  /* ล็อคความกว้างตาราง */
                            maxWidth: '1300px',
                            minWidth: '1300px',
                            overflow: 'visible',  /* ให้เห็นทั้งหมด */
                            transform: 'scale(1)',  /* ป้องกันการ zoom */
                            transformOrigin: 'top left',
                            zoom: '1',  /* บังคับ zoom 100% */
                        }}
                    >
                        <table
                            className="border-collapse border border-black text-center leading-tight"
                            style={{
                                width: '1300px',  /* ล็อคความกว้างตาราง */
                                tableLayout: 'fixed',  /* ล็อค layout ตาราง */
                                fontSize: '13px',  /* ล็อคขนาดตัวอักษร */
                                minWidth: '1300px',
                                maxWidth: '1300px',
                            }}
                        >



                            <thead>
                                <tr className="bg-white h-[48px]">
                                    <th className="border border-black p-1 align-middle" style={{ width: '100px', minWidth: '100px', maxWidth: '100px', fontSize: '13px' }}>เวลา</th>
                                    <th className="border border-black p-1" style={{ width: '100px', minWidth: '100px', maxWidth: '100px', fontSize: '13px' }}>
                                        07.30
                                        <br />
                                        08.00
                                    </th>
                                    <th className="border border-black p-1" style={{ width: '100px', minWidth: '100px', maxWidth: '100px', fontSize: '13px' }}>
                                        08.00
                                        <br />
                                        09.00
                                    </th>
                                    <th className="border border-black p-1" style={{ width: '100px', minWidth: '100px', maxWidth: '100px', fontSize: '13px' }}>
                                        09.00
                                        <br />
                                        10.00
                                    </th>
                                    <th className="border border-black p-1" style={{ width: '100px', minWidth: '100px', maxWidth: '100px', fontSize: '13px' }}>
                                        10.00
                                        <br />
                                        11.00
                                    </th>
                                    <th className="border border-black p-1" style={{ width: '100px', minWidth: '100px', maxWidth: '100px', fontSize: '13px' }}>
                                        11.00
                                        <br />
                                        12.00
                                    </th>
                                    <th className="border border-black p-1" style={{ width: '100px', minWidth: '100px', maxWidth: '100px', fontSize: '13px' }}>
                                        12.00
                                        <br />
                                        13.00
                                    </th>
                                    <th className="border border-black p-1" style={{ width: '100px', minWidth: '100px', maxWidth: '100px', fontSize: '13px' }}>
                                        13.00
                                        <br />
                                        14.00
                                    </th>
                                    <th className="border border-black p-1" style={{ width: '100px', minWidth: '100px', maxWidth: '100px', fontSize: '13px' }}>
                                        14.00
                                        <br />
                                        15.00
                                    </th>
                                    <th className="border border-black p-1" style={{ width: '100px', minWidth: '100px', maxWidth: '100px', fontSize: '13px' }}>
                                        15.00
                                        <br />
                                        16.00
                                    </th>
                                    <th className="border border-black p-1" style={{ width: '100px', minWidth: '100px', maxWidth: '100px', fontSize: '13px' }}>
                                        16.00
                                        <br />
                                        17.00
                                    </th>
                                    <th className="border border-black p-1" style={{ width: '100px', minWidth: '100px', maxWidth: '100px', fontSize: '13px' }}>
                                        17.00
                                        <br />
                                        18.00
                                    </th>
                                    <th className="border border-black p-1" style={{ width: '100px', minWidth: '100px', maxWidth: '100px', fontSize: '13px' }}>
                                        18.00
                                        <br />
                                        19.00
                                    </th>
                                </tr>
                                <tr className="bg-white h-[40px]">
                                    <th className="border border-black p-1 align-middle" style={{ fontSize: '13px' }}>วัน / คาบ</th>
                                    <th className="border border-black p-1" style={{ width: '100px', minWidth: '100px', maxWidth: '100px', fontSize: '13px' }}></th>
                                    <th className="border border-black p-1" style={{ width: '100px', minWidth: '100px', maxWidth: '100px', fontSize: '13px' }}>1</th>
                                    <th className="border border-black p-1" style={{ width: '100px', minWidth: '100px', maxWidth: '100px', fontSize: '13px' }}>2</th>
                                    <th className="border border-black p-1" style={{ width: '100px', minWidth: '100px', maxWidth: '100px', fontSize: '13px' }}>3</th>
                                    <th className="border border-black p-1" style={{ width: '100px', minWidth: '100px', maxWidth: '100px', fontSize: '13px' }}>4</th>
                                    <th className="border border-black p-1" style={{ width: '100px', minWidth: '100px', maxWidth: '100px', fontSize: '13px' }}>พัก</th>
                                    <th className="border border-black p-1" style={{ width: '100px', minWidth: '100px', maxWidth: '100px', fontSize: '13px' }}>5</th>
                                    <th className="border border-black p-1" style={{ width: '100px', minWidth: '100px', maxWidth: '100px', fontSize: '13px' }}>6</th>
                                    <th className="border border-black p-1" style={{ width: '100px', minWidth: '100px', maxWidth: '100px', fontSize: '13px' }}>7</th>
                                    <th className="border border-black p-1" style={{ width: '100px', minWidth: '100px', maxWidth: '100px', fontSize: '13px' }}>8</th>
                                    <th className="border border-black p-1" style={{ width: '100px', minWidth: '100px', maxWidth: '100px', fontSize: '13px' }}>9</th>
                                    <th className="border border-black p-1" style={{ width: '100px', minWidth: '100px', maxWidth: '100px', fontSize: '13px' }}>10</th>
                                </tr>
                            </thead>

                            <tbody>
                                {DAYS.map((day) => (
                                    <tr key={day} className="h-[70px] align-top" style={{ height: '70px', minHeight: '70px', maxHeight: '70px' }}>
                                        <td className="border border-black p-2 font-bold" style={{ width: '100px', minWidth: '100px', maxWidth: '100px', fontSize: '13px' }}>{day}</td>

                                        {/* เสาธง (เฉพาะวันจันทร์ rowSpan 5 หรือ render ทุกวัน? ตามโค้ดเดิมคือ rowSpan 5 ที่วันจันทร์) */}
                                        {day === "จันทร์" && (
                                            <td rowSpan={5} className="border border-black p-1 overflow-hidden h-[350px] max-h-[350px]" style={{ width: '100px', minWidth: '100px', maxWidth: '100px', fontSize: '12px' }}>
                                                <div className="h-full flex items-center justify-center transform -rotate-90 text-[12px] whitespace-nowrap" style={{ fontSize: '12px' }}>
                                                    กิจกรรมหน้าเสาธง / หัวหน้าแผนก
                                                </div>
                                            </td>
                                        )}

                                        {/* คาบ 1-4 */}
                                        {renderPeriodRange(day, 1, 4)}

                                        {/* พักเที่ยง (เฉพาะวันจันทร์ rowSpan 5) */}
                                        {day === "จันทร์" && (
                                            <td rowSpan={5} className="border border-black p-1 overflow-hidden h-[350px] max-h-[350px]" style={{ width: '100px', minWidth: '100px', maxWidth: '100px', fontSize: '12px' }}>
                                                <div className="h-full flex items-center justify-center transform -rotate-90 text-[12px] whitespace-nowrap" style={{ fontSize: '12px' }}>
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
                                                <div>
                                                    <label className="block mb-1 text-xs font-semibold">รหัสวิชา <span className="text-red-500 text-[10px]">(เลือกจากรายการ)</span></label>
                                                    <input
                                                        name="subjectCode"
                                                        value={editor.subjectCode}
                                                        readOnly
                                                        className="w-full border border-gray-300 rounded px-2 py-1 bg-gray-100 text-gray-500 cursor-not-allowed"
                                                    />
                                                </div>
                                                <div>
                                                    <label className="block mb-1 text-xs font-semibold">ชื่อวิชา</label>
                                                    <input
                                                        name="subjectName"
                                                        value={editor.subjectName}
                                                        readOnly
                                                        className="w-full border border-gray-300 rounded px-2 py-1 bg-gray-100 text-gray-500 cursor-not-allowed"
                                                    />
                                                </div>
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
                                        <div className="py-2 text-center border-b">
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
                                                <div>
                                                    <label className="block mb-1 text-xs font-semibold">รหัสวิชา <span className="text-red-500 text-[10px]">(เลือกจากรายการ)</span></label>
                                                    <input
                                                        name="subjectCode2"
                                                        value={editor.subjectCode2}
                                                        readOnly
                                                        className="w-full border border-gray-300 rounded px-2 py-1 bg-gray-100 text-gray-500 cursor-not-allowed"
                                                    />
                                                </div>
                                                <div>
                                                    <label className="block mb-1 text-xs font-semibold">ชื่อวิชา</label>
                                                    <input
                                                        name="subjectName2"
                                                        value={editor.subjectName2}
                                                        readOnly
                                                        className="w-full border border-gray-300 rounded px-2 py-1 bg-gray-100 text-gray-500 cursor-not-allowed"
                                                    />
                                                </div>
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
                                                            const [code, name, cid] = val.split("|");
                                                            setEditor(prev => ({ ...prev, subjectCode: code, subjectName: name, courseid: cid }));
                                                        }
                                                    }}
                                                >
                                                    <option value="">-- เลือกรายวิชา --</option>
                                                    {availableSubjects.map((subj, i) => (
                                                        <option key={`top-2-${subj.course_code}-${i}`} value={`${subj.course_code}|${subj.course_name}|${subj.courseid}`}>
                                                            {subj.course_code} - {subj.course_name}
                                                        </option>
                                                    ))}
                                                </select>
                                            </div>
                                            <div>
                                                <label className="block mb-1 text-xs font-semibold pl-1">รหัสวิชา <span className="text-red-500 text-[10px]">(เลือกจากรายการ)</span></label>
                                                <input
                                                    name="subjectCode"
                                                    value={editor.subjectCode}
                                                    readOnly
                                                    className="w-full border border-gray-300 rounded px-2 py-1 bg-gray-100 text-gray-500 cursor-not-allowed"
                                                />
                                            </div>
                                            <div>
                                                <label className="block mb-1 text-xs font-semibold pl-1">ชื่อวิชา</label>
                                                <input
                                                    name="subjectName"
                                                    value={editor.subjectName}
                                                    readOnly
                                                    className="w-full border border-gray-300 rounded px-2 py-1 bg-gray-100 text-gray-500 cursor-not-allowed"
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
                                                        <option key={`bottom-2-${subj.course_code}-${i}`} value={`${subj.course_code}|${subj.course_name}|${subj.courseid}`}>
                                                            {subj.course_code} - {subj.course_name}
                                                        </option>
                                                    ))}
                                                </select>
                                            </div>
                                            <div>
                                                <label className="block mb-1 text-xs font-semibold pl-1">รหัสวิชา <span className="text-red-500 text-[10px]">(เลือกจากรายการ)</span></label>
                                                <input
                                                    name="subjectCode2"
                                                    value={editor.subjectCode2}
                                                    readOnly
                                                    className="w-full border border-gray-300 rounded px-2 py-1 bg-gray-100 text-gray-500 cursor-not-allowed"
                                                />
                                            </div>
                                            <div>
                                                <label className="block mb-1 text-xs font-semibold pl-1">ชื่อวิชา</label>
                                                <input
                                                    name="subjectName2"
                                                    value={editor.subjectName2}
                                                    readOnly
                                                    className="w-full border border-gray-300 rounded px-2 py-1 bg-gray-100 text-gray-500 cursor-not-allowed"
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
                                            <label className="block mb-1">รหัสวิชา <span className="text-red-500 text-[10px]">(เลือกจากรายการ)</span></label>
                                            <input
                                                name="subjectCode"
                                                value={editor.subjectCode}
                                                readOnly
                                                className="w-full border border-gray-300 rounded px-2 py-1 bg-gray-100 text-gray-500 cursor-not-allowed"
                                                placeholder="เลือกจาก Auto Fill"
                                            />
                                        </div>
                                        <div>
                                            <label className="block mb-1">ชื่อวิชา</label>
                                            <input
                                                name="subjectName"
                                                value={editor.subjectName}
                                                readOnly
                                                className="w-full border border-gray-300 rounded px-2 py-1 bg-gray-100 text-gray-500 cursor-not-allowed"
                                                placeholder="เลือกจาก Auto Fill"
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
                                            <select className="w-full border rounded px-2 py-1 text-xs" onChange={(e) => { const val = e.target.value; if (val) { const [code, name, cid] = val.split("|"); setEditor(prev => ({ ...prev, subjectCode: code, subjectName: name, courseid: cid })); } }}>
                                                <option value="">-- เลือกรายวิชา --</option>
                                                {availableSubjects.map((subj, i) => (<option key={`single-${subj.course_code}-${i}`} value={`${subj.course_code}|${subj.course_name}|${subj.courseid}`}>{subj.course_code} - {subj.course_name}</option>))}
                                            </select>
                                        </div>
                                        <div>
                                            <label className="block mb-1 font-semibold">รหัสวิชา <span className="text-red-500 text-[10px]">(เลือกจากรายการ)</span></label>
                                            <input
                                                name="subjectCode"
                                                value={editor.subjectCode}
                                                readOnly
                                                className="w-full border border-gray-300 rounded px-2 py-1 bg-gray-100 text-gray-500 cursor-not-allowed"
                                                placeholder="เลือกจาก Auto Fill"
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
                                            <label className="block mb-1">รหัสวิชา <span className="text-red-500 text-[10px]">(เลือกจากรายการ)</span></label>
                                            <input
                                                name="subjectCode"
                                                value={editor.subjectCode}
                                                readOnly
                                                className="w-full border border-gray-300 rounded px-2 py-1 bg-gray-100 text-gray-500 cursor-not-allowed"
                                                placeholder="เลือกจาก Auto Fill"
                                            />
                                        </div>
                                        <div>
                                            <label className="block mb-1">ชื่อวิชา</label>
                                            <input
                                                name="subjectName"
                                                value={editor.subjectName}
                                                readOnly
                                                className="w-full border border-gray-300 rounded px-2 py-1 bg-gray-100 text-gray-500 cursor-not-allowed"
                                                placeholder="เลือกจาก Auto Fill"
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
