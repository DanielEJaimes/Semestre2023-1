import 'package:flutter_application_1/exports.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  final LocalAuthentication auth = LocalAuthentication();
  final storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido'),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/');
            },
            icon: const Icon(Icons.logout)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Habilitar login con datos biométricos',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 100),
            SizedBox(
              height: 50,
              width: 250,
              child: ElevatedButton(
                  onPressed: () async {
                    bool touchID = await auth.authenticate(
                        localizedReason: 'Por favor, confirma tu identidad');
                    if (touchID) {
                      storage.write(key: 'email', value: arguments['email']);
                      storage.write(key: 'password', value: arguments['pass']);
                      storage.write(key: 'usingBiometric', value: 'true');
                    }
                  },
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.amber,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25))),
                  child: const Text(
                    "Habilitar",
                    style: TextStyle(fontSize: 24),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
