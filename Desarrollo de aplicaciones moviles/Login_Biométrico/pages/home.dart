import 'package:flutter_application_1/exports.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  late String email, pass;

  final FlutterSecureStorage storage = FlutterSecureStorage();
  final LocalAuthentication auth = LocalAuthentication();
  bool userHasTouchId = false;

  @override
  void initState() {
    super.initState();
    getSecureStorage();
  }

  void getSecureStorage() async {
    final isUsingBio = await storage.read(key: 'usingBiometric');
    setState(() {
      userHasTouchId = isUsingBio == 'true';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: _desingLogin(context),
        ),
      ),
    );
  }

  Widget _desingLogin(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Correo',
                          hintText: 'daniel_patino@gmail.com'),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _passController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Contraseña',
                          hintText: 'pruebaPassword'),
                      obscureText: true, /* <-- Aquí */
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    SizedBox(
                      height: 50,
                      width: 250,
                      child: ElevatedButton(
                          onPressed: () {
                            email = _emailController.text;
                            pass = _passController.text;
                            submit();
                          },
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.amber,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25))),
                          child: const Text(
                            "Login",
                            style: TextStyle(fontSize: 24),
                          )),
                    ),
                    Visibility(
                      visible: userHasTouchId,
                      child: IconButton(
                          onPressed: () async {
                            bool touchID = await auth.authenticate(
                                localizedReason:
                                    'Por favor, confirma tu identidad');
                            if (touchID) {
                              email = (await storage.read(key: 'email'))!;
                              pass = (await storage.read(key: 'password'))!;
                            }
                            print(email);
                            submit();
                          },
                          icon: Icon(Icons.fingerprint)),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void submit() async {
    print(pass);
    if (validate()) {
      LoginRequestModel model = LoginRequestModel(email: email, password: pass);
      final response = await APIService.login(model);
      if (response == 0) {
        Navigator.pushNamed(context, '/welcome', arguments: {
          'email': _emailController.text,
          'pass': _passController.text,
        });
      } else if (response == 1) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('Error'),
                  content: const Text('Usuario o contraseña incorrecta'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Ok')),
                  ],
                ));
      } else {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('Error'),
                  content: const Text('Ocurrió un error. Intente más tarde'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Ok')),
                  ],
                ));
      }
    }
  }

  bool validate() {
    RegExp emailValidator = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

    if (email == '' || pass == '') {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Debe llenar todos los campos'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Ok')),
          ],
        ),
      );
      return false;
    }
    if (!emailValidator.hasMatch(email)) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Error'),
                content: const Text('Email inválido'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Ok')),
                ],
              ));
      return false;
    }
    return true;
  }
}
