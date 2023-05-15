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
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const userModel_1 = __importDefault(require("../models/userModel"));
const userModel_2 = __importDefault(require("../models/userModel"));
class UserService {
    static registerUser(email, name, phoneNumber, position, photoUrl, password) {
        return __awaiter(this, void 0, void 0, function* () {
            try {
                const createUser = new userModel_2.default({
                    email,
                    name,
                    phoneNumber,
                    position,
                    photoUrl,
                    password,
                });
                return yield createUser.save();
            }
            catch (e) {
                throw e;
            }
        });
    }
    static checkEmail(email) {
        return __awaiter(this, void 0, void 0, function* () {
            try {
                const user = yield userModel_1.default.findOne({ email });
                return user !== null; // Retorna true si el correo está registrado, false si no lo está
            }
            catch (error) {
                throw error;
            }
        });
    }
    static check(email) {
        return __awaiter(this, void 0, void 0, function* () {
            try {
                return yield userModel_1.default.findOne({ email });
            }
            catch (error) {
                throw error;
            }
        });
    }
    static generateToken(tokenData, secretKey, jwt_expire) {
        return __awaiter(this, void 0, void 0, function* () {
            return jsonwebtoken_1.default.sign(tokenData, secretKey, { expiresIn: jwt_expire });
        });
    }
}
exports.default = UserService;
