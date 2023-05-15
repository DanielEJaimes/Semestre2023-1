"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const userModel_1 = __importDefault(require("../models/userModel"));
const push_notifications_1 = require("../controller/push-notifications");
const UserController_1 = require("../controller/UserController");
const FmcController_1 = require("../controller/FmcController");
const MessageController_1 = require("../controller/MessageController");
const fmcModel_1 = __importDefault(require("../models/fmcModel"));
const router = express_1.default.Router();
router.post("/registration", UserController_1.register);
router.post("/login", UserController_1.login);
router.post("/fmc", FmcController_1.registerFMC);
router.post("/message", MessageController_1.registerMessage);
//Obtener usuario por email
router.get("/users/:email", (req, res) => {
    const email = req.params.email;
    userModel_1.default
        .findOne({ email: email })
        .then((data) => res.json(data))
        .catch((error) => res.json({ message: error }));
});
//Obtener usuarios excepto el del email
router.get("/users/exclude/:email", (req, res) => {
    const excludedEmail = req.params.email;
    userModel_1.default
        .find({ email: { $ne: excludedEmail } })
        .then((data) => res.json(data))
        .catch((error) => res.json({ message: error }));
});
//Obtener fmcs
router.get("/fmc/:emailUser", (req, res) => {
    const emailUser = req.params.emailUser;
    fmcModel_1.default.find({ emailUser: emailUser })
        .then((data) => res.json(data))
        .catch((error) => res.json({ message: error }));
});
//Actualizar fmc
router.put("/fmc/:fmcToken", (req, res) => {
    const fmcToken = req.params.fmcToken;
    const emailUser = req.body.emailUser;
    fmcModel_1.default.findOneAndUpdate({ fmcToken: fmcToken }, { emailUser }, { upsert: true, new: true })
        .then((data) => res.json(data))
        .catch((error) => res.json({ message: error }));
});
router.post("/notification", push_notifications_1.sendPushNotification);
exports.default = router;
