class MessageModel {
  String sender;
  String receiver;
  String content;

  MessageModel({
    required this.sender,
    required this.receiver,
    required this.content,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      sender: json['sender'],
      receiver: json['receiver'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() =>
      {'sender': sender, 'receiver': receiver, 'content': content};
}
