import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pulse_gym/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/settings_page.dart';
import 'screens/login.dart';
import 'screens/homepage.dart';
import 'screens/subscription_page.dart';
import 'screens/newpass.dart';
import 'screens/register_page.dart';
import 'screens/all_exercises.dart';
import 'screens/profile.dart';
import 'screens/editprofile.dart';
import 'screens/nova_senha.dart';
import 'screens/exercises_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Recuperar userId do SharedPreferences
  final String? userId = await getUserId();

  // Recuperar tema salvo
  final savedThemeMode = await AdaptiveTheme.getThemeMode();

  runApp(PulseGym(userId: userId, savedThemeMode: savedThemeMode));
}

// Função para buscar o userId salvo
Future<String?> getUserId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('userId');
}

class PulseGym extends StatelessWidget {
  final String? userId;
  final AdaptiveThemeMode? savedThemeMode;

  const PulseGym({super.key, this.userId, this.savedThemeMode});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData.light().copyWith(
        primaryColor: Colors.black,
        secondaryHeaderColor: const Color.fromARGB(255, 49, 48, 48),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.orange,
        ),
      ),
      dark: ThemeData.dark().copyWith(
        primaryColor: Colors.white,
        secondaryHeaderColor: Colors.grey,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.orange,
        ),
      ),
      initial: savedThemeMode ?? AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        darkTheme: darkTheme,
        initialRoute: userId != null ? '/homepage' : '/login',
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
      ),
    );
  }
}
