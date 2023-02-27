import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Vista3 extends StatelessWidget {
  const Vista3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Text('Third Route'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Get.back();
          },
          style: TextButton.styleFrom(
              foregroundColor: Colors.black, backgroundColor: Colors.lightBlue),
          child: const Text('Volver Tercer Método'),
        ),
      ),
    );
  }
}
