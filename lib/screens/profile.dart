import 'package:flutter/material.dart';

import '../widgets/custom_bottom_nav_bar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   title: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       GestureDetector(
      //         onTap: () {
      //           if (Navigator.canPop(context)) {
      //             Navigator.pop(context);
      //           } else {
      //             Navigator.pushNamed(context, '/homepage');
      //           }
      //         },
      //         child: const Row(
      //           children: [
      //             Icon(Icons.arrow_back, color: Colors.black),
      //             SizedBox(width: 5),
      //             Text(
      //               'Back',
      //               style: TextStyle(color: Colors.black),
      //             ),
      //           ],
      //         ),
      //       ),
      //       const Stack(
      //         children: [
      //           Icon(Icons.notifications, color: Colors.black),
      //           Positioned(
      //             right: 0,
      //             child: CircleAvatar(
      //               backgroundColor: Colors.red,
      //               radius: 8,
      //               child: Text(
      //                 '1',
      //                 style: TextStyle(color: Colors.white, fontSize: 12),
      //               ),
      //             ),
      //           ),
      //         ],
      //       ),
      //     ],
      //   ),
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      // ),
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
                'lib/assets/logo-nobg.png', // Caminho para o logo
                height: 80, // Altura ajustável
              ),
              const SizedBox(height: 30), // Distância entre o logo e as opções
              Card(
                child: ListTile(
                  leading:
                      const Icon(Icons.person, size: 40, color: Colors.orange),
                  title: const Text('Change Profile Picture'),
                  trailing:
                      const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  onTap: () {
                    // Navegar para alteração de foto
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
                    // Navegar para alteração de idioma
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
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 4,
        currentRoute: 'Profile',
      ),
    );
  }
}
