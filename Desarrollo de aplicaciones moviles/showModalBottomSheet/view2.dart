import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/view3.dart';
import 'package:get/get.dart';

class View2 extends StatelessWidget {
  const View2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Vista 2'),
              centerTitle: true,
              leading: IconButton(
                  onPressed: () {
                    Get.to(() => const Home());
                  },
                  icon: const Icon(Icons.arrow_back)),
            ),
            body: const BottomSheetV2()));
  }
}

class BottomSheetV2 extends StatefulWidget {
  const BottomSheetV2({super.key});

  @override
  _BottomSheetV2State createState() => _BottomSheetV2State();
}

class _BottomSheetV2State extends State<BottomSheetV2> {
  String eleccion = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              child: const Text('Mostrar opciones'),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                        builder: ((BuildContext context, StateSetter setState) {
                      return Column(
                        children: <Widget>[
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.purple),
                                  ),
                                  onPressed: () {
                                    eleccion = 'Lila';
                                    Get.to(() => View3(), arguments: eleccion);
                                  },
                                  child: const Text('Botón Lila'),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.red),
                                  ),
                                  onPressed: () {
                                    eleccion = 'Rojo';
                                    Get.to(() => View3(), arguments: eleccion);
                                  },
                                  child: const Text('Botón Rojo'),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.orange),
                                  ),
                                  onPressed: () {
                                    eleccion = 'Naranja';
                                    Get.to(() => View3(), arguments: eleccion);
                                  },
                                  child: const Text('Botón Naranja'),
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cerrar'),
                          ),
                        ],
                      );
                    }));
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
