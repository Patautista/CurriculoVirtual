import 'package:curriculo_virtual/telas/CurriculoTela.dart';
import 'package:curriculo_virtual/telas/EntrarTela.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(CurriculoApp());
}

class CurriculoApp extends StatelessWidget {
  bool login = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu currículo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: login? CurriculoTela(title: 'Meu currículo'): EntrarTela(),
    );
  }
}

