import 'package:flutter/material.dart';
import '../widgets/custom_bottom_nav_bar.dart';

class ProfilePage extends StatelessWidget {
  final String userId; // Add the userId parameter

  // Pass the userId to the constructor
  const ProfilePage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Image.asset(
                'lib/assets/logo-nobg.png', // Path to the logo
                height: 80, // Adjustable height
              ),
              const SizedBox(height: 30), // Distance between logo and options
              Card(
                child: ListTile(
                  leading:
                      const Icon(Icons.person, size: 40, color: Colors.orange),
                  title: const Text('Change Profile Picture'),
                  trailing:
                      const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  onTap: () {
                    // Navigate to profile picture change page
                  },
                ),
              ),
              Card(
                child: ListTile(
                  leading:
                      const Icon(Icons.badge, size: 40, color: Colors.orange),
                  title: const Text('Edit Profile'),
                  trailing:
                      const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  onTap: () {
                    Navigator.pushNamed(context, '/editprofile');
                  },
                ),
              ),
              Card(
                child: ListTile(
                  leading:
                      const Icon(Icons.lock, size: 40, color: Colors.orange),
                  title: const Text('Change Password'),
                  trailing:
                      const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  onTap: () {
                    Navigator.pushNamed(context, '/nova_senha');
                  },
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.language,
                      size: 40, color: Colors.orange),
                  title: const Text('Change Language'),
                  trailing:
                      const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  onTap: () {
                    // Navigate to language change page
                  },
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.currency_exchange,
                      size: 40, color: Colors.orange),
                  title: const Text('Subscription'),
                  trailing:
                      const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  onTap: () {
                    Navigator.pushNamed(context, '/subscription_page');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 4, // Set the current index for the profile page
        currentRoute: 'Profile',
        userId: userId, // Pass userId to the bottom nav bar
      ),
    );
  }
}
