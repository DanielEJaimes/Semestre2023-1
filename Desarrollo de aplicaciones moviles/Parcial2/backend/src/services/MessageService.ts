import messageModel from "../models/messageModel";

class MessageService {
  static async registerMessage(
    sender: String,
    receiver: String,
    content: String
  ) {
    try {
      const createFMC = new messageModel({
        sender,
        receiver,
        content,
      });
      return await createFMC.save();
    } catch (e) {
      throw e;
    }
  }
}

export default MessageService;
