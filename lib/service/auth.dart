import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curriculo_virtual/service/CurriculoObject.dart';
import 'package:curriculo_virtual/telas/EntrarTela.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  CurriculoObject curriculo;
  Stream<User> get authStateChanges => _firebaseAuth.idTokenChanges();

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<String> signIn({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      print("ID: ${_firebaseAuth.currentUser.uid}");
      return "Signed in";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String> signUp({String email, String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return "Signed up";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}

Future<CurriculoObject> fetchCurriculo(String uid) async{
  CurriculoObject curriculo = null;
  CollectionReference colletionReference = FirebaseFirestore.instance.collection('usuarios');
  colletionReference.snapshots().listen((snapshot) {
    print(snapshot);
    for(int i = 0; i< snapshot.docs.length; i++){
      if(snapshot.docs[i].data()["uid"] == uid){
        List<Curso> listaCursos = [];
        for(int j=0; j< snapshot.docs[i].data()["cursos"].length; j++){
          Curso curso = Curso(
            titulo: snapshot.docs[i].data()["cursos"][j]["titulo"],
            instituicao: snapshot.docs[i].data()["cursos"][j]["instituicao"],
            status: snapshot.docs[i].data()["cursos"][j]["status"],
            data: snapshot.docs[i].data()["cursos"][j]["data"],
          );
          listaCursos.add(curso);
        }
        List<Titulo> listaTitulos = [];
        for(int j=0; j< snapshot.docs[i].data()["titulos"].length; j++){
          Titulo titulo = Titulo(
            titulo: snapshot.docs[i].data()["titulos"][j]["titulo"],
            resumo: snapshot.docs[i].data()["titulos"][j]["resumo"],
          );
          listaTitulos.add(titulo);
        }
        curriculo = new CurriculoObject(
          snapshot.docs[i].data()["email"],
          snapshot.docs[i].data()["informal"],
          listaCursos,
          listaTitulos,
          snapshot.docs[i].data()["perfil"],
          snapshot.docs[i].data()["telefone"],
          snapshot.docs[i].data()["nome"],
        );
        return curriculo;
      }
    }
    return curriculo;
  });
}