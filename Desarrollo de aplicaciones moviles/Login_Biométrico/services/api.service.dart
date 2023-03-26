import 'dart:convert';
import 'package:flutter_application_1/exports.dart';
import 'package:http/http.dart' as http;

class APIService {
  static Future<int> login(LoginRequestModel model) async {
    Uri url = Uri.http(Config.apiURL, Config.loginAPI);

    final header = {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*'
    };

    final dataBody = json.encode(model.toJson());

    try {
      final response = await http
          .post(url, headers: header, body: dataBody)
          .timeout(const Duration(seconds: 3));
      if (response.statusCode == 200) {
        await SharedService.setLogginDetails(loginResponseModel(response.body));
        return 0;
      } else {
        return 1;
      }
    } catch (e) {
      return 2;
    }
  }

  static Future<bool> isValidToken(String token) async {
    Uri url = Uri.http(Config.apiURL, Config.isValidTokenAPI);

    final header = {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*'
    };

    final response = await http
        .post(url, headers: header, body: jsonEncode({'token': token}))
        .timeout(const Duration(seconds: 3));
    print(response.body);
    print(response);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
