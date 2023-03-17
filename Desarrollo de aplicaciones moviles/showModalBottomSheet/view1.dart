import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'main.dart';

class View1 extends StatelessWidget {
  const View1({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Vista 1'),
              centerTitle: true,
              leading: IconButton(
                  onPressed: () {
                    Get.to(() => const Home());
                  },
                  icon: const Icon(Icons.arrow_back)),
            ),
            body: const BottomSheetV1()));
  }
}

class BottomSheetV1 extends StatefulWidget {
  const BottomSheetV1({super.key});

  @override
  _BottomSheetV1State createState() => _BottomSheetV1State();
}

class _BottomSheetV1State extends State<BottomSheetV1> {
  String selectedValue = '';
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
                  isDismissible: false,
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                        builder: ((BuildContext context, StateSetter setState) {
                      return Column(
                        children: <Widget>[
                          RadioListTile(
                              title: const Text('Amarillo'),
                              value: 'Amarillo',
                              selected: selectedValue == 'Amarillo',
                              groupValue: selectedValue,
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() => selectedValue = value);
                                }
                              }),
                          RadioListTile(
                              title: const Text('Azul'),
                              value: 'Azul',
                              selected: selectedValue == 'Azul',
                              groupValue: selectedValue,
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() => selectedValue = value);
                                }
                              }),
                          RadioListTile(
                              title: const Text('Rojo'),
                              value: 'Rojo',
                              selected: selectedValue == 'Rojo',
                              groupValue: selectedValue,
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() => selectedValue = value);
                                }
                              }),
                          RadioListTile(
                              title: const Text('Verde'),
                              value: 'Verde',
                              selected: selectedValue == 'Verde',
                              groupValue: selectedValue,
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() => selectedValue = value);
                                }
                              }),
                          RadioListTile(
                              title: const Text('Naranja'),
                              value: 'Naranja',
                              selected: selectedValue == 'Naranja',
                              groupValue: selectedValue,
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() => selectedValue = value);
                                }
                              }),
                          ElevatedButton(
                            child: const Text('Aceptar'),
                            onPressed: () {
                              setState(() {
                                eleccion = selectedValue;
                              });
                              Navigator.pop(context, selectedValue);
                            },
                          ),
                        ],
                      );
                    }));
                  },
                ).then((value) {
                  if (value != null) {
                    setState(() {
                      eleccion = value;
                    });
                  }
                });
              },
            ),
            if (eleccion.isNotEmpty) Text('Opción seleccionada: $eleccion')
          ],
        ),
      ),
    );
  }
}
