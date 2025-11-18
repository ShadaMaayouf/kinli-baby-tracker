import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

Future<UserCredential> signIn(String email, String password) {
  return auth.signInWithEmailAndPassword(email: email, password: password);
}

Future<void> signOut() async {
  await auth.signOut();
}
