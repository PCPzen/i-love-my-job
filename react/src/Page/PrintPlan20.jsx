import React from "react";
import Sidebar from "../components/Sidebar";

export default function PrintPlan20() {
    return (
        <div className="flex h-screen bg-gray-50">
            <Sidebar />
            <div className="flex-1 p-8 overflow-auto">
                <div className="max-w-7xl mx-auto">
                    <h1 className="text-3xl font-bold text-gray-800 mb-6">พิมพ์แผนการเรียน 2.0</h1>
                    <div className="bg-white rounded-lg shadow-md p-6">
                        <p className="text-gray-600">
                            หน้านี้กำลังพัฒนา...
                        </p>
                    </div>
                </div>
            </div>
        </div>
    );
}
