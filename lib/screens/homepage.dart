import 'package:flutter/material.dart';
import '../widgets/custom_bottom_nav_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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
        automaticallyImplyLeading: false, // Impede a seta de voltar
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Today's workout"),
              const SizedBox(height: 10),
              _buildWorkoutCard(),
              const SizedBox(height: 20),
              _buildSectionTitle("Live sessions"),
              const SizedBox(height: 10),
              _buildLiveSessionCard(
                title: "Bench press",
                time: "Started at 11 AM 30/07/21",
              ),
              const SizedBox(height: 10),
              _buildLiveSessionCard(
                title: "Ab workout",
                time: "Started at 11 AM 30/07/21",
              ),
              const SizedBox(height: 20),
              _buildSectionTitle("Trainer details"),
              const SizedBox(height: 10),
              _buildTrainerCard(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 0,
        currentRoute: 'homepage', // Define o índice da página atual
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildWorkoutCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWorkoutItem(
              icon: Icons.directions_run,
              title: "Treadmill",
              subtitle: "9070 m • 55:24 min",
            ),
            const Divider(),
            _buildWorkoutItem(
              icon: Icons.fitness_center,
              title: "Weights",
              subtitle: "15 KGs • 45:24 min",
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Better than Yesterday",
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  "600 Cals",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutItem(
      {required IconData icon,
      required String title,
      required String subtitle}) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue, size: 30),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 16)),
            Text(subtitle, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  Widget _buildLiveSessionCard({required String title, required String time}) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(title),
        subtitle: Text(time),
        trailing: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          ),
          child: const Text(
            "Watch",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildTrainerCard() {
    return Card(
      color: Colors.blue[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage('assets/trainer_image.png'),
        ),
        title: const Text("Trainer name"),
        subtitle: const Text("Contact details"),
      ),
    );
  }
}
