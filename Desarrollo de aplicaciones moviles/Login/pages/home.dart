import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_application_1/exports.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    isLoggedIn();
  }

  isLoggedIn() async {
    var session = await SharedService.isLoggedIn();
    if (session) {
      Navigator.pushNamed(context, '/secondPage');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: _desingLogin(context),
        ),
      ),
    );
  }

  Widget _desingLogin(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network('https://bit.ly/3IuzUS8',
                          width: 220, fit: BoxFit.contain),
                    ],
                  ),
                ),
                Column(
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _passController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Password'),
                      obscureText: true, /* <-- Aquí */
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    SizedBox(
                      height: 50,
                      width: 250,
                      child: ElevatedButton(
                          onPressed: () => submit(),
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25))),
                          child: const Text(
                            "Login",
                            style: TextStyle(fontSize: 24),
                          )),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void submit() async {
    if (validate()) {
      LoginRequestModel model = LoginRequestModel(
          email: _emailController.text, password: _passController.text);
      final response = await APIService.login(model);
      if (response == 0) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SecondPage()));
      } else if (response == 1) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('Error'),
                  content: const Text('Usuario o contraseña incorrecta'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Ok')),
                  ],
                ));
      } else {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('Error'),
                  content: const Text('Ocurrió un error. Intente más tarde'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Ok')),
                  ],
                ));
      }
    }
  }

  bool validate() {
    RegExp emailValidator = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

    if (_emailController.text == '' || _passController.text == '') {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Debes llenar todos los campos'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Ok')),
          ],
        ),
      );

      return false;
    }

    if (!emailValidator.hasMatch(_emailController.text)) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Error'),
                content: const Text('Email inválido'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Ok')),
                ],
              ));
      return false;
    }
    return true;
  }
}
