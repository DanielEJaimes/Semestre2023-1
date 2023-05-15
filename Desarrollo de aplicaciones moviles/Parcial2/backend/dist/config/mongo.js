"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const dotenv_1 = __importDefault(require("dotenv"));
const mongoose_1 = __importDefault(require("mongoose"));
dotenv_1.default.config();
const connection = mongoose_1.default
    .connect(process.env.MONGODB_URI)
    .then(() => {
    console.log("DB: Mongo connection");
})
    .catch((err) => {
    console.log("Error connecting MongoDB: ", err);
});
exports.default = connection;
