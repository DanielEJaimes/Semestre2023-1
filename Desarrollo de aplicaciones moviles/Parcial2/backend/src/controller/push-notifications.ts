import * as admin from "firebase-admin";
import { messaging } from "firebase-admin";
const serviceAccount = require("../config/push-notification-key.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const sendPushNotification = (req: any, res: any) => {
  try {
    const { title, body, token } = req.body;

    if (!title || !body || !token) {
      return res.status(400).send({
        message: "Title, body, and token are required fields.",
      });
    }

    const message: messaging.Message = {
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
      .catch((err: any) => {
        console.error(err);
        return res.status(500).send({
          message: err,
        });
      });
  } catch (error) {
    console.error(error);
    return res.status(500).send({
      message: "Internal Server Error",
    });
  }
};

export { sendPushNotification };
