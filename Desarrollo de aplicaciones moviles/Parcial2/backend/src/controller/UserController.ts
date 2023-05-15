import UserService from "../services/UserService";

export const register = async (req: { body: any }, res: any) => {
  try {
    const { email, name, phoneNumber, position, photoUrl, password } = req.body;

    const isEmailRegistered = await UserService.checkEmail(email);

    if (isEmailRegistered) {
      return res.json({ status: false, error: "El correo ya está registrado" });
    }

    const successRes = await UserService.registerUser(
      email,
      name,
      phoneNumber,
      position,
      photoUrl,
      password
    );
    res.json({ status: true, success: "Usuario registrado correctamente" });
  } catch (error) {
    throw error;
  }
};

export const login = async (req: { body: any }, res: any) => {
  try {
    const { email, password } = req.body;

    const user = await UserService.check(email);

    if (!user) {
      return res
        .status(404)
        .json({ status: false, message: "Usuario no encontrado" });
    }

    const isMatch = await user.comparePassword(password);
    if (!isMatch) {
      return res
        .status(401)
        .json({ status: false, message: "Contraseña incorrecta" });
    }

    let tokenData = { _id: user._id, email: user.email };

    const token = await UserService.generateToken(tokenData, "secretKey", "1h");
    res.status(200).json({ status: true, token: token });
  } catch (error) {
    console.log(error);
    res.status(500).json({ status: false, message: "Error en el servidor" });
  }
};

module.exports = {
  register: register,
  login: login,
};
