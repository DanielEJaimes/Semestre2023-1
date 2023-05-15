import dotenv from "dotenv";
import mongoose from "mongoose";

dotenv.config();

const connection = mongoose
  .connect(process.env.MONGODB_URI!)
  .then(() => {
    console.log("DB: Mongo connection");
  })
  .catch((err) => {
    console.log("Error connecting MongoDB: ", err);
  });

export default connection;
