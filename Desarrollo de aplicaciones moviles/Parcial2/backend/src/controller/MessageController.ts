import MessageService from "../services/MessageService";

export const registerMessage = async (req: { body: any }, res: any) => {
  try {
    const { sender, receiver, content } = req.body;

    const successRes = await MessageService.registerMessage(
      sender,
      receiver,
      content
    );
    res.json({ status: true, success: "Mensaje registrado correctamente" });
  } catch (error) {
    throw error;
  }
};

module.exports = {
  registerMessage: registerMessage,
};
