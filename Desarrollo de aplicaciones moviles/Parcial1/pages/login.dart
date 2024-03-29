import 'package:parcial/exports.dart';
import 'package:parcial/models/login_request_model.dart';
import 'package:parcial/services/api_service.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
    isLoggedIn();
  }

  @override
  void dispose() async {
    await Functions.updateFavorites();
    super.dispose();
  }

  loginSuccess() async {
    List<Product> favorites = await APIService.getFavorites();
    await SQLiteDB.saveFavorites(favorites);
    // ignore: use_build_context_synchronously
    Navigator.pushNamed(context, '/');
  }

  isLoggedIn() async {
    var session = await SharedService.isLoggedIn();
    if (session) {
      await loginSuccess();
    }
  }

  bool isRememberMe = false;
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();

  /* ==================Functions================= */

  void submit() async {
    if (validate()) {
      LoginRequestModel model = LoginRequestModel(
          email: emailTextController.text,
          password: passwordTextController.text);
      final response = await APIService.login(model);
      if (response == 0) {
        loginSuccess();
      } else if (response == 1) {
        // ignore: use_build_context_synchronously
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
        // ignore: use_build_context_synchronously
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

    if (emailTextController.text == '' || passwordTextController.text == '') {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Error'),
                content: const Text('Debes llenar todos los campos'),
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
    if (!emailValidator.hasMatch(emailTextController.text)) {
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

  /* ===============WIDGET'S===================== */
  Widget buildEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Correo electronico',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            // ignore: prefer_const_literals_to_create_immutables
            boxShadow: [
              const BoxShadow(
                  color: Colors.black38, blurRadius: 5, offset: Offset(0, 2)),
            ],
          ),
          height: 60,
          child: TextField(
            controller: emailTextController,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(top: 15),
                prefixIcon: Icon(Icons.email, color: HexColor('#E64A19')),
                hintText: 'Dirección de correo',
                hintStyle: TextStyle(color: HexColor('#212121'))),
          ),
        )
      ],
    );
  }

  Widget buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Contreña',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            // ignore: prefer_const_literals_to_create_immutables
            boxShadow: [
              const BoxShadow(
                  color: Colors.black38, blurRadius: 5, offset: Offset(0, 2)),
            ],
          ),
          height: 60,
          child: TextField(
            controller: passwordTextController,
            obscureText: true,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(top: 15),
                prefixIcon: Icon(Icons.lock, color: HexColor('#E64A19')),
                hintText: 'Contraseña',
                hintStyle: TextStyle(color: HexColor('#212121'))),
          ),
        )
      ],
    );
  }

  Widget buildBtnLogin() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          minimumSize:
              MaterialStateProperty.all<Size>(const Size(double.infinity, 50)),
          backgroundColor:
              MaterialStateProperty.all<Color>(HexColor('#E64A19')),
        ),
        onPressed: submit,
        child: const Text(
          'Ingresar',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/fondo.jpg'), fit: BoxFit.cover),
                ),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 45,
                    vertical: 90,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Inicio de Sesión',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Open Sans'),
                      ),
                      const SizedBox(height: 48),
                      buildEmail(),
                      const SizedBox(height: 48),
                      buildPassword(),
                      const SizedBox(height: 25),
                      buildBtnLogin(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
