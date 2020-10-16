import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curriculo_virtual/main.dart';
import 'package:curriculo_virtual/service/CurriculoObject.dart';
import 'package:curriculo_virtual/service/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EntrarTela extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  double alturaTela;

  @override
  Widget build(BuildContext context) {
    alturaTela = MediaQuery.of(context).size.height;

    emailController.text = "test@gmail.com";
    passwordController.text = "123456";

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Currículo Virtual",
            style: TextStyle(color: color, fontSize: 26),
          ),
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: "Email",
            ),
          ),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: "Senha",
            ),
          ),
          SizedBox(height: alturaTela*0.025,),
          RaisedButton(
            color: color,
            onPressed: () {
              context.read<AuthenticationService>().signIn(
                email: emailController.text.trim(),
                password: passwordController.text.trim(),
              );

            },
            child: Text("Entrar",
            style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(height: alturaTela*0.05,),
          Text("Desenvolvido por Caleb Sousa, 2020",
            style: TextStyle(fontStyle: FontStyle.italic),
          )
        ],
      ),
    );
  }
}
