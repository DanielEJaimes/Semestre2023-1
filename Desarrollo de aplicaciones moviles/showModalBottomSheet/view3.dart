import 'package:flutter/material.dart';
import 'package:flutter_application_1/view2.dart';
import 'package:get/get.dart';

class View3 extends StatelessWidget {
  View3({super.key});

  @override
  Widget build(BuildContext context) {
    String eleccion = Get.arguments as String;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Vista 3'),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Get.to(() => const View2());
              },
              icon: const Icon(Icons.arrow_back)),
        ),
        body: Center(child: Text('Botón presionado: $eleccion')));
  }
}
