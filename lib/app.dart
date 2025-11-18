import 'package:flutter/material.dart';
import 'package:kinli/widgets/auth_gate.dart';

class KinliApp extends StatelessWidget {
  const KinliApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kinli Baby Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          primary: Colors.deepPurple.shade300,
        ),
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      home: const AuthGate(),
    );
  }
}
