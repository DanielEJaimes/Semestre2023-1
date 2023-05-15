import { Schema, model } from "mongoose";
import db from "../config/mongo";

const messageSchema: Schema = new Schema({
  sender: {
    type: String,
    required: true,
  },
  receiver: {
    type: String,
    required: true,
  },
  content: {
    type: String,
    required: true,
  },
});

const MessageModel = model("Message", messageSchema);

export default MessageModel;
