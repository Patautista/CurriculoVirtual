import 'package:curriculo_virtual/service/CurriculoObject.dart';
import 'package:curriculo_virtual/service/auth.dart';
import 'package:curriculo_virtual/telas/CurriculoTela.dart';
import 'package:curriculo_virtual/telas/EntrarTela.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const Color color = Colors.green;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(CurriculoApp());
}

class CurriculoApp extends StatelessWidget {
  CurriculoObject curriculo;

  CurriculoApp();
  final bool login = true;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<AuthenticationService>().authStateChanges,
        )
      ],
      child: MaterialApp(
        title: 'Meu Currículo',
        theme: ThemeData(
          primarySwatch: color,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: AuthenticationWrapper(),
      ),
    );
  }
}
class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    if (firebaseUser != null) {
      return CurriculoTela(title: "Meu Currículo", curriculo: curriculo,);
    }
    return EntrarTela();
  }
}

List<Curso> cursos = <Curso> [
  Curso(data:"01/01/2017", titulo: "Biologia" , status: "Incompleto", instituicao: "Universidade Federal do Ceará"),
  Curso(data:"04/03/2019", titulo: "Computação" , status: "Completo", instituicao: "Universidade Federal do Ceará"),
  Curso(data:"31/05/2019", titulo: "Direito" , status: "Completo", instituicao: "Universidade Federal do Ceará")
];
List<Titulo> titulos = <Titulo> [
  Titulo(titulo:"Programação em linguagem Java", resumo: "Experiência com Framework SpringBoot e criação de aplicações Backend com API REST"),
  Titulo(titulo:"Programação em linguagem PHP", resumo: "Experiência com Framework SpringBoot e criação de aplicações Backend com API REST")
];

CurriculoObject curriculo = new CurriculoObject("caleb.kart@gmail.com", "Idiomas.", cursos,
    titulos, "Gosto de aprender.", "84028922", "Caleb de Sousa Vasconcelos");

