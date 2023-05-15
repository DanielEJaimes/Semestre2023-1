"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.registerMessage = void 0;
const MessageService_1 = __importDefault(require("../services/MessageService"));
const registerMessage = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { sender, receiver, content } = req.body;
        const successRes = yield MessageService_1.default.registerMessage(sender, receiver, content);
        res.json({ status: true, success: "Mensaje registrado correctamente" });
    }
    catch (error) {
        throw error;
    }
});
exports.registerMessage = registerMessage;
module.exports = {
    registerMessage: exports.registerMessage,
};
