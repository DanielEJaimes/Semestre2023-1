import 'package:flutter/material.dart';
import 'view1.dart';
import 'view2.dart';
import 'view3.dart';
import 'package:get/get.dart';

void main() {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'showModalBottomSheet',
    home: const Home(),
    getPages: [
      GetPage(name: '/view1', page: () => const View1()),
      GetPage(name: '/view2', page: () => const View2()),
      GetPage(name: '/view3', page: () => View3()),
    ],
  ));
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Get.to(() => const View1());
                  },
                  child: const Text('Vista 1')),
              ElevatedButton(
                  onPressed: () {
                    Get.to(() => const View2());
                  },
                  child: const Text('Vista 2'))
            ],
          ),
        ));
  }
}
