import 'package:flutter/material.dart';

void main() {
  runApp(PulseGym());
}

class PulseGym extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {},
    );
  }
}
