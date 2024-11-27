import 'package:flutter/material.dart';

import '../widgets/custom_bottom_nav_bar.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage('assets/user_image.png'),
              backgroundColor: Colors.grey[300],
            ),
            const SizedBox(width: 10),
            const Text(
              "Hi User!",
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
            color: Colors.black,
          ),
        ],
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Select a plan",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildPlanCard(
              context: context,
              title: "Plan One",
              price: "20€",
              isSelected: false,
            ),
            const SizedBox(height: 10),
            _buildPlanCard(
              context: context,
              title: "Plan Two",
              price: "30€",
              isSelected: false,
            ),
            const SizedBox(height: 10),
            _buildPlanCard(
              context: context,
              title: "Plan Three",
              price: "40€",
              isSelected: true,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // Ação para "Proceed to Pay"
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Center(
                child: Text(
                  "Proceed to Pay",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 2,
        currentRoute: '/subscription_page',
      ),
    );
  }

  Widget _buildPlanCard({
    required BuildContext context,
    required String title,
    required String price,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        // Ação ao selecionar um plano
      },
      child: Card(
        color: isSelected ? Colors.orange : Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.check_circle,
                color: isSelected ? Colors.white : Colors.transparent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
