
const axios = require('axios');

async function test() {
    try {
        const res = await axios.get('http://localhost/i-love-my-job-main/server/api/GET/Get_group_information.php');
        console.log("Status:", res.status);
        if (res.data && res.data.length > 0) {
            console.log("First item sample:", JSON.stringify(res.data[0], null, 2));
        } else {
            console.log("No data returned or empty array");
        }
    } catch (e) {
        console.error("Error:", e.message);
    }
}

test();
