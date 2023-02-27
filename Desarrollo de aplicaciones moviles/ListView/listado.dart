import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/user.dart';
import 'package:flutter_application_1/usuario.dart';
import 'package:http/http.dart' as http;

Future<List<User>> getAllUsers() async {
  const url = 'https://api.npoint.io/bffbb3b6b3ad5e711dd2';
  var response = await http.get(Uri.parse(url));
  var jsonData = json.decode(response.body);
  var jsonArray = jsonData['items'];
  List<User> personas = [];
  for (var jsonUser in jsonArray) {
    User persona = User(jsonUser['imagen'], jsonUser['nombre'],
        jsonUser['carrera'], jsonUser['promedio']);
    personas.add(persona);
  }
  return personas;
}

class Listado extends StatefulWidget {
  const Listado({super.key});

  @override
  State<Listado> createState() => _ListadoState();
}

class _ListadoState extends State<Listado> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(title: const Text('Lista de usuarios')),
            body: FutureBuilder<List<User>>(
                future: getAllUsers(),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    List<User> personas = snapshot.data!;
                    return ListView.builder(
                      itemCount: personas.length,
                      itemBuilder: (context, index) {
                        return Usuario(personas[index]);
                      },
                    );
                  }
                })));
  }
}
