import 'package:flutter_application_1/exports.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedService.setUp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LAB LOGIN',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => HomePage(),
        '/welcome': (context) => const SecondPage(),
      },
    );
  }
}
