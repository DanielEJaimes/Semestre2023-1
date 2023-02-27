import 'package:flutter/material.dart';

class Vista1 extends StatelessWidget {
  const Vista1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Primer método'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: TextButton.styleFrom(
              foregroundColor: Colors.black, backgroundColor: Colors.amber),
          child: const Text('Volver Primer Método'),
        ),
      ),
    );
  }
}
