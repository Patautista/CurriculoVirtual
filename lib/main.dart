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
      return CurriculoTela(title: "Meu Currículo", uid: firebaseUser.uid, curriculo: curriculo,);
    }
    return EntrarTela();
  }
}

List<Curso> cursos = <Curso> [

];
List<Titulo> titulos = <Titulo> [

];

CurriculoObject curriculo = new CurriculoObject("a", "a", cursos,
    titulos, "a", "a", "a");

