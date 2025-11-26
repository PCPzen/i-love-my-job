
import React, { useState } from 'react';
import Sidebar from '../components/Sidebar';

export default function ScheduleCreate() {
  // State for header information
  const [headerInfo, setHeaderInfo] = useState({
    level: 'ปวช.3',
    department: 'ช่างเทคนิคคอมพิวเตอร์',
    group: '1-2',
    studentCount: '',
    term: '2',
    year: '2568'
  });

  const handleChange = (e) => {
    const { name, value } = e.target;
    setHeaderInfo(prev => ({
      ...prev,
      [name]: value
    }));
  };

  return (
    <div className="min-h-screen flex bg-gray-50">
      <Sidebar />
      <main className="flex-1 lg:ml-64 p-6 overflow-x-auto">
        <div className="min-w-[1000px] bg-white p-6 shadow-lg rounded-lg">

          {/* Input Form Section */}
          <div className="mb-6 p-4 bg-blue-50 rounded-lg border border-blue-100">
            <h3 className="text-lg font-bold text-blue-800 mb-3">กรอกข้อมูลหัวตาราง</h3>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700">ระดับชั้น</label>
                <select
                  name="level"
                  value={headerInfo.level}
                  onChange={handleChange}
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
                <label className="block text-sm font-medium text-gray-700">แผนกวิชา</label>
                <select
                  name="department"
                  value={headerInfo.department}
                  onChange={handleChange}
                  className="mt-1 block w-full border border-gray-300 rounded-md shadow-sm p-2 focus:ring-blue-500 focus:border-blue-500"
                >
                  <option value="ช่างเทคนิคคอมพิวเตอร์">ช่างเทคนิคคอมพิวเตอร์</option>
                </select>
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700">กลุ่ม</label>
                <select
                  name="group"
                  value={headerInfo.group}
                  onChange={handleChange}
                  className="mt-1 block w-full border border-gray-300 rounded-md shadow-sm p-2 focus:ring-blue-500 focus:border-blue-500"
                >
                  <option value="1">1</option>
                  <option value="2">2</option>
                  <option value="1-2">1-2</option>
                  <option value="3">3</option>
                </select>
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700">จำนวนนักเรียน (คน)</label>
                <input
                  type="number"
                  name="studentCount"
                  value={headerInfo.studentCount}
                  onChange={handleChange}
                  className="mt-1 block w-full border border-gray-300 rounded-md shadow-sm p-2 focus:ring-blue-500 focus:border-blue-500"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700">ภาคเรียนที่</label>
                <select
                  name="term"
                  value={headerInfo.term}
                  onChange={handleChange}
                  className="mt-1 block w-full border border-gray-300 rounded-md shadow-sm p-2 focus:ring-blue-500 focus:border-blue-500"
                >
                  <option value="1">1</option>
                  <option value="2">2</option>
                </select>
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700">ปีการศึกษา</label>
                <input
                  type="text"
                  name="year"
                  value={headerInfo.year}
                  onChange={handleChange}
                  className="mt-1 block w-full border border-gray-300 rounded-md shadow-sm p-2 focus:ring-blue-500 focus:border-blue-500"
                />
              </div>
            </div>
          </div>

          {/* Header Section Display */}
          <div className="text-center mb-4">
            <h1 className="text-xl font-bold">วิทยาลัยเทคนิคแพร่</h1>
            <h2 className="text-lg">
              ตารางสอนชั้นเรียน ระดับชั้น <span className="text-blue-600 font-semibold ">{headerInfo.level}</span>
              {' '}แผนกวิชา <span className="text-blue-600 font-semibold ">{headerInfo.department}</span>
              {' '}กลุ่ม <span className="text-blue-600 font-semibold ">{headerInfo.group}</span>
              {' '}จำนวนนักเรียน <span className="text-blue-600 font-semibold ">{headerInfo.studentCount}</span> คน
            </h2>
            <h3 className="text-md">
              ภาคเรียนที่ <span className="text-blue-600 font-semibold ">{headerInfo.term}</span>
              {' '}ปีการศึกษา <span className="text-blue-600 font-semibold ">{headerInfo.year}</span>
            </h3>
          </div>

          {/* Schedule Table */}
          <table className="w-full border-collapse border border-black text-center text-sm">
            <thead>
              {/* Time Header Row 1 */}
              <tr className="bg-gray-100">
                <th className="border border-black p-1 w-20">เวลา</th>
                <th className="border border-black p-1">07.30<br />08.00</th>
                <th className="border border-black p-1">08.00<br />09.00</th>
                <th className="border border-black p-1">09.00<br />10.00</th>
                <th className="border border-black p-1">10.00<br />11.00</th>
                <th className="border border-black p-1">11.00<br />12.00</th>
                <th className="border border-black p-1">12.00<br />13.00</th>
                <th className="border border-black p-1">13.00<br />14.00</th>
                <th className="border border-black p-1">14.00<br />15.00</th>
                <th className="border border-black p-1">15.00<br />16.00</th>
                <th className="border border-black p-1">16.00<br />17.00</th>
                <th className="border border-black p-1">17.00<br />18.00</th>
                <th className="border border-black p-1">18.00<br />19.00</th>
              </tr>
              {/* Period Number Row */}
              <tr className="bg-gray-100">
                <th className="border border-black p-1">วัน / คาบ</th>
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
              {/* Monday */}
              <tr>
                <td className="border border-black p-2 font-bold bg-gray-50">จันทร์</td>
                <td className="border border-black p-1 rowspan-5 bg-white-50" rowSpan="5">
                  <div className="writing-vertical-lr h-40 mx-auto flex items-center justify-center transform -rotate-90">
                    กิจกรรมหน้าเสาธง / หัวหน้าแผนก
                  </div>
                </td>
                <td className="border border-black p-1" colSpan="2">
                  <div className="text-xs">20000-1208 ภาษาอังกฤษเตรียมความพร้อมฯ</div>
                  <div className="font-bold">อ.ปริรดา</div>
                  <div className="text-xs">721</div>
                </td>
                <td className="border border-black p-1" colSpan="2">
                  <div className="text-xs">20000-1302 วิทยาศาสตร์เพื่อพัฒนาอาชีพฯ</div>
                  <div className="font-bold">อ.อรอนงค์</div>
                  <div className="text-xs">711</div>
                </td>
                <td className="border border-black p-1 rowspan-5 bg-white-50" rowSpan="5">
                  <div className="writing-vertical-lr h-40 mx-auto flex items-center justify-center transform -rotate-90">
                    พักรับประทานอาหารกลางวัน
                  </div>
                </td>
                <td className="border border-black p-1" colSpan="4">
                  <div className="text-xs">20128-2113 ระบบเครือข่ายคอมพิวเตอร์เบื้องต้น</div>
                  <div className="font-bold">อ.เอกชัย / อ.พรประภา</div>
                  <div className="text-xs">Lab Network</div>
                </td>
                <td className="border border-black p-1">
                  <div className="text-xs">20000-1601</div>
                  <div className="font-bold">อ.สุวานนท์</div>
                </td>
                <td className="border border-black p-1"></td>
              </tr>

              {/* Tuesday */}
              <tr>
                <td className="border border-black p-2 font-bold bg-pink-50">อังคาร</td>
                {/* Column 1 (Activity) is rowspan */}
                <td className="border border-black p-1" colSpan="2">
                  <div className="text-xs">20000-1207 ภาษาอังกฤษโครงงาน</div>
                  <div className="font-bold">อ.มเลิกา</div>
                  <div className="text-xs">743</div>
                </td>
                <td className="border border-black p-1" colSpan="2">
                  <div className="text-xs">20000-1604 พลศึกษาเพื่อการพัฒนากายภาพ</div>
                  <div className="font-bold">อ.สุวานนท์</div>
                  <div className="text-xs">สนาม</div>
                </td>
                {/* Lunch is rowspan */}
                <td className="border border-black p-1" colSpan="4">
                  <div className="text-xs">20128-2104 เขียนแบบเทคนิคด้วยคอมพิวเตอร์</div>
                  <div className="font-bold">อ.พรประภา</div>
                  <div className="text-xs">Lab CAD</div>
                </td>
                <td className="border border-black p-1"></td>
                <td className="border border-black p-1"></td>
              </tr>

              {/* Wednesday */}
              <tr>
                <td className="border border-black p-2 font-bold bg-green-50">พุธ</td>
                {/* Column 1 (Activity) is rowspan */}
                <td className="border border-black p-1" colSpan="2">
                  <div className="text-xs">20128-1002 คณิตศาสตร์คอมพิวเตอร์</div>
                  <div className="font-bold">อ.มณีรัตน์</div>
                  <div className="text-xs">Lab Com 1</div>
                </td>
                <td className="border border-black p-1" colSpan="2">
                  <div className="text-xs">20128-8503 โครงงาน 2</div>
                  <div className="font-bold">อ.แดงต้อย</div>
                  <div className="text-xs">Lab Project</div>
                </td>
                {/* Lunch is rowspan */}
                <td className="border border-black p-1">
                  <div className="text-xs">กิจกรรม</div>
                  <div className="font-bold">โฮมรูม</div>
                </td>
                <td className="border border-black p-1" colSpan="2">
                  <div className="text-xs">20000-2007 กิจกรรมส่งเสริมคุณธรรม</div>
                  <div className="font-bold">อ.พิริยะ</div>
                </td>
                <td className="border border-black p-1"></td>
                <td className="border border-black p-1"></td>
                <td className="border border-black p-1"></td>
              </tr>

              {/* Thursday */}
              <tr>
                <td className="border border-black p-2 font-bold bg-orange-50">พฤหัสบดี</td>
                {/* Column 1 (Activity) is rowspan */}
                <td className="border border-black p-1" colSpan="4">
                  <div className="text-xs">20128-2108 โปรแกรมประมวลผลคำ</div>
                  <div className="font-bold">อ.มณีรัตน์</div>
                  <div className="text-xs">Lab Office</div>
                </td>
                {/* Lunch is rowspan */}
                <td className="border border-black p-1" colSpan="3">
                  <div className="text-xs">20128-2114 การพัฒนาโปรแกรมบนอุปกรณ์พกพา</div>
                  <div className="font-bold">อ.พรประภา</div>
                  <div className="text-xs">Lab Mobile</div>
                </td>
                <td className="border border-black p-1" colSpan="2">
                  <div className="text-xs">20000-1302 วิทยาศาสตร์ฯ</div>
                  <div className="font-bold">อ.อรอนงค์</div>
                  <div className="text-xs">711</div>
                </td>
                <td className="border border-black p-1"></td>
              </tr>

              {/* Friday */}
              <tr>
                <td className="border border-black p-2 font-bold bg-blue-50">ศุกร์</td>
                {/* Column 1 (Activity) is rowspan */}
                <td className="border border-black p-1" colSpan="4"></td>
                {/* Lunch is rowspan */}
                <td className="border border-black p-1" colSpan="6"></td>
              </tr>
            </tbody>
          </table>

          <div className="mt-4 text-right text-sm">
            <p>ลงชื่อ .................................................... หัวหน้าแผนกวิชา</p>
            <p className="mt-2">ลงชื่อ .................................................... งานพัฒนาหลักสูตรฯ</p>
            <p className="mt-2">ลงชื่อ .................................................... ผู้อำนวยการวิทยาลัย</p>
          </div>
        </div>
      </main>
    </div>
  );
}

