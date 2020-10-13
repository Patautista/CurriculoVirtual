import 'package:curriculo_virtual/telas/CurriculoTela.dart';
import 'package:curriculo_virtual/telas/EntrarTela.dart';
import 'package:flutter/material.dart';

const Color color = Colors.deepPurple;

void main() {
  runApp(CurriculoApp());
}

class CurriculoApp extends StatelessWidget {
  CurriculoApp();
  final bool login = true;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu currículo',
      theme: ThemeData(
        primarySwatch: color,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: login? CurriculoTela(title: 'Meu currículo'): EntrarTela(),
    );
  }
}

