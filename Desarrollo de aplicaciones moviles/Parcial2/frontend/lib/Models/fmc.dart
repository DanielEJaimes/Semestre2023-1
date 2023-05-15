class FmcModel {
  String emailUser;
  String fmcToken;

  FmcModel({
    required this.emailUser,
    required this.fmcToken,
  });

  factory FmcModel.fromJson(Map<String, dynamic> json) {
    return FmcModel(
      emailUser: json['emailUser'],
      fmcToken: json['fmcToken'],
    );
  }

  Map<String, dynamic> toJson() =>
      {'emailUser': emailUser, 'fmcToken': fmcToken};
}
