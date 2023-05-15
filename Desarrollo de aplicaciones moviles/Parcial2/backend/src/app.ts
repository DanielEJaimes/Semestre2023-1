import express from "express";
import bodyParser from "body-parser";
import router from "./routes/route";

const app = express();

app.use(bodyParser.json());

app.use("/api", router);

module.exports = app;
