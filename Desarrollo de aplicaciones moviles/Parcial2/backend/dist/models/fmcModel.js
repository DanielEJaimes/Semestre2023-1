"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const mongoose_1 = require("mongoose");
const fmcSchema = new mongoose_1.Schema({
    idUser: {
        type: String,
        required: true,
    },
    fmcToken: {
        type: String,
        required: true,
    },
});
const FmcModel = (0, mongoose_1.model)("Fmc", fmcSchema);
exports.default = FmcModel;
