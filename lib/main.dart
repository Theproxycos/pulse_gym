import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'screens/homepage.dart';

void main() {
  runApp(PulseGym());
}

class PulseGym extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/homepage': (context) => HomePage(),
        '/login': (context) => Login(),
      },
    );
  }
}
