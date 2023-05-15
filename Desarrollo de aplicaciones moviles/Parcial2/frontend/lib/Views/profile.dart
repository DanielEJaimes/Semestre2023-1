import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../Models/firebase.dart';
import '../Models/message.dart';
import '../Models/user.dart';

String api = dotenv.get('API');

class Profile extends StatefulWidget {
  final ProfileUserModel user;
  const Profile({super.key, required this.user});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final sender = Get.arguments;
  final _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50.0,
                backgroundImage: NetworkImage(widget.user.photoUrl),
              ),
              const SizedBox(height: 16.0),
              Text(
                widget.user.name,
                style: const TextStyle(
                    fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(
                widget.user.email,
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 8.0),
              Text(
                widget.user.phoneNumber,
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 8.0),
              Text(
                widget.user.position,
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  labelText: 'Escriba su mensaje',
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  // Enviar mensaje
                  String content = _messageController.text.trim();
                  if (content.isNotEmpty) {
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
                                Text('Enviando mensaje...'),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                    try {
                      final responseget = await http
                          .get(Uri.parse('$api/api/fmc/${widget.user.email}'));
                      if (responseget.statusCode == 200) {
                        final dynamic decodedBody =
                            jsonDecode(responseget.body);
                        final List<dynamic> tokens = decodedBody
                            .map((item) => item['fmcToken'])
                            .toList(); // Suponiendo que la respuesta es una lista con un solo objeto y se accede al primer objeto para obtener el valor de 'emailUser'
                        final message = MessageModel(
                          sender: sender,
                          receiver: widget.user.email,
                          content: content,
                        );
                        final firebaseMessages = tokens
                            .map((token) => FirebaseModel(
                                  title: 'Mensaje nuevo!',
                                  body: content,
                                  token: token,
                                ))
                            .toList();
                        final response = await http.post(
                          Uri.parse('$api/api/message'),
                          body: jsonEncode(message),
                          headers: {'Content-Type': 'application/json'},
                        );
                        if (response.statusCode == 200) {
                          for (var firebase in firebaseMessages) {
                            final noti = await http.post(
                              Uri.parse('$api/api/notification'),
                              body: jsonEncode(firebase),
                              headers: {'Content-Type': 'application/json'},
                            );
                            if (noti.statusCode == 200) {
                              //
                            } else {
                              //
                            }
                          }
                          // El mensaje se envió correctamente
                        } else {
                          // Ocurrió un error al enviar el mensaje
                        }
                      }
                    } catch (e) {
                      //
                    } finally {
                      Get.back();
                    }
                    _messageController.clear();
                  }
                },
                child: const Text("Enviar mensaje"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
