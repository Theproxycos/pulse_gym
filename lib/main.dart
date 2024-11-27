import 'package:flutter/material.dart';
import 'package:pulse_gym/screens/newpass.dart';
import 'screens/login.dart';
import 'screens/homepage.dart';
import 'screens/subscription_page.dart';

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
        '/subscription_page': (context) => SubscriptionPage(),
        '/newpass': (context) => Newpass(),
      },
    );
  }
}
