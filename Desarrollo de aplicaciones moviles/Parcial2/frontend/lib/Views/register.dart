// ignore_for_file: empty_catches

import 'dart:convert';
import 'dart:io';
import 'package:frontend/Views/home.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:frontend/Views/login.dart';
import 'package:get/get.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/fmc.dart';
import '../Models/user.dart';

String cloudname = dotenv.get('CLOUDINARY_CLOUDNAME');
String preset = dotenv.get('CLOUDINARY_PRESET');
String api = dotenv.get('API');

final cloudinary = CloudinaryPublic(cloudname, preset);
Future<String?> uploadImageToCloudinary(File imageFile) async {
  try {
    final response = await cloudinary.uploadFile(
      CloudinaryFile.fromFile(imageFile.path),
    );

    return response.secureUrl;
  } catch (e) {
    return null;
  }
}

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  late String _email, _password, _fullName, _phoneNumber, _position, _imageUrl;
  File? _image;
  late SharedPreferences prefs;
  late String firebasetoken;

  @override
  void initState() {
    super.initState();
    loadEnv();
  }

  Future<void> loadEnv() async {
    await dotenv.load();
    firebasetoken = (await storage.read(key: 'firebasetoken'))!;
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> _pickImage(ImageSource source) async {
    // ignore: deprecated_member_use
    final pickedImage = await ImagePicker().getImage(source: source);
    setState(() {
      _image = File(pickedImage!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrarse'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Nombre completo'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor ingrese su nombre completo';
                    }
                    return null;
                  },
                  onSaved: (value) => _fullName = value!,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Número telefónico'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor ingrese su número telefónico';
                    }
                    return null;
                  },
                  onSaved: (value) => _phoneNumber = value!,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Cargo'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor ingrese su cargo';
                    }
                    return null;
                  },
                  onSaved: (value) => _position = value!,
                ),
                const SizedBox(height: 16.0),
                Column(
                  children: [
                    if (_image != null)
                      Image.file(
                        _image!,
                        width: 200,
                        height: 200,
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            _pickImage(ImageSource.gallery);
                          },
                          icon: const Icon(Icons.image),
                          label: const Text('Subir imagen'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            _pickImage(ImageSource.camera);
                          },
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Tomar foto'),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32.0),
                ElevatedButton(
                  child: const Text('Registrarse'),
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
                                Text('Registrando...'),
                              ],
                            ),
                          ),
                        );
                      },
                    );

                    try {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState?.save();
                        if (_image != null) {
                          _imageUrl = (await uploadImageToCloudinary(_image!))!;
                        } else {
                          throw Exception('Debe seleccionar una imagen');
                        }
                        final user = UserModel(
                          email: _email,
                          name: _fullName,
                          phoneNumber: _phoneNumber,
                          position: _position,
                          photoUrl: _imageUrl,
                          password: _password,
                        );
                        final response = await http.post(
                          Uri.parse('$api/api/registration'),
                          body: jsonEncode(user),
                          headers: {'Content-Type': 'application/json'},
                        );
                        if (response.statusCode == 200) {
                          // El usuario ha sido creado con éxito
                          Get.back();

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
                        } else {
                          // Ocurrió un error al crear el usuario
                        }
                      }
                    } catch (e) {}
                  },
                ),
                TextButton(
                  child: const Text('Ya tengo una cuenta. Iniciar sesión.'),
                  onPressed: () {
                    Get.to(const Login());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
