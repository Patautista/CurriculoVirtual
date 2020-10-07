import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EntrarTela extends StatefulWidget{
  @override
  _EntrarTelaState createState() => _EntrarTelaState();
}

class _EntrarTelaState extends State<EntrarTela> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Entrar"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: TextFormField(),
          )
        ],
      ),
    );
  }
}