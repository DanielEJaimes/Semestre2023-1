import * as dotenv from "dotenv";
const app = require("./app");
const db = require("./config/mongo");

dotenv.config();
const PORT = process.env.PORT || 2323;

app.listen(PORT, () => {
  console.log("Server running on port", PORT);
});
