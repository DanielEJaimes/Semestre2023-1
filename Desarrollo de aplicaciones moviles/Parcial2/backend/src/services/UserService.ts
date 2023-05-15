import jwt from "jsonwebtoken";
import UserModel from "../models/userModel";
import userModel from "../models/userModel";

class UserService {
  static async registerUser(
    email: String,
    name: String,
    phoneNumber: String,
    position: String,
    photoUrl: String,
    password: String
  ) {
    try {
      const createUser = new userModel({
        email,
        name,
        phoneNumber,
        position,
        photoUrl,
        password,
      });
      return await createUser.save();
    } catch (e) {
      throw e;
    }
  }

  static async checkEmail(email: string) {
    try {
      const user = await UserModel.findOne({ email });
      return user !== null; // Retorna true si el correo está registrado, false si no lo está
    } catch (error) {
      throw error;
    }
  }

  static async check(email: string) {
    try {
      return await UserModel.findOne({ email });
    } catch (error) {
      throw error;
    }
  }

  static async generateToken(
    tokenData: any,
    secretKey: string,
    jwt_expire: string
  ) {
    return jwt.sign(tokenData, secretKey, { expiresIn: jwt_expire });
  }
}

export default UserService;
