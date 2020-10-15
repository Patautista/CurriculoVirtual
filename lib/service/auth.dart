import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // sign in anon
  Future signInAnon() async {
    UserCredential userCredential = await _auth.signInAnonymously();
  }

// sign in with email and password


// register with email and password

// sign out
}