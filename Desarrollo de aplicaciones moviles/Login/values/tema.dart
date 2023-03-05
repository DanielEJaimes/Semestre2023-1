import 'package:flutter/material.dart';

const Color primary = Color.fromARGB(0, 11, 66, 90);
const Color  gray = Color(0x40434e);
const Color pink = Color(0xfdcff3);
const Color white = Color(0xf9f8f8);
const Color yellow = Color(0xfff3de8a);
 
ThemeData miTema (BuildContext context){
  return ThemeData(
    primaryColor: primary,
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.blueGrey,
    ).copyWith(
      secondary: Colors.blueAccent,
    )
  );
}