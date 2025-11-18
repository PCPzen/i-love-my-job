import React, { useState } from "react";
import { School } from "lucide-react";
// import Swal from "sweetalert2"; // สมมติว่ามีการติดตั้ง sweetalert2

function Studentroomadd() {
	const [formData, setFormData] = useState({
		room_name: "",
		building: "",
		capacity: 0,
		room_type: "Lecture", // ประเภทห้อง: Lecture, Lab
	});

	const handleChange = (e) => {
		const { name, value } = e.target;
		setFormData((prevState) => ({ ...prevState, [name]: value }));
	};

	const handleSubmit = (e) => {
		e.preventDefault();
		console.log("Room data to submit:", formData);
		
		// TODO: เพิ่ม Logic สำหรับส่งข้อมูลไปยัง API 
		// (เช่น axios.post(`${import.meta.env.VITE_API}/api/POST/InsertRoom.php`, formData))
		
		/*
		Swal.fire({
			icon: "success",
			title: "บันทึกข้อมูลสำเร็จ",
			text: "ข้อมูลห้องเรียนถูกเพิ่มในระบบแล้ว (จำลอง)",
			showConfirmButton: false,
			timer: 1500
		});
		*/

		// ล้างฟอร์ม (ทางเลือก)
		setFormData({
			room_name: "",
			building: "",
			capacity: 0,
			room_type: "Lecture",
		});
	};

	return (
		<div className="container mx-auto px-4 py-8">
			<div className="flex items-center gap-4 mb-6">
				<h1 className="text-3xl font-bold text-gray-800">เพิ่มข้อมูลห้องเรียน</h1>
				<School className="w-8 h-8 text-green-600" />
			</div>

			<div className="bg-white p-6 rounded-lg shadow-md max-w-2xl">
				<form onSubmit={handleSubmit} className="space-y-4">
					{/* แถวที่ 1: ชื่อห้อง, ตึก */}
					<div className="grid grid-cols-1 md:grid-cols-2 gap-4">
						<div>
							<label
								htmlFor="room_name"
								className="block text-sm font-medium text-gray-700"
							>
								ชื่อห้อง / เลขที่ห้อง
							</label>
							<input
								type="text"
								name="room_name"
								id="room_name"
								value={formData.room_name}
								onChange={handleChange}
								className="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500"
								required
								placeholder="เช่น 19-301 หรือ Lab Com 1"
							/>
						</div>
						<div>
							<label
								htmlFor="building"
								className="block text-sm font-medium text-gray-700"
							>
								อาคาร
							</label>
							<input
								type="text"
								name="building"
								id="building"
								value={formData.building}
								onChange={handleChange}
								className="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500"
								placeholder="เช่น อาคาร 19, อาคารอำนวยการ"
							/>
						</div>
					</div>

					{/* แถวที่ 2: ความจุ, ประเภทห้อง */}
					<div className="grid grid-cols-1 md:grid-cols-2 gap-4">
						<div>
							<label
								htmlFor="capacity"
								className="block text-sm font-medium text-gray-700"
							>
								ความจุ (คน)
							</label>
							<input
								type="number"
								name="capacity"
								id="capacity"
								value={formData.capacity}
								onChange={handleChange}
								className="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500"
								min="0"
							/>
						</div>
						<div>
							<label
								htmlFor="room_type"
								className="block text-sm font-medium text-gray-700"
							>
								ประเภทห้อง
							</label>
							<select
								name="room_type"
								id="room_type"
								value={formData.room_type}
								onChange={handleChange}
								className="mt-1 block w-full px-3 py-2 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500"
							>
								<option value="Lecture">ห้องบรรยาย (Lecture)</option>
								<option value="Lab">ห้องปฏิบัติการ (Lab)</option>
								<option value="Meeting">ห้องประชุม</option>
								<option value="Other">อื่นๆ</option>
							</select>
						</div>
					</div>

					{/* ปุ่ม Submit */}
					<div className="flex justify-end pt-4">
						<button
							type="submit"
							className="px-6 py-2 bg-blue-600 text-white font-semibold rounded-md shadow-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition duration-200"
						>
							บันทึกข้อมูลห้องเรียน
						</button>
					</div>
				</form>
			</div>
		</div>
	);
}

export default Studentroomadd;