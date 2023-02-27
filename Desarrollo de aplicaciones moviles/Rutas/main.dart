import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'vista1.dart';
import 'vista2.dart';
import 'vista3.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: 'Rutas',
      home: const Base(),
      routes: {'/segunda': (context) => const Vista2()},
    ),
  );
}

class Base extends StatelessWidget {
  const Base({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Inicio'),
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 300),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Vista1()),
                  );
                },
                style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.amber),
                child: const Text('Primer método'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/segunda');
                },
                style: TextButton.styleFrom(
                    foregroundColor: Colors.black, backgroundColor: Colors.red),
                child: const Text('Segundo método'),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.to(const Vista3());
                },
                style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.lightBlue),
                child: const Text('Tercer método'),
              ),
            ],
          ),
        ));
  }
}
