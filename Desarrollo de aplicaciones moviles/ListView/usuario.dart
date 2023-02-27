import 'package:flutter/material.dart';
import 'package:flutter_application_1/user.dart';

class Usuario extends StatelessWidget {
  User person;

  Usuario(this.person, {super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.amberAccent),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
                child: Image.asset(
              'assets/' + person.getImagen,
              height: 80,
              width: 80,
            )),
            Column(
              children: [
                Text(person.getNombre),
                const SizedBox(height: 10),
                Text(person.getCarrera),
                const SizedBox(height: 10),
                Text(person.getPromedio.toString()),
                const SizedBox(height: 10)
              ],
            )
          ],
        ));
  }
}
