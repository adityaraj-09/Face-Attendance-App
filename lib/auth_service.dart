
import 'package:firebase_auth/firebase_auth.dart';

import 'database_service.dart';
import 'helper_function.dart';

class Authservice{
  final FirebaseAuth firebaseAuth=FirebaseAuth.instance;

  Future registeruser(String name,String email,String password,String entryNo ) async{

    try{
      User user=(await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user!;
      if(user!=null){
        await Database(uid: user.uid).savingData(name, entryNo);
        return true;
      }
    }on FirebaseAuthException catch(e){
      return e.message;
    }
  }
  Future login(String email,String password) async{
    try{
      User user=(await firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user!;
      if(user!=null){
        return true;
      }
    }on FirebaseAuthException catch(e){
      return e.message;
    }
  }
  Future signOut() async {
    try {
      await Helper.saveUserStatus(false);
      await Helper.saveUserEmail("");
      await Helper.saveUserName("");
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }

}