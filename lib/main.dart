import 'package:flutter/material.dart';
import 'package:pulse_gym/screens/exercises_page.dart';
import 'screens/settings_page.dart';
import 'screens/newpass.dart';
import 'screens/login.dart';
import 'screens/homepage.dart';
import 'screens/subscription_page.dart';
import 'screens/register_page.dart';
import 'screens/exercises_page.dart';
import 'screens/all_exercises.dart';
import 'screens/profile.dart';
import 'screens/editprofile.dart';

void main() {
  runApp(const PulseGym());
}

class PulseGym extends StatelessWidget {
  const PulseGym({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/homepage': (context) => const HomePage(),
        '/login': (context) => Login(),
        '/subscription_page': (context) => const SubscriptionPage(),
        '/newpass': (context) => Newpass(),
        '/register_page': (context) => RegisterPage(),
        '/settings_page': (context) => SettingsPage(),
        '/exercises_page': (context) => ExercisesPage(),
        '/all_exercises': (context) => GymPage(),
        '/profile': (context) => ProfilePage(),
        '/editprofile': (context) => Editprofile(),
      },
    );
  }
}
