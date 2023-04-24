import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'compartir.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().getImage(source: source);
    setState(() {
      _image = File(pickedImage!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Opciones'),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Compartir imagen desde:'),
              Column(
                children: [
                  if (_image != null)
                    Image.file(
                      _image!,
                      width: 200,
                      height: 200,
                    ),
                  if (_image != null)
                    ElevatedButton(onPressed: () {Get.to(const Compartir(),arguments: _image);}, 
                    child: const Text('Compartir')),
                    
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () {
                      _pickImage(ImageSource.camera);
                    },
                    child: const Text('Cámara'),
                    
                  ),ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () {
                      _pickImage(ImageSource.gallery);
                    },
                    child: const Text('Galería'),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
