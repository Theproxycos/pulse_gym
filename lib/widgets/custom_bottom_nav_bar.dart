import 'package:flutter/material.dart';
import '../screens/activity_page.dart';
import '../screens/all_exercises.dart';
import '../screens/homepage.dart';
import '../screens/profile.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final String userId;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required String currentRoute,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    // Obtendo as cores do tema atual
    final theme = Theme.of(context);

    return Container(
      height: 60,
      decoration: BoxDecoration(
        color:
            theme.scaffoldBackgroundColor, // Cor do fundo de acordo com o tema
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, -1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            context: context,
            icon: Icons.home,
            label: "Home",
            index: 0,
            targetPage: HomePage(userId: userId),
          ),
          _buildNavItem(
            context: context,
            icon: Icons.alarm_on,
            label: "Activity",
            index: 1,
            targetPage: BodyMeasurementsPage(userId: userId),
          ),
          _buildNavItem(
            context: context,
            icon: Icons.fitness_center,
            label: "Exercises",
            index: 3,
            targetPage: GymPage(userId: userId),
          ),
          _buildNavItem(
            context: context,
            icon: Icons.person,
            label: "Profile",
            index: 4,
            targetPage: ProfilePage(userId: userId),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required int index,
    required Widget targetPage,
  }) {
    final isActive = index == currentIndex;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        if (index != currentIndex) {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  targetPage,
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive
                ? Colors.orange
                : theme.iconTheme.color, // Cor ativa e inativa
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive
                  ? Colors.orange
                  : theme.textTheme.bodyMedium?.color, // Cor do texto
            ),
          ),
        ],
      ),
    );
  }
}
