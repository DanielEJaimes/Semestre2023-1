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
exports.login = exports.register = void 0;
const UserService_1 = __importDefault(require("../services/UserService"));
const register = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { email, name, phoneNumber, position, photoUrl, password } = req.body;
        const isEmailRegistered = yield UserService_1.default.checkEmail(email);
        if (isEmailRegistered) {
            return res.json({ status: false, error: "El correo ya está registrado" });
        }
        const successRes = yield UserService_1.default.registerUser(email, name, phoneNumber, position, photoUrl, password);
        res.json({ status: true, success: "Usuario registrado correctamente" });
    }
    catch (error) {
        throw error;
    }
});
exports.register = register;
const login = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { email, password } = req.body;
        const user = yield UserService_1.default.check(email);
        if (!user) {
            return res
                .status(404)
                .json({ status: false, message: "Usuario no encontrado" });
        }
        const isMatch = yield user.comparePassword(password);
        if (!isMatch) {
            return res
                .status(401)
                .json({ status: false, message: "Contraseña incorrecta" });
        }
        let tokenData = { _id: user._id, email: user.email };
        const token = yield UserService_1.default.generateToken(tokenData, "secretKey", "1h");
        res.status(200).json({ status: true, token: token });
    }
    catch (error) {
        console.log(error);
        res.status(500).json({ status: false, message: "Error en el servidor" });
    }
});
exports.login = login;
module.exports = {
    register: exports.register,
    login: exports.login,
};
