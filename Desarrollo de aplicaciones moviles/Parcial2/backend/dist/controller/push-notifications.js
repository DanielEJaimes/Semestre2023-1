"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.sendPushNotification = void 0;
const admin = __importStar(require("firebase-admin"));
const serviceAccount = require("../config/push-notification-key.json");
admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
});
const sendPushNotification = (req, res) => {
    try {
        const { title, body, token } = req.body;
        if (!title || !body || !token) {
            return res.status(400).send({
                message: "Title, body, and token are required fields.",
            });
        }
        const message = {
            notification: {
                title,
                body,
            },
            token,
        };
        admin
            .messaging()
            .send(message)
            .then(() => {
            return res.status(200).send({
                message: "Notification Sent",
            });
        })
            .catch((err) => {
            console.error(err);
            return res.status(500).send({
                message: err,
            });
        });
    }
    catch (error) {
        console.error(error);
        return res.status(500).send({
            message: "Internal Server Error",
        });
    }
};
exports.sendPushNotification = sendPushNotification;
