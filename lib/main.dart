import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pulse_gym/firebase_options.dart';
import 'package:pulse_gym/screens/exercises_page.dart';
import 'screens/settings_page.dart';
import 'screens/newpass.dart';
import 'screens/login.dart';
import 'screens/homepage.dart';
import 'screens/subscription_page.dart';
import 'screens/register_page.dart';
import 'screens/all_exercises.dart';
import 'screens/profile.dart';
import 'screens/editprofile.dart';
import 'screens/nova_senha.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Retrieve userId from SharedPreferences
  final String? userId = await getUserId();
  runApp(PulseGym(userId: userId));
}

// Fetch userId from SharedPreferences
Future<String?> getUserId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('userId');
}

class PulseGym extends StatelessWidget {
  final String? userId;

  const PulseGym({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (settings) {
        if (settings.name == '/subscription_page') {
          final args = settings.arguments as Map<String, dynamic>;
          final userId = args['userId'];

          return MaterialPageRoute(
            builder: (context) => SubscriptionPage(userId: userId),
          );
        }
        return null;
      },
      debugShowCheckedModeBanner: false,
      initialRoute:
          userId != null ? '/homepage' : '/login', // Check if user is logged in
      routes: {
        '/homepage': (context) => HomePage(userId: userId ?? ''),
        '/login': (context) => const Login(),
        '/subscription_page': (context) =>
            SubscriptionPage(userId: userId ?? ''),
        '/newpass': (context) => const Newpass(),
        '/register_page': (context) => const RegisterPage(),
        '/settings_page': (context) => SettingsPage(userId: userId ?? ''),
        '/exercises_page': (context) => ExercisesPage(userId: userId ?? ''),
        '/all_exercises': (context) => GymPage(userId: userId ?? ''),
        '/profile': (context) => ProfilePage(userId: userId ?? ''),
        '/editprofile': (context) => EditProfile(),
        '/nova_senha': (context) => NovaSenha(),
      },
    );
  }
}
