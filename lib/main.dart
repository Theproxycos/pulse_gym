import 'package:flutter/material.dart';
import 'screens/newpass.dart';
import 'screens/login.dart';
import 'screens/homepage.dart';
import 'screens/subscription_page.dart';
import 'screens/register_page.dart';

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
        '/register_page': (context) => RegisterPage(),
      },
    );
  }
}
