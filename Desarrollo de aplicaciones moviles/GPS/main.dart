import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const HomePage());
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
              onPressed: () {
                abrirUrl(
                    "http://www.google.com/maps/place/6.2502089,-75.5706711");
              },
              child: const Text('Abrir enlace'),
            ),
            ElevatedButton(
                onPressed: () {
                  obtenerGps();
                },
                child: const Text('Ubicación'))
          ]),
        ),
      ),
    );
  }
}

Future<Position> obtenerGps() async {
  bool bGpsHabilitado = await Geolocator.isLocationServiceEnabled();
  if (!bGpsHabilitado) {
    return Future.error('Habilite la ubicación');
  }
  LocationPermission bGPSPermiso = await Geolocator.checkPermission();
  if (bGPSPermiso == LocationPermission.denied) {
    bGPSPermiso = await Geolocator.requestPermission();
    if (bGPSPermiso == LocationPermission.denied) {
      return Future.error('Se denegó el permiso para obtener la ubicación');
    }
  }
  if (bGPSPermiso == LocationPermission.deniedForever) {
    return Future.error(
        'Se denegó el permiso para obtener la ubicación de forma permanente');
  }
  return await Geolocator.getCurrentPosition();
}

Future<void> abrirUrl(String sUrl) async {
  final Uri oUri = Uri.parse(sUrl);
  try {
    await launchUrl(oUri, mode: LaunchMode.externalApplication);
  } catch (oError) {
    return Future.error('No fue posible abrir la url: $sUrl');
  }
}
