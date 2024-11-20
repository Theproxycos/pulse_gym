import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({Key? key}) : super(key: key);

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
            icon: Icons.home,
            label: "Home",
            isActive: true,
            onTap: () {
              // Ação ao clicar no botão Home
            },
          ),
          _buildNavItem(
            icon: Icons.fitness_center,
            label: "Fitness",
            onTap: () {
              // Ação ao clicar no botão Fitness
            },
          ),
          _buildNavItem(
            icon: Icons.subscriptions,
            label: "Subscription",
            onTap: () {
              // Ação ao clicar no botão Subscription
            },
          ),
          _buildNavItem(
            icon: Icons.person,
            label: "Profile",
            onTap: () {
              // Ação ao clicar no botão Profile
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    bool isActive = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
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
