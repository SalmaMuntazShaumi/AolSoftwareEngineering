import 'package:firebase_auth/firebase_auth.dart';

Future<void> signUp(String email, String password) async {
  try{
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    print("User registered");
  } catch(e){
    print("Error : $e");
  }
}

Future<void> signIn(String email, String password) async {
  try{
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    print("User ${userCredential.user?.email} is signed in!");
  } catch(e){
    print("Error : $e");
  }
}