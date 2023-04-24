import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home.dart';
import 'package:share/share.dart';

class Compartir extends StatelessWidget {
  const Compartir({super.key});

  @override
  Widget build(BuildContext context) {
    File img = Get.arguments as File;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compartir'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.to(() => const Home());
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.file(
              img,
              width: 200,
              height: 200,
            ),
            ElevatedButton(
              onPressed: () {
                Share.shareFiles([img.path]);
              },
              child: const Text('Compartir'),
            ),
          ],
        ),
      ),
    );
  }
}
