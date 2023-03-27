import 'package:chat_app/helper/helper_functions.dart';
import 'package:chat_app/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class Authservice{
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future registerUserWithEmailAndPassword(String fullName, String email,String password )async{
    try {
   User user=  (await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user!;
   if(user != null){
  await  DatabaseService(uid: user.uid).updateUserData(fullName, email);
    return true;
   }
      
    }on FirebaseAuthException catch (e) {
      return e;
      
    }

  }

  Future signOut()async{
    try {
      await Helperfunctions.saveUserLogedInStatus(false);
      await Helperfunctions.saveUserEmailSF("");
      await Helperfunctions.saveUserNameSF("");
      await firebaseAuth.signOut();

      
    } catch (e) {return null;

      
    }
  }
}