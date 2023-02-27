import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Calculadora(),
    );
  }
}

class Calculadora extends StatefulWidget {
  const Calculadora({super.key});

  @override
  _CalculadoraState createState() => _CalculadoraState();
}

class _CalculadoraState extends State<Calculadora> {
  Widget calcButton(String btntxt, Color btncolor) {
    return ElevatedButton(
        onPressed: () => calcular(btntxt),
        style: ElevatedButton.styleFrom(
            backgroundColor: btncolor, padding: const EdgeInsets.all(10)),
        child: Text(btntxt));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Calculadora'),
          backgroundColor: Colors.black,
        ),
        body: Column(
          children: [
            Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                child: Text(ecuacion, style: const TextStyle(fontSize: 48.0))),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    children: [
                      calcButton("AC", Colors.amber),
                      calcButton("7", Colors.grey),
                      calcButton("4", Colors.grey),
                      calcButton("1", Colors.grey),
                      calcButton("0", Colors.grey)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    children: [
                      calcButton("CE", Colors.amber),
                      calcButton("8", Colors.grey),
                      calcButton("5", Colors.grey),
                      calcButton("2", Colors.grey),
                      calcButton(".", Colors.grey),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    children: [
                      calcButton("%", Colors.grey),
                      calcButton("9", Colors.grey),
                      calcButton("6", Colors.grey),
                      calcButton("3", Colors.grey),
                      calcButton("=", Colors.grey),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    children: [
                      calcButton("/", Colors.grey),
                      calcButton("*", Colors.grey),
                      calcButton("-", Colors.grey),
                      SizedBox(
                        height: 95,
                        child: calcButton("+", Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ));
  }

  String ecuacion = "0";
  String expresion = "";

  calcular(String digit) {
    setState(() {
      if (digit == "AC") {
        ecuacion = "0";
      } else if (digit == "CE") {
        ecuacion = ecuacion.substring(0, ecuacion.length - 1);
        if (ecuacion == "") {
          ecuacion = "0";
        }
      } else if (digit == "=") {
        expresion = ecuacion;

        try {
          Parser p = Parser();
          Expression exp = p.parse(expresion);

          ContextModel cm = ContextModel();
          ecuacion = '${exp.evaluate(EvaluationType.REAL, cm)}';
        } catch (e) {
          ecuacion = "Error";
        }
      } else {
        if (ecuacion == "0") {
          ecuacion = digit;
        } else {
          ecuacion = ecuacion + digit;
        }
      }
    });
  }
}
