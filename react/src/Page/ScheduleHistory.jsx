import React, { useState, useEffect } from "react";
import Sidebar from "../components/Sidebar";
import api from "../services/api"; // Access direct API for custom history call
import { useNavigate } from "react-router-dom";
import { Search, Eye } from "lucide-react";

export default function ScheduleHistory() {
    const [history, setHistory] = useState([]);
    const [filtered, setFiltered] = useState([]);
    const [filters, setFilters] = useState({ year: "", level: "", term: "" });
    const navigate = useNavigate();

    useEffect(() => {
        fetchHistory();
    }, []);

    const fetchHistory = async () => {
        try {
            const res = await api.get("/api/GET/GetScheduleHistory.php");
            if (Array.isArray(res.data)) {
                setHistory(res.data);
                setFiltered(res.data);
            }
        } catch (err) {
            console.error("Failed to fetch history:", err);
        }
    };

    // Filter logic
    useEffect(() => {
        let res = history;
        if (filters.year) res = res.filter(h => h.year.includes(filters.year));
        if (filters.level) res = res.filter(h => h.sublevel.includes(filters.level));
        if (filters.term) res = res.filter(h => h.term == filters.term);
        setFiltered(res);
    }, [filters, history]);

    return (
        <div className="flex min-h-screen bg-gray-50">
            <Sidebar />
            <main className="flex-1 lg:ml-64 p-6">
                <div className="bg-white p-6 rounded-lg shadow-lg min-h-[calc(100vh-3rem)]">
                    <h2 className="text-2xl font-bold mb-6 text-gray-800 flex items-center gap-2 border-b pb-4">
                        <Search className="w-6 h-6 text-blue-600" />
                        ประวัติการจัดตารางเรียน
                    </h2>

                    {/* Filters */}
                    <div className="bg-blue-50 p-6 rounded-xl mb-8 shadow-sm border border-blue-100">
                        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <div>
                                <label className="block text-sm font-semibold mb-2 text-gray-700">ปีการศึกษา</label>
                                <input
                                    type="text"
                                    placeholder="ค้นหาปีการศึกษา..."
                                    className="w-full border border-gray-300 p-2.5 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all outline-none"
                                    value={filters.year}
                                    onChange={e => setFilters({ ...filters, year: e.target.value })}
                                />
                            </div>
                            <div>
                                <label className="block text-sm font-semibold mb-2 text-gray-700">ระดับชั้น</label>
                                <select
                                    className="w-full border border-gray-300 p-2.5 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none"
                                    value={filters.level}
                                    onChange={e => setFilters({ ...filters, level: e.target.value })}
                                >
                                    <option value="">ทั้งหมด</option>
                                    <option value="ปวช.">ปวช.</option>
                                    <option value="ปวส.">ปวส.</option>
                                </select>
                            </div>
                            <div>
                                <label className="block text-sm font-semibold mb-2 text-gray-700">เทอม</label>
                                <select
                                    className="w-full border border-gray-300 p-2.5 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none"
                                    value={filters.term}
                                    onChange={e => setFilters({ ...filters, term: e.target.value })}
                                >
                                    <option value="">ทั้งหมด</option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    {/* List View */}
                    <div className="space-y-4">
                        {filtered.length > 0 ? (
                            filtered.map((item, idx) => (
                                <div
                                    key={idx}
                                    className="bg-white border rounded-lg p-4 hover:shadow-md transition-all duration-200 flex flex-col md:flex-row justify-between items-center gap-4 group"
                                >
                                    <div className="flex-1 text-center md:text-left">
                                        <h3 className="text-lg font-medium text-gray-800 leading-relaxed">
                                            ตารางสอนชั้นเรียน ระดับชั้น <span className="text-blue-600 font-bold">{item.sublevel}</span>
                                            {" "}แผนกวิชา <span className="font-semibold">{item.department}</span>
                                            {" "}กลุ่ม <span className="text-blue-600 font-bold">{item.group_section}</span>
                                            {" "}จำนวนนักเรียน <span className="font-semibold">{item.student_count || '-'}</span> คน
                                            {" "}ภาคเรียนที่ <span className="font-semibold">{item.term}</span>
                                            {" "}ปีการศึกษา <span className="font-semibold">{item.year}</span>
                                        </h3>
                                    </div>
                                    <div className="flex-shrink-0">
                                        <button
                                            onClick={() => navigate(`/view-schedule/${item.infoid}/${item.term}?group=${item.group_section}`)}
                                            className="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 shadow-sm transition-all flex items-center gap-2 font-medium group-hover:bg-blue-700"
                                        >
                                            <Eye size={18} />
                                            ดูตารางเรียน
                                        </button>
                                    </div>
                                </div>
                            ))
                        ) : (
                            <div className="text-center py-12 bg-gray-50 rounded-lg border-2 border-dashed border-gray-200">
                                <p className="text-gray-500 text-lg">ไม่พบข้อมูลประวัติการจัดตารางเรียน</p>
                            </div>
                        )}
                    </div>
                </div>
            </main>
        </div>
    );
}
