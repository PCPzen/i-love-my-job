import api from "./api";

export const insertSchedule = async (scheduleData) => {
    try {
        const response = await api.post("/api/POST/InsertSchedule.php", scheduleData);
        return response.data;
    } catch (error) {
        console.error("Error inserting schedule:", error);
        throw error;
    }
};
