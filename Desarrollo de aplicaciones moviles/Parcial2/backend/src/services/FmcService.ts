import fmcModel from "../models/fmcModel";

class FmcService {
  static async registerFMC(emailUser: String, fmcToken: String) {
    try {
      const createFMC = new fmcModel({
        emailUser,
        fmcToken,
      });
      return await createFMC.save();
    } catch (e) {
      throw e;
    }
  }
}

export default FmcService;
