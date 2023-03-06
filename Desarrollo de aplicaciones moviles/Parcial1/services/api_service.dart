import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:parcial/config.dart';
import 'package:parcial/models/login_response_model.dart';
import 'package:parcial/models/login_request_model.dart';
import 'package:parcial/services/shared_service.dart';
import 'package:parcial/models/products.dart';

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
          .timeout(const Duration(seconds: 5));
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
        .timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<List<Product>> getProducts() async {
    Uri url = Uri.http(Config.apiURL, Config.getProducts);
    final header = {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*'
    };
    var token = SharedService.prefs.getString('token');
    final response = await http
        .post(url, headers: header, body: jsonEncode({'token': token}))
        .timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      List<Product> productList =
          jsonList.map((json) => Product.fromJson(json)).toList();
      return productList;
    } else {
      return [];
    }
  }

  static Future<Product?> getProductById(String idOffer) async {
    Uri url = Uri.http(Config.apiURL, Config.getProductById);
    final header = {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*'
    };
    var token = SharedService.prefs.getString('token');
    final response = await http
        .post(url,
            headers: header, body: jsonEncode({'id': idOffer, 'token': token}))
        .timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      var offer = jsonDecode(response.body);
      offer = offer['offer'];
      return Product.fromJson(offer);
    } else {
      return null;
    }
  }

  static Future<List<Product>> getFavorites() async {
    Uri url = Uri.http(Config.apiURL, Config.getFavorites);
    final header = {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*'
    };
    var token = SharedService.prefs.getString('token');
    var id = SharedService.prefs.getString('id');
    final response = await http
        .post(url,
            headers: header, body: jsonEncode({'idUser': id, 'token': token}))
        .timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final List<dynamic> offersJson = json['offers'];
      List<Product> productList = offersJson.map((offerJson) => Product.fromJson(offerJson)).toList();
      return productList;
    } else {
      return [];
    }
  }

  static Future<int> addFavorite(String idUser, String idOffer) async {
    Uri url = Uri.http(Config.apiURL, Config.addFavorite);
    final header = {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*'
    };
    var token = SharedService.prefs.getString('token');
    final response = await http
        .post(url,
            headers: header,
            body: jsonEncode(
                {'idUser': idUser, 'idOffer': idOffer, 'token': token}))
        .timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      return 0;
    } else if (response.statusCode == 410) {
      bool success = await removeFavorite(idUser, idOffer, token);
      if (success) {
        return 1;
      } else {
        return -1;
      }
    }
    return -1;
  }

  static Future<bool> removeFavorite(
      String idUser, String idOffer, String? token) async {
    Uri url = Uri.http(Config.apiURL, Config.removeFavorite);
    final header = {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*'
    };
    final response = await http
        .post(url,
            headers: header,
            body: jsonEncode(
                {'idUser': idUser, 'idOffer': idOffer, 'token': token}))
        .timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
  
  static Future<bool> updateFavorites(List<String> favoritesListIds) async {
    Uri url = Uri.http(Config.apiURL, Config.updateFavorite);
    final header = {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*'
    };
    var token = SharedService.prefs.getString('token');
    var id = SharedService.prefs.getString('id');
    final response = await http
        .post(url,
            headers: header, body: jsonEncode({'ids': favoritesListIds, 'idUser': id, 'token': token}))
        .timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

}
