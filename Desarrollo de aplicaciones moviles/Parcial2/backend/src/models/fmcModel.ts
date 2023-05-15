import { Schema, model } from "mongoose";
import db from "../config/mongo";

const fmcSchema: Schema = new Schema({
  emailUser: {
    type: String,
    required: true,
  },
  fmcToken: {
    type: String,
    required: true,
  },
});

const FmcModel = model("Fmc", fmcSchema);

export default FmcModel;
