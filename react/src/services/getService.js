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
    if (!id) return [];
    try {
        // Use Getcourse.php to fetch subjects assigned to a specific Group (infoid)
        const response = await api.get(`/api/GET/Getcourse.php?infoid=${id}`);
        return Array.isArray(response.data) ? response.data : [];
    } catch (error) {
        console.error("Error fetching course info:", error);
        return [];
    }
};
