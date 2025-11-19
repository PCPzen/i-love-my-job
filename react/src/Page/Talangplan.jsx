import React, { useState, useEffect } from "react";
import Sidebar from "../components/Sidebar"; // Corrected import path
import axios from "axios";

// Define API base URLs (adjust if needed)
// Ensure VITE_API_BASE_URL is correctly set in your .env files
// Default fallback points to this project served by XAMPP
const RAW_BASE =
  import.meta.env.VITE_API_BASE_URL ||
  "http://localhost/I-LOVE-MY-JOB-MAIN/server";
  const API_GET_BASE = RAW_BASE.replace(/\/+$/, "") + "/api/GET";

export default function TalangPlan() {
	// State variables
	const [allPlans, setAllPlans] = useState([]); // All study plans for the selected year
	const [selectedYear, setSelectedYear] = useState("");
	const [selectedTerm, setSelectedTerm] = useState("");
	const [checkedPlanIds, setCheckedPlanIds] = useState([]); // Keep track of checked plan IDs
	const [selectedCourses, setSelectedCourses] = useState([]); // Courses for the checked plans and term
	const [loadingPlans, setLoadingPlans] = useState(false);
	const [loadingCourses, setLoadingCourses] = useState(false);
	const [errorPlans, setErrorPlans] = useState("");
	const [errorCourses, setErrorCourses] = useState("");

	// --- Fetch Study Plans when Year and Term change ---
	useEffect(() => {
		const fetchStudyPlans = async () => {
			// Only fetch when both year and term are selected
			if (!selectedYear || !selectedTerm) {
				setAllPlans([]); // Clear plans if no year is selected
				setCheckedPlanIds([]); // Clear checks
				setSelectedCourses([]); // Clear courses
				setErrorPlans(""); // Clear previous errors
				return;
			}

			setLoadingPlans(true);
			setErrorPlans("");
			setCheckedPlanIds([]); // Clear checks when year changes
			setSelectedCourses([]); // Clear courses when year changes

			try {
				const url = `${API_GET_BASE}/Getstudyplan.php?year=${encodeURIComponent(selectedYear)}&term=${encodeURIComponent(selectedTerm)}`;
				const res = await axios.get(url);
				// Check if the response data is actually an array
				if (Array.isArray(res.data)) {
				    setAllPlans(res.data);
				} else {
				    console.error("API response for study plans is not an array:", res.data);
				    setAllPlans([]); // Set to empty array if data is not as expected
				    setErrorPlans("รูปแบบข้อมูลหลักสูตรไม่ถูกต้อง");
				}

			} catch (e) {
				console.error("Error fetching study plans:", e);
				// Provide more specific error feedback if possible
				const errorMsg = e.response?.data?.message || "ไม่สามารถโหลดรายการหลักสูตรได้";
				setErrorPlans(errorMsg);
				setAllPlans([]);
			} finally {
				setLoadingPlans(false);
			}
		};

		fetchStudyPlans();
	}, [selectedYear, selectedTerm]); // Re-run when selectedYear or selectedTerm changes

	// --- Fetch Courses when Checked Plans or Term change ---
	useEffect(() => {
		const fetchSelectedCourses = async () => {
			// Only fetch if a term and at least one plan are selected
			if (!selectedTerm || checkedPlanIds.length === 0 || !selectedYear) {
				setSelectedCourses([]); // Clear courses if conditions not met
				setErrorCourses("");
				return;
			}

			setLoadingCourses(true);
			setErrorCourses("");

			try {
				// Convert array of IDs to JSON string for the query parameter
				const planIdsJson = JSON.stringify(checkedPlanIds);
				const url = `${API_GET_BASE}/GetCoursesForScheduling.php?year=${encodeURIComponent(
					selectedYear // Use selectedYear
				)}&term=${encodeURIComponent(selectedTerm)}&planids=${encodeURIComponent(
					planIdsJson
				)}`;

				const res = await axios.get(url);
				console.log("Course API response:", res.data); // Log the response
				// Check if the response data is actually an array
				if (Array.isArray(res.data)) {
				    setSelectedCourses(res.data);
				} else {
				     console.error("API response for courses is not an array:", res.data);
				    setSelectedCourses([]); // Set to empty array if data is not as expected
				    setErrorCourses("รูปแบบข้อมูลรายวิชาไม่ถูกต้อง");
				}

			} catch (e) {
				console.error("Error fetching selected courses:", e);
				const errorMsg = e.response?.data?.message || "ไม่สามารถโหลดข้อมูลรายวิชาที่เลือกได้";
				setErrorCourses(errorMsg);
				setSelectedCourses([]);
			} finally {
				setLoadingCourses(false);
			}
		};

		fetchSelectedCourses();
	}, [checkedPlanIds, selectedTerm, selectedYear]); // Re-run when checkedPlanIds, selectedTerm, or selectedYear change

	// --- Handle Checkbox Changes ---
	const handleCheckboxChange = (planId) => {
		setCheckedPlanIds((prevChecked) => {
			if (prevChecked.includes(planId)) {
				// If already checked, remove it
				return prevChecked.filter((id) => id !== planId);
			} else {
				// If not checked, add it
				return [...prevChecked, planId];
			}
		});
	};

	// --- Get unique years for the dropdown (Example: using a fixed range) ---
	const availableYears = () => {
		const currentBuddhistYear = new Date().getFullYear() + 543; // Buddhist year
		const years = [];
		for (let i = 0; i < 5; i++) { // Generate current year and previous 4 years
			years.push((currentBuddhistYear - i).toString());
		}
		return years;
	};

	// --- Helper function to get term display name ---
	const getTermDisplayName = (termValue) => {
		if (termValue === "1") return "ภาคเรียนที่ 1";
		if (termValue === "2") return "ภาคเรียนที่ 2";
		if (termValue === "summer") return "ภาคเรียนฤดูร้อน";
		return "";
	};

	return (
		<div className="flex min-h-screen bg-gray-50">
			<Sidebar />

			<main className="flex-1 p-6 lg:ml-64">
				<h1 className="text-2xl font-bold text-[#3E3269] mb-6">
					ข้อมูลจัดตารางเรียน
				</h1>

				{/* Select Year and Term */}
				<div className="bg-white shadow rounded-lg p-4 mb-6">
					<div className="grid md:grid-cols-2 gap-4">
						{/* Year Selector */}
						<div className={`transition-all duration-300 ${selectedYear ? 'bg-blue-50 rounded-md p-3 -m-3' : 'p-3 -m-3'}`}>
							<label htmlFor="year-select" className="block font-semibold mb-2 text-gray-700">
								ปีการศึกษา (พุทธศักราช)
							</label>
							<select
                                id="year-select"
								className="border border-gray-300 rounded-md px-3 py-2 w-full focus:ring-blue-500 focus:border-blue-500"
								value={selectedYear}
								onChange={(e) => setSelectedYear(e.target.value)}
							>
								<option value="">-- เลือกปีการศึกษา --</option>
								{availableYears().map((year) => (
									<option key={year} value={year}>
										{year}
									</option>
								))}
							</select>
						</div>

						{/* Term Selector (Highlighted) */}
						<div className={`transition-all duration-300 ${selectedTerm ? 'bg-blue-100 rounded-md p-3 -m-3' : 'p-3 -m-3'}`}>
							<label htmlFor="term-select" className="block font-semibold mb-2 text-gray-700">
								ภาคเรียน
							</label>
							<select
                                id="term-select"
								className="border border-gray-300 rounded-md px-3 py-2 w-full focus:ring-blue-500 focus:border-blue-500"
								value={selectedTerm}
								onChange={(e) => setSelectedTerm(e.target.value)}
								disabled={!selectedYear} // Disable until year is selected
							>
								<option value="">-- เลือกภาคเรียน --</option>
								<option value="1">ภาคเรียนที่ 1</option>
								<option value="2">ภาคเรียนที่ 2</option>
								<option value="summer">ภาคเรียนฤดูร้อน</option> {/* Added Summer */}
							</select>
						</div>
					</div>
				</div>

				{/* Study Plans Table */}
				<div className="bg-white shadow rounded-lg p-4 mb-6">
					<h2 className="text-lg font-semibold text-gray-800 mb-4">
						รายการหลักสูตรที่สร้างไว้ {selectedYear && `ในปีการศึกษา ${selectedYear}`}
						{/* --- MODIFIED: Show selected term --- */}
						{selectedTerm && (
							<span className="text-blue-600 font-bold"> - {getTermDisplayName(selectedTerm)}</span>
						)}
					</h2>
					{/* Display error message if fetching plans failed */}
					{errorPlans && !loadingPlans && (
						<p className="text-center text-red-600 py-6">{errorPlans}</p>
					)}
					{/* Display loading indicator */}
					{loadingPlans && (
						<p className="text-center text-gray-500 py-6">กำลังโหลดข้อมูลหลักสูตร...</p>
					)}
					{/* Display table or 'no data' message */}
					{!loadingPlans && !errorPlans && allPlans.length > 0 && (
						<div className="overflow-x-auto">
							<table className="w-full border-collapse min-w-[600px]"> {/* Added min-width */}
								<thead>
									<tr className="bg-[#3E3269] text-white text-left">
										<th className="p-3 w-16 text-center">เลือก</th>
										{/* <th className="p-3">รหัสแผน</th> <-- Removed this header */}
										<th className="p-3">หลักสูตร</th>
										<th className="p-3">พุทธศักราช</th>
										<th className="p-3">รหัสนักศึกษา</th>
									</tr>
								</thead>
								<tbody>
									{allPlans.map((plan, i) => (
										<tr
											key={plan.planid}
											className={`border-b hover:bg-gray-100 ${
												i % 2 === 0 ? "bg-gray-50" : "bg-white"
											}`}
										>
											<td className="p-3 text-center">
												<input
													type="checkbox"
													className="h-4 w-4 text-blue-600 border-gray-300 rounded focus:ring-blue-500 cursor-pointer disabled:cursor-not-allowed disabled:opacity-50"
													checked={checkedPlanIds.includes(plan.planid)}
													onChange={() => handleCheckboxChange(plan.planid)}
													disabled={!selectedYear || !selectedTerm} // Disable if no year or term selected
												/>
											</td>
											{/* <td className="p-3">{plan.planid}</td> <-- Removed this cell */}
											<td className="p-3">{plan.course || "-"}</td>
											<td className="p-3">{plan.year || "-"}</td>
											<td className="p-3">{plan.student_id || "-"}</td>
										</tr>
									))}
								</tbody>
							</table>
						</div>
					)}
                    {/* Display message if no plans found or year not selected */}
					{!loadingPlans && !errorPlans && allPlans.length === 0 && (
						<p className="text-center text-gray-500 py-6">
							{selectedYear
								? "ไม่พบข้อมูลหลักสูตรในปีการศึกษานี้"
								: "กรุณาเลือกปีการศึกษา"}
						</p>
					)}
				</div>

				{/* Selected Courses Table - Only show if plans are checked and term is selected */}
				{checkedPlanIds.length > 0 && selectedTerm && (
					<div className="bg-white shadow rounded-lg p-4 mt-6">
						<h2 className="text-lg font-semibold text-gray-800 mb-4">
							ข้อมูลรายวิชาสำหรับปีการศึกษา{" "}
							<span className="text-blue-600 font-bold">{selectedYear}</span>{" "}
							{/* --- MODIFIED: Use helper function --- */}
							<span className="text-blue-600 font-bold">{getTermDisplayName(selectedTerm)}</span>
						</h2>

                        {/* Display error message if fetching courses failed */}
						{errorCourses && !loadingCourses && (
							<p className="text-center text-red-600 py-6">{errorCourses}</p>
						)}
                        {/* Display loading indicator */}
						{loadingCourses && (
							<p className="text-center text-gray-500 py-6">กำลังโหลดข้อมูลรายวิชา...</p>
						)}
                        {/* Display course table or 'no data' message */}
						{!loadingCourses && !errorCourses && selectedCourses.length > 0 && (
							<div className="overflow-x-auto">
								<table className="w-full border-collapse min-w-[700px]"> {/* Added min-width */}
									<thead>
										<tr className="bg-gray-200 text-left text-gray-700 text-sm"> {/* Smaller text */}
											<th className="p-2">หลักสูตร (รหัสนักศึกษา)</th> {/* Adjusted header text */}
											<th className="p-2">รหัสวิชา</th>
											<th className="p-2">ชื่อวิชา</th>
											<th className="p-2 text-center">ท-ป-น</th>
											{/* Add more headers if needed */}
										</tr>
									</thead>
									<tbody>
										{selectedCourses.map((course, i) => (
											<tr
												key={`${course.planid}-${course.subject_id}-${i}`} // More unique key
												className={`border-b hover:bg-gray-100 ${
													i % 2 === 0 ? "bg-gray-50" : "bg-white"
												} text-sm`} // Smaller text
											>
												<td className="p-2">{`${course.study_plan_course || '?'} (${course.study_plan_student_id || '?'})`}</td> {/* Added fallback */}
												<td className="p-2">{course.course_code || "-"}</td>
												<td className="p-2">{course.course_name || "-"}</td>
												<td className="p-2 text-center">
													{`${course.theory !== null ? course.theory : '0'}-${course.comply !== null ? course.comply : '0'}-${course.credit !== null ? course.credit : '0'}`} {/* Handle potential nulls */}
												</td>
												{/* Add more cells if needed */}
											</tr>
										))}
									</tbody>
								</table>
							</div>
						)}
                        {/* Display message if no courses found */}
						{!loadingCourses && !errorCourses && selectedCourses.length === 0 && (
							<p className="text-center text-gray-500 py-6">
								ไม่พบข้อมูลรายวิชาสำหรับหลักสูตรและภาคเรียนที่เลือก หรือข้อมูลยังไม่ถูกสร้าง
							</p>
						)}
					</div>
				)}
			</main>
		</div>
	);
}

