import 'package:firebase_auth/firebase_auth.dart';

class Authservice{
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future registerUserWithEmailAndPassword(String fullName, String email,String password )async{
    try {
      firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      
    }on FirebaseAuthException catch (e) {
      
    }

  }
}