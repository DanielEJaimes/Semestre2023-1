import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import './Views/home.dart';
import './Views/register.dart';
import './Views/login.dart';
import './Views/profile.dart';

void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
// Secure Storage
  const storage = FlutterSecureStorage();
// SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
// Firebase initialize
  String? firebasetoken;
  await Firebase.initializeApp();
  String? firebaseToken = await FirebaseMessaging.instance.getToken();
  firebasetoken = firebaseToken;
  print(firebasetoken);

  if (firebasetoken != null) {
    storage.write(key: 'firebasetoken', value: firebasetoken);
  }
  // Aplicación en segundo plano
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    Get.to(Home(token: token!), arguments: firebasetoken);
  });
  // Aplicación cerrada
  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      Get.to(Home(token: token!), arguments: firebasetoken);
    }

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  });
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'showModalBottomSheet',
    home:
        token != null && JwtDecoder.isExpired(token) == false // Sesión iniciada
            ? Home(token: token)
            : const Login(),
    getPages: [
      GetPage(
          name: '/home',
          page: () => const Home(
                token: '',
              )),
      GetPage(name: '/login', page: () => const Login()),
      GetPage(name: '/register', page: () => const Register()),
      GetPage(
          name: '/profile',
          page: () => Profile(
                // ignore: null_check_always_fails
                user: null!,
              )),
    ],
  ));
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('_firebaseMessagingBackgroundHandler: $message');
}
