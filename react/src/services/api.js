import axios from "axios";

// API Base configuration
const RAW_BASE = import.meta.env.VITE_API_BASE_URL || "http://localhost/I-LOVE-MY-JOB-MAIN/server";
const API_BASE = RAW_BASE.replace(/\/+$/, "");

const api = axios.create({
    baseURL: API_BASE,
    headers: {
        "Content-Type": "application/json",
    },
});

export default api;
