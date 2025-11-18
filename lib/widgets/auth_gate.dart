import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kinli/screens/home_screen.dart'; // ✅ Import HomeScreen
import 'package:kinli/screens/sign_in_screen.dart'; // ✅ Import sign in screen

//the original logic to:
//- Show SignInScreen when the user is not logged in
//- Show HomeScreen only after successful login

/*
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) { // This checks whether a user is signed in via Firebase. If not, it defaults to the sign-in screen.
          return const HomeScreen();
        } else {
          return const SignInScreen();
        }
      },
    );
  }
}
*/

//bypass authentication and always show the HomeScreen (for testing)
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}
