import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import 'WorkoutDetailPage.dart';
import 'settings_page.dart';
import 'package:intl/intl.dart';

import 'subscription_page.dart';

class HomePage extends StatefulWidget {
  final String userId;
  const HomePage({super.key, required this.userId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime today = DateTime.now();
  // ignore: unused_field
  DateTime? _selectedDate;
  DateTime? _selectedAppointmentDate;
  TimeOfDay? _selectedTime;
  DateTime? _selectedTrainerAppointmentDate;
  TimeOfDay? _selectedTrainerTime;
  int selectedWeekday = DateTime.now().weekday;
  String? _userTier; // Add this line to store the user's tier.

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> workoutData = [];
  String? _userName;

  @override
  void initState() {
    super.initState();
    if (widget.userId.isEmpty) {
      print('Error: User ID is empty!');
      return; // Stop further execution if userId is invalid
    }
    _fetchUserName(); // Fetch the user's name from Firestore
    _fetchWorkoutCards(); // Fetch workout cards for the user
    _fetchAppointment(); // Fetch the appointment
    _fetchTrainerAppointment();
    _fetchUserTier(); // Fetch the user tier
  }

  Future<void> _fetchUserTier() async {
    try {
      final userDoc =
          await _firestore.collection('users').doc(widget.userId).get();
      if (userDoc.exists) {
        setState(() {
          _userTier = userDoc[
              'subscription_plan']; // Assuming tier is stored as a field 'tier'
        });
      }
    } catch (e) {
      print('Error fetching user tier: $e');
    }
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
          .where('weekday', isEqualTo: selectedWeekday)
          .get();

      setState(() {
        workoutData = querySnapshot.docs.map((doc) {
          return {
            'id': doc.id,
            'title': doc['title'],
            'subtitle': doc['subtitle'],
            'weekday': doc['weekday'],
          };
        }).toList();
      });
    } catch (e) {
      print('Error fetching workout cards: $e');
    }
  }

  Future<void> _addWorkoutCard(
      String title, String subtitle, int weekday) async {
    try {
      await _firestore
          .collection('users')
          .doc(widget.userId)
          .collection('workoutCards')
          .add({
        'title': title,
        'subtitle': subtitle,
        'weekday': weekday,
      });
      _fetchWorkoutCards();
    } catch (e) {
      print('Error adding workout card: $e');
    }
  }

  Future<void> _saveAppointment(DateTime date, TimeOfDay time) async {
    try {
      await _firestore
          .collection('users')
          .doc(widget.userId)
          .collection('appointments') // Subcoleção de appointments
          .doc(
              'nutritionist') // Aqui pode ser um identificador único ou um nome fixo
          .set(
              {
            'date': date.toIso8601String(),
            'hour': time.hour,
            'minute': time.minute,
          },
              SetOptions(
                  merge: true)); // Merge para não sobrescrever dados existentes
    } catch (e) {
      print('Error saving appointment: $e');
    }
  }

  Future<void> _fetchAppointment() async {
    try {
      final appointmentDoc = await _firestore
          .collection('users')
          .doc(widget.userId)
          .collection('appointments') // Subcoleção de appointments
          .doc('nutritionist') // O identificador fixo, ou pode ser dinâmico
          .get();

      if (appointmentDoc.exists) {
        var appointment = appointmentDoc.data();
        var date = DateTime.parse(appointment?['date']);
        var time = TimeOfDay(
            hour: appointment?['hour'], minute: appointment?['minute']);
        setState(() {
          _selectedAppointmentDate = date;
          _selectedTime = time;
        });
      }
    } catch (e) {
      print('Error fetching appointment: $e');
    }
  }

  Future<void> _saveTrainerAppointment(DateTime date, TimeOfDay time) async {
    try {
      await _firestore
          .collection('users')
          .doc(widget.userId)
          .collection('appointments')
          .doc('trainer')
          .set({
        'date': date.toIso8601String(),
        'hour': time.hour,
        'minute': time.minute,
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error saving trainer appointment: $e');
    }
  }

  Future<void> _fetchTrainerAppointment() async {
    try {
      final trainerAppointmentDoc = await _firestore
          .collection('users')
          .doc(widget.userId)
          .collection('appointments')
          .doc('trainer')
          .get();

      if (trainerAppointmentDoc.exists) {
        var appointment = trainerAppointmentDoc.data();
        var date = DateTime.parse(appointment?['date']);
        var time = TimeOfDay(
            hour: appointment?['hour'], minute: appointment?['minute']);
        setState(() {
          _selectedTrainerAppointmentDate = date;
          _selectedTrainerTime = time;
        });
      }
    } catch (e) {
      print('Error fetching trainer appointment: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Obtém as cores do tema
    final isDarkMode = AdaptiveTheme.of(context).mode.isDark;
    final textColor = theme.primaryColor;
    final backgroundColor = theme.cardColor; // Cor do fundo adaptável ao tema
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(
                      userId: widget.userId,
                    ),
                  ),
                ).then((_) {
                  _fetchUserName(); // Refresh user name
                  _fetchWorkoutCards(); // Refresh workout cards
                  _fetchAppointment(); // Refresh appointments
                  _fetchTrainerAppointment(); // Refresh trainer appointments
                  _fetchUserTier(); // Refresh user tier
                });
              },
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey[300],
              ),
            ),
            const SizedBox(width: 10),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: "Hello, ",
                    style: TextStyle(color: Colors.orange), // "Hello" in orange
                  ),
                  if (_userName != null)
                    TextSpan(
                      text: _userName!,
                      style: TextStyle(
                          color: theme.primaryColor), // Username in black
                    ),
                ],
              ),
            )
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
            color: theme.primaryColor,
          ),
        ],
        elevation: 1,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(116),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 10.0),
            child: Theme(
              data: Theme.of(context).copyWith(
                textTheme: TextTheme(
                  bodyLarge: TextStyle(color: theme.primaryColor),
                ),
              ),
              child: EasyDateTimeLine(
                initialDate: today,
                onDateChange: (selectedDate) {
                  setState(() {
                    _selectedDate = selectedDate;
                    selectedWeekday = selectedDate.weekday;
                  });
                  _fetchWorkoutCards();
                },
                headerProps: EasyHeaderProps(
                  monthPickerType: MonthPickerType.switcher,
                  dateFormatter: DateFormatter.fullDateDMY(),
                ),
                dayProps: EasyDayProps(
                  dayStructure: DayStructure.dayStrDayNum,
                  height: 60.0,
                  width: 60.0,
                  inactiveDayStyle: DayStyle(
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    dayNumStyle: TextStyle(color: textColor),
                    dayStrStyle: TextStyle(color: textColor),
                  ),
                  activeDayStyle: const DayStyle(
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
                    dayNumStyle: TextStyle(color: Colors.white),
                    dayStrStyle: TextStyle(color: Colors.white),
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
              const SizedBox(height: 20),
              _buildSectionTitle("Your Nutritionist"),
              _buildNutritionistCard(), // Exibe o card do nutricionista
              const SizedBox(height: 10),
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
    final theme = Theme.of(context);
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: theme.primaryColor,
      ),
    );
  }

  Widget _buildSectionTitleWithButton(String title, VoidCallback onPressed) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: theme.primaryColor,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add, color: Colors.orange),
          onPressed: onPressed,
        ),
      ],
    );
  }

  void _showAddWorkoutDialog() {
    final theme = Theme.of(context);
    final TextEditingController titleController = TextEditingController();
    final TextEditingController subtitleController = TextEditingController();
    int selectedDay = DateTime.now().weekday;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          // Isso permite atualizar o estado do Dialog
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Add New Workout"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration:
                        const InputDecoration(labelText: "Workout Title"),
                  ),
                  TextField(
                    controller: subtitleController,
                    decoration:
                        const InputDecoration(labelText: "Workout Subtitle"),
                  ),
                  DropdownButton<int>(
                    value: selectedDay,
                    items: List.generate(7, (index) {
                      return DropdownMenuItem(
                        value: index + 1,
                        child: Text(DateFormat('EEEE')
                            .format(DateTime(2024, 1, index + 1))),
                      );
                    }),
                    onChanged: (value) {
                      setDialogState(() {
                        // Atualiza o estado do Dialog
                        selectedDay = value!;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Cancel",
                      style: TextStyle(color: theme.primaryColor)),
                ),
                TextButton(
                  onPressed: () {
                    if (titleController.text.isNotEmpty &&
                        subtitleController.text.isNotEmpty) {
                      _addWorkoutCard(titleController.text,
                          subtitleController.text, selectedDay);
                      Navigator.of(context).pop();
                    }
                  },
                  child:
                      const Text("Add", style: TextStyle(color: Colors.orange)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildSectionSubitle(String title) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: TextStyle(fontSize: 14, color: theme.secondaryHeaderColor),
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
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () async {
        final bool? shouldRefresh = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WorkoutDetailPage(
              title: title,
              subtitle: subtitle,
              userId: widget.userId,
            ),
          ),
        );

        if (shouldRefresh == true) {
          _fetchWorkoutCards(); // Refresh the homepage list when a workout is deleted
        }
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
                Text(title, style: TextStyle(color: theme.primaryColor)),
                Text(subtitle,
                    style: TextStyle(color: theme.secondaryHeaderColor)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrainerCard() {
    final theme = Theme.of(context);
    final isDarkMode = AdaptiveTheme.of(context).mode.isDark;

    final cardColor = isDarkMode ? Colors.blueGrey[900] : Colors.blue[50];
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final buttonColor = isDarkMode ? Colors.orange[700] : Colors.orange;

    if (_userTier == 'Plan One') {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubscriptionPage(userId: widget.userId),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              minimumSize: const Size(double.infinity, 80),
            ),
            child: Text(
              "Purchase a subscription plan to gain access to a personal trainer",
              style: TextStyle(
                color: textColor,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: GestureDetector(
          onTap: () async {
            DateTime today = DateTime.now();
            DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: today,
              firstDate: today,
              lastDate: DateTime(2101),
            );

            if (selectedDate != null) {
              TimeOfDay? selectedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(DateTime.now()),
              );

              if (selectedTime != null) {
                setState(() {
                  _selectedTrainerAppointmentDate = selectedDate;
                  _selectedTrainerTime = selectedTime;
                });
                _saveTrainerAppointment(selectedDate, selectedTime);
              }
            }
          },
          child: const Icon(Icons.calendar_month, color: Colors.blue),
        ),
        title:
            Text("Your Personal Trainer", style: TextStyle(color: textColor)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Contact: trainer@pulsegym.com",
                style: TextStyle(color: textColor)),
            Text("Specialization: Personal Trainer",
                style: TextStyle(color: textColor)),
            const SizedBox(height: 10),
            _selectedTrainerAppointmentDate != null &&
                    _selectedTrainerTime != null
                ? Text(
                    'Appointment: ${_selectedTrainerAppointmentDate!.day}-${_selectedTrainerAppointmentDate!.month}-${_selectedTrainerAppointmentDate!.year} ${DateFormat('HH:mm').format(DateTime(
                      _selectedTrainerAppointmentDate!.year,
                      _selectedTrainerAppointmentDate!.month,
                      _selectedTrainerAppointmentDate!.day,
                      _selectedTrainerTime!.hour,
                      _selectedTrainerTime!.minute,
                    ))}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                : const Text('No appointment set'),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionistCard() {
    final isDarkMode = AdaptiveTheme.of(context).mode.isDark;
    final cardColor = isDarkMode ? Colors.green[900] : Colors.green[50];
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final buttonColor = isDarkMode ? Colors.orange[700] : Colors.orange;

    if (_userTier == 'Plan One' || _userTier == 'Plan Two') {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubscriptionPage(userId: widget.userId),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              minimumSize: const Size(double.infinity, 80),
            ),
            child: Text(
              "Purchase a subscription plan to gain access to a nutritionist",
              style: TextStyle(
                color: textColor,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: GestureDetector(
          onTap: () async {
            DateTime today = DateTime.now();
            DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: today,
              firstDate: today,
              lastDate: DateTime(2101),
            );

            if (selectedDate != null) {
              TimeOfDay? selectedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(DateTime.now()),
              );

              if (selectedTime != null) {
                setState(() {
                  _selectedAppointmentDate = selectedDate;
                  _selectedTime = selectedTime;
                });
                _saveAppointment(selectedDate, selectedTime);
              }
            }
          },
          child: const Icon(Icons.calendar_month, color: Colors.green),
        ),
        title: Text("Your Nutritionist", style: TextStyle(color: textColor)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Contact: nutritionist@pulsegym.com",
                style: TextStyle(color: textColor)),
            Text("Specialization: Diet & Nutrition",
                style: TextStyle(color: textColor)),
            const SizedBox(height: 10),
            _selectedAppointmentDate != null && _selectedTime != null
                ? Text(
                    'Appointment: ${_selectedAppointmentDate!.day}-${_selectedAppointmentDate!.month}-${_selectedAppointmentDate!.year} ${DateFormat('HH:mm').format(DateTime(
                      _selectedAppointmentDate!.year,
                      _selectedAppointmentDate!.month,
                      _selectedAppointmentDate!.day,
                      _selectedTime!.hour,
                      _selectedTime!.minute,
                    ))}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                : const Text('No appointment set'),
          ],
        ),
      ),
    );
  }
}
