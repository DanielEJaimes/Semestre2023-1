import 'package:flutter/material.dart';
import 'package:flutter_application_1/values/tema.dart';
import 'package:flutter_application_1/exports.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedService.setUp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: miTema(context),
      title: 'LAB LOGIN',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => HomePage(),
      },
    );
  }
}
