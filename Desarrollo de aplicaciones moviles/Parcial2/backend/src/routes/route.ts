import express from "express";
import userModel from "../models/userModel";
import { sendPushNotification } from "../controller/push-notifications";
import { register, login } from "../controller/UserController";
import { registerFMC } from "../controller/FmcController";
import { registerMessage } from "../controller/MessageController";
import FmcModel from "../models/fmcModel";

const router = express.Router();

router.post("/registration", register);
router.post("/login", login);
router.post("/fmc", registerFMC);
router.post("/message", registerMessage);
//Obtener usuario por email
router.get("/users/:email", (req, res) => {
  const email = req.params.email;
  userModel
    .findOne({ email: email })
    .then((data) => res.json(data))
    .catch((error) => res.json({ message: error }));
});

//Obtener usuarios excepto el del email
router.get("/users/exclude/:email", (req, res) => {
  const excludedEmail = req.params.email;
  userModel
    .find({ email: { $ne: excludedEmail } })
    .then((data) => res.json(data))
    .catch((error) => res.json({ message: error }));
});
//Obtener fmcs
router.get("/fmc/:emailUser", (req, res) => {
  const emailUser = req.params.emailUser;
  FmcModel.find({ emailUser: emailUser })
    .then((data) => res.json(data))
    .catch((error) => res.json({ message: error }));
});

//Actualizar fmc
router.put("/fmc/:fmcToken", (req, res) => {
  const fmcToken = req.params.fmcToken;
  const emailUser = req.body.emailUser;
  FmcModel.findOneAndUpdate(
    { fmcToken: fmcToken },
    { emailUser },
    { upsert: true, new: true }
  )
    .then((data) => res.json(data))
    .catch((error) => res.json({ message: error }));
});

router.post("/notification", sendPushNotification);

export default router;
