import 'package:curriculo_virtual/service/auth.dart';
import 'package:curriculo_virtual/telas/CurriculoTela.dart';
import 'package:curriculo_virtual/telas/EntrarTela.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

const Color color = Colors.green;

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
      home: FutureBuilder(
        future: Firebase.initializeApp(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
            return login? CurriculoTela(title: 'Meu currículo'): EntrarTela();
          }
      )
    );
  }
}

