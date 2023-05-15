import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/Views/register.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../Models/fmc.dart';
import '../Models/user.dart';
import 'home.dart';

String api = dotenv.get('API');
const storage = FlutterSecureStorage();

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  late String _email, _password;

  late SharedPreferences prefs;
  late String firebasetoken;

  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    firebasetoken = (await storage.read(key: 'firebasetoken'))!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar sesión'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Correo electrónico'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese su correo electrónico';
                  }
                  return null;
                },
                onSaved: (value) => _email = value!,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese su contraseña';
                  }
                  return null;
                },
                onSaved: (value) => _password = value!,
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                child: const Text('Iniciar sesión'),
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              CircularProgressIndicator(),
                              SizedBox(width: 16.0),
                              Text('Iniciando sesión...'),
                            ],
                          ),
                        ),
                      );
                    },
                  );

                  try {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState?.save();
                      final user = LoginUserModel(
                        email: _email,
                        password: _password,
                      );
                      final fmc = FmcModel(
                        emailUser: _email,
                        fmcToken: firebasetoken,
                      );
                      final response = await http.post(
                        Uri.parse('$api/api/login'),
                        body: jsonEncode(user),
                        headers: {'Content-Type': 'application/json'},
                      );
                      if (response.statusCode == 200) {
                        // El usuario ha iniciado sesión con éxito
                        var myToken = jsonDecode(response.body)['token'];
                        prefs.setString('token', myToken);
                        final firebasetokenResponse = await http.put(
                          Uri.parse('$api/api/fmc/${fmc.fmcToken}'),
                          body: jsonEncode(fmc),
                          headers: {'Content-Type': 'application/json'},
                        );

                        if (firebasetokenResponse.statusCode == 200) {
                          // El firebasetoken se guardó correctamente en la base de datos
                        } else {
                          // Ocurrió un error al guardar el firebasetoken en la base de datos
                          Get.back();
                        }
                        Get.back();
                        Get.to(() => Home(
                              token: myToken,
                            ));
                      } else {
                        Get.back();
                        // Ocurrió un error al iniciar sesión
                      }
                    }
                    // ignore: empty_catches
                  } catch (e) {}
                },
              ),
              TextButton(
                child: const Text('Registrarse'),
                onPressed: () {
                  Get.to(const Register());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
