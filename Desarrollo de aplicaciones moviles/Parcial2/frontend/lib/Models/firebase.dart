class FirebaseModel {
  String title;
  String body;
  String token;

  FirebaseModel({
    required this.title,
    required this.body,
    required this.token,
  });

  factory FirebaseModel.fromJson(Map<String, dynamic> json) {
    return FirebaseModel(
      title: json['title'],
      body: json['body'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() =>
      {'title': title, 'body': body, 'token': token};
}
