import 'package:flutter/material.dart';

import '../screens/all_exercises.dart';
import '../screens/homepage.dart';
<<<<<<< Updated upstream
import '../screens/all_exercises.dart';
=======
import '../screens/exercises_page.dart';
import '../screens/profile.dart';
>>>>>>> Stashed changes

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required String currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: Colors.white,
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
            targetPage: const HomePage(),
          ),
          // _buildNavItem(
          //   context: context,
          //   icon: Icons.fitness_center,
          //   label: "Activity",
          //   index: 1,
          //   targetPage: const ActivityPage(),
          // ),
          // _buildNavItem(
          //   context: context,
          //   icon: Icons.euro,
          //   label: "Explore",
          //   index: 2,
          //   targetPage: const ExplorePage(),
          // ),
          _buildNavItem(
            context: context,
            icon: Icons.fitness_center,
            label: "Exercises",
            index: 3,
            targetPage: GymPage(),
          ),
          _buildNavItem(
            context: context,
            icon: Icons.person,
            label: "Profile",
            index: 4,
            targetPage: ProfilePage(),
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
            color: isActive ? Colors.orange : Colors.grey,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? Colors.orange : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
