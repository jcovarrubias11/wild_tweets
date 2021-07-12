import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/all.dart';

class FirebaseAuthService extends StateNotifier<void> {
  FirebaseAuthService(this.auth) : super(auth ?? FirebaseAuth.instance);
  final FirebaseAuth auth;

  void signInWithEmail(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  void createAccountWithEmail(String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  void signInAnon() async {
    await auth.signInAnonymously();
  }
}
