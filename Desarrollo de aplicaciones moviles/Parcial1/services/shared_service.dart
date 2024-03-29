import 'package:parcial/models/login_response_model.dart';
import 'package:parcial/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedService{
  
  static late SharedPreferences prefs;

  static Future<void> setUp() async{
    prefs = await SharedPreferences.getInstance();
  }
  
  static Future<bool> isLoggedIn() async {
    bool isKeyExists = prefs.containsKey('token');
    if(isKeyExists){
      String token = prefs.getString('token') ?? 'default';
      return await APIService.isValidToken(token);
    }else{
      return false;
    }
  }

  static Future<void> setLogginDetails(LoginResponseModel model) async {
    var id = model.id ?? 'default';
    var email = model.email ?? 'default';
    var name= model.name ?? 'default';
    var token = model.token ?? 'default';
    if(name!= 'default' && token != 'default' && email != 'default' && id != 'default'){
      await prefs.setString('id', id);
      await prefs.setString('email', email);
      await prefs.setString('name', name);
      await prefs.setString('token', token);
    }
  }

}