import api from "./api";

export const getTeachers = async () => {
    try {
        const response = await api.get("/api/GET/get_teachers.php");
        // Ensure we always return an array
        return Array.isArray(response.data) ? response.data : [];
    } catch (error) {
        console.error("Error fetching teachers:", error);
        return [];
    }
};

export const getRooms = async () => {
    try {
        const response = await api.get("/api/GET/get_rooms.php");
        return Array.isArray(response.data) ? response.data : [];
    } catch (error) {
        console.error("Error fetching rooms:", error);
        return [];
    }
};

export const getGroupInformation = async () => {
    try {
        const response = await api.get("/api/GET/Get_group_information.php");
        return Array.isArray(response.data) ? response.data : [];
    } catch (error) {
        console.error("Error fetching group information:", error);
        return [];
    }
};

export const getCourseInfo = async (id) => {
    console.log("📡 [getCourseInfo] Called with ID:", id);

    if (!id) {
        console.warn("⚠️ [getCourseInfo] No ID provided, returning empty array");
        return [];
    }

    try {
        const url = `/api/GET/Getcourse.php?infoid=${id}`;
        console.log("🌐 [getCourseInfo] API URL:", url);

        const response = await api.get(url);

        console.log("✅ [getCourseInfo] Response received");
        console.log("   Raw data:", response.data);
        console.log("   Is Array:", Array.isArray(response.data));
        console.log("   Count:", Array.isArray(response.data) ? response.data.length : 0);

        if (Array.isArray(response.data) && response.data.length > 0) {
            console.log("   Sample:", response.data.slice(0, 2).map(item => ({
                subject_code: item.subject_code,
                subject_name: item.subject_name,
                term: item.term
            })));
        }

        return Array.isArray(response.data) ? response.data : [];
    } catch (error) {
        console.error("❌ [getCourseInfo] Error:", error);
        console.error("   Error details:", {
            message: error.message,
            response: error.response?.data,
            status: error.response?.status
        });
        return [];
    }
};
