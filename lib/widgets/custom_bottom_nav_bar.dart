import 'package:flutter/material.dart';

import '../screens/homepage.dart';
import '../screens/subscription_page.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required String currentRoute,
  }) : super(key: key);

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
          //   label: "Fitness",
          //   index: 1,
          //   targetPage: const FitnessPage(),
          // ),
          _buildNavItem(
            context: context,
            icon: Icons.euro,
            label: "Subscription",
            index: 2,
            targetPage: const SubscriptionPage(),
          ),
          // _buildNavItem(
          //   context: context,
          //   icon: Icons.person,
          //   label: "Profile",
          //   index: 3,
          //   targetPage: const ProfilePage(),
          // ),
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
