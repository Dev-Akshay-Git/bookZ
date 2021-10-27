import 'package:firebase_auth/firebase_auth.dart';

class Authenticate {
  //sign in
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signInEmailAndPassword(String email, String password) async {
    try {
      var result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
