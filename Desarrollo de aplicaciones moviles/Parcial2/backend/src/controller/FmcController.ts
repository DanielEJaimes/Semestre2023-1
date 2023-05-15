import FmcService from "../services/FmcService";

export const registerFMC = async (req: { body: any }, res: any) => {
  try {
    const { emailUser, fmcToken } = req.body;

    const successRes = await FmcService.registerFMC(emailUser, fmcToken);
    res.json({ status: true, success: "FMC registrado correctamente" });
  } catch (error) {
    throw error;
  }
};

module.exports = {
  registerFMC: registerFMC,
};
