import 'dart:convert';

LoginResponseModel loginResponseModel(String str) {
  return LoginResponseModel.fromJson(jsonDecode(str));
}

class LoginResponseModel {
  String? name;
  String? email;
  String? token;

  LoginResponseModel({this.name, this.token, this.email});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    name = json['email'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = name;
    data['token'] = token;
    return data;
  }
}
