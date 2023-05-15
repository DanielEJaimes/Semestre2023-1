import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/Views/login.dart';
import 'package:frontend/Views/profile.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:get/get.dart';
import '../Models/user.dart';
import 'package:http/http.dart' as http;

String api = dotenv.get('API');

class Home extends StatefulWidget {
  final String token;
  const Home({Key? key, required this.token}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  String message = "";
  late String email;
  late SharedPreferences prefs;
  List<ProfileUserModel> _users = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)!.settings.arguments;
    if (arguments != null) {
      Map? pushArguments = arguments as Map;
      setState(() {
        message = pushArguments["message"];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    email = jwtDecodedToken['email'];
    _getUsers();
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> _getUsers() async {
    final response = await http.get(Uri.parse('$api/api/users/exclude/$email'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        _users = data.map((user) => ProfileUserModel.fromJson(user)).toList();
      });
    } else {
      throw Exception('Error al cargar los usuarios');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios registrados'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                _showMessagesModal();
              },
              icon: const Icon(Icons.message)),
          IconButton(
              onPressed: () {
                prefs.remove('token');
                Get.offAll(const Login());
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: _users.isEmpty
          ? const Center(
              child: Text('No hay usuarios registrados'),
            )
          : ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Get.to(() => Profile(user: _users[index]),
                        arguments: email);
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(_users[index].photoUrl),
                    ),
                    title: Text(_users[index].name),
                    subtitle: Text(_users[index].email),
                  ),
                );
              },
            ),
    );
  }

  void _showMessagesModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 600, // Ajusta la altura según tus necesidades
          child: ListView.builder(
            itemCount: message
                .length, // Reemplaza 'message' con tus mensajes recibidos
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(message[
                    index]), // Reemplaza 'message[index]' con la propiedad adecuada de tu modelo de mensaje
              );
            },
          ),
        );
      },
    );
  }
}
