import 'package:flutter/material.dart';
import 'compartir.dart';
import 'home.dart';
import 'package:get/get.dart';

void main() {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'showModalBottomSheet',
    home: const Home(),
    getPages: [
      GetPage(name: '/view1', page: () => const Compartir()),
    ],
  ));
}