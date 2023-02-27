import 'package:flutter/material.dart';

class Vista2 extends StatelessWidget {
  const Vista2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('Second Route'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: TextButton.styleFrom(
              foregroundColor: Colors.black, backgroundColor: Colors.red),
          child: const Text('Volver Segundo Método'),
        ),
      ),
    );
  }
}
