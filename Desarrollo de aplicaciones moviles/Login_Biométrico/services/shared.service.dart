import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/exports.dart';

class SharedService {
  static late SharedPreferences contain;

  static Future<void> setUp() async {
    contain = await SharedPreferences.getInstance();
  }

  static Future<bool> isLoggedIn() async {
    bool isKeyExists = contain.containsKey('token');

    if (isKeyExists) {
      String token = contain.getString('token') ?? 'default';
      return await APIService.isValidToken(token);
    } else {
      return false;
    }
  }

  static Future<void> setLogginDetails(LoginResponseModel model) async {
    var name = model.name ?? 'default';
    var token = model.token ?? 'default';
    if (name != 'default' && token != 'default') {
      await contain.setString('name', name);
      await contain.setString('token', token);
    }
  }
}
