import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import 'WorkoutDetailPage.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  final String userId; // Pass the user ID when navigating to this page
  const HomePage({super.key, required this.userId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime today = DateTime.now();
  DateTime? _selectedDate;

  // Firestore instance and workout data
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> workoutData = []; // To store workout cards
  String? _userName; // Variable to store the user's name

  @override
  void initState() {
    super.initState();
    if (widget.userId.isEmpty) {
      print('Error: User ID is empty!');
      return; // Stop further execution if userId is invalid
    }
    _fetchUserName(); // Fetch the user's name from Firestore
    _fetchWorkoutCards(); // Fetch workout cards for the user
  }

  Future<void> _fetchUserName() async {
    try {
      final userDoc =
          await _firestore.collection('users').doc(widget.userId).get();
      if (userDoc.exists) {
        setState(() {
          _userName = userDoc['username']; // Assuming the field is 'username'
        });
      }
    } catch (e) {
      print('Error fetching user name: $e');
    }
  }

  Future<void> _fetchWorkoutCards() async {
    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(widget.userId)
          .collection('workoutCards')
          .get();

      setState(() {
        workoutData = querySnapshot.docs.map((doc) {
          return {
            'id': doc.id,
            'title': doc['title'],
            'subtitle': doc['subtitle'],
          };
        }).toList();
      });
    } catch (e) {
      print('Error fetching workout cards: $e');
    }
  }

  Future<void> _addWorkoutCard(String title, String subtitle) async {
    try {
      await _firestore
          .collection('users')
          .doc(widget.userId)
          .collection('workoutCards')
          .add({
        'title': title,
        'subtitle': subtitle,
      });
      _fetchWorkoutCards();
    } catch (e) {
      print('Error adding workout card: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey[300],
              ),
            ),
            const SizedBox(width: 10),
            Text(
              _userName != null ? "Hello, $_userName!" : "Hello",
              style: const TextStyle(color: Colors.black),
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
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(116),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 10.0),
            child: EasyDateTimeLine(
              initialDate: today,
              onDateChange: (selectedDate) {
                setState(() {
                  _selectedDate = selectedDate;
                });
              },
              headerProps: const EasyHeaderProps(
                monthPickerType: MonthPickerType.switcher,
                dateFormatter: DateFormatter.fullDateDMY(),
              ),
              dayProps: const EasyDayProps(
                dayStructure: DayStructure.dayStrDayNum,
                height: 60.0,
                width: 60.0,
                activeDayStyle: DayStyle(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xff3371FF),
                        Color(0xff8426D6),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitleWithButton("My Training Sessions", () {
                _showAddWorkoutDialog();
              }),
              _buildSectionSubitle("Create your own personalized routine"),
              const SizedBox(height: 10),
              _buildMyWorkoutCards(),
              const SizedBox(height: 20),
              _buildSectionTitle("Your Personal Trainer"),
              _buildTrainerCard(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        currentRoute: 'homepage',
        userId: widget.userId,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildSectionTitleWithButton(String title, VoidCallback onPressed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add, color: Colors.blue),
          onPressed: onPressed,
        ),
      ],
    );
  }

  void _showAddWorkoutDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController subtitleController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add New Workout"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Workout Title"),
              ),
              TextField(
                controller: subtitleController,
                decoration:
                    const InputDecoration(labelText: "Workout Subtitle"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    subtitleController.text.isNotEmpty) {
                  _addWorkoutCard(
                    titleController.text,
                    subtitleController.text,
                  );
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSectionSubitle(String title) {
    return Text(
      title,
      style:
          const TextStyle(fontSize: 14, color: Color.fromARGB(255, 49, 48, 48)),
    );
  }

  Widget _buildMyWorkoutCards() {
    return SizedBox(
      height: 150,
      child: workoutData.isEmpty
          ? const Center(child: Text("No workout sessions available"))
          : ListView(
              scrollDirection: Axis.horizontal,
              children: workoutData.map((workout) {
                return _buildMyWorkoutCard(
                  title: workout['title']! as String,
                  subtitle: workout['subtitle']! as String,
                  icon: Icons.fitness_center,
                );
              }).toList(),
            ),
    );
  }

  Widget _buildMyWorkoutCard({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WorkoutDetailPage(
              title: title,
              subtitle: subtitle,
              userId: widget.userId,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Card(
          elevation: 2,
          color: const Color(0xff3371FF),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: Colors.orange, size: 40),
                const SizedBox(height: 10),
                Text(title, style: const TextStyle(color: Colors.white)),
                Text(subtitle, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrainerCard() {
    return Card(
      color: Colors.blue[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: const ListTile(
        leading: CircleAvatar(),
        title: Text("Trainer name"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Contact: trainer@example.com"),
            Text("Specialization: Personal Trainer"),
          ],
        ),
      ),
    );
  }
}
