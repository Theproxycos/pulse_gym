import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import 'WorkoutDetailPage.dart';
import 'settings_page.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  final String userId;
  const HomePage({super.key, required this.userId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime today = DateTime.now();
  DateTime? _selectedDate;
  DateTime? _selectedAppointmentDate;
  TimeOfDay? _selectedTime;
  int selectedWeekday = DateTime.now().weekday;

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
    _fetchAppointment(); // Fetch the appointment
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

// Alteração do método para salvar na subcoleção 'appointments'
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

  // Alteração do método para buscar da subcoleção 'appointments'
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
                  MaterialPageRoute(
                      builder: (context) => SettingsPage(
                            userId: widget.userId,
                          )),
                );
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
                      style:
                          const TextStyle(color: Colors.black), // Username in black
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
                  selectedWeekday =
                      selectedDate.weekday; // Atualiza o dia da semana
                });
                _fetchWorkoutCards(); // Recarrega os workouts
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
          icon: const Icon(Icons.add, color: Colors.orange),
          onPressed: onPressed,
        ),
      ],
    );
  }

  void _showAddWorkoutDialog() {
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
                  child: const Text("Cancel",
                      style: TextStyle(color: Colors.black)),
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
      child: ListTile(
        // leading: CircleAvatar(),
        leading: GestureDetector(
          onTap: () async {},
          child: const Icon(Icons.calendar_month,
              color: Color.fromARGB(255, 15, 8, 215)),
        ),
        title: const Text("Trainer name"),
        subtitle: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Contact: trainer@pulsegym.com"),
            Text("Specialization: Personal Trainer"),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionistCard() {
    return Card(
      color: Colors.green[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: GestureDetector(
          onTap: () async {
            // Abre o seletor de data
            DateTime today = DateTime.now();
            DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: today, // Define a data inicial como o dia de hoje
              firstDate:
                  today, // Define o primeiro dia selecionável como o dia de hoje
              lastDate: DateTime(2101), // Data limite para seleção
            );

            if (selectedDate != null) {
              // Após a data ser escolhida, abre o seletor de hora
              TimeOfDay? selectedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(DateTime.now()),
              );

              if (selectedTime != null) {
                // Atualiza o estado com a data e hora selecionadas
                setState(() {
                  _selectedAppointmentDate = selectedDate;
                  _selectedTime = selectedTime;
                });
                // Salvar no Firestore
                _saveAppointment(selectedDate, selectedTime);
              }
            }
          },
          child: const Icon(Icons.calendar_month, color: Colors.green),
        ),
        title: const Text("Your Nutritionist"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Contact: nutritionist@pulsegym.com"),
            const Text("Specialization: Diet & Nutrition"),
            SizedBox(height: 10),
            // Exibe a data e hora selecionadas
            _selectedAppointmentDate != null && _selectedTime != null
                ? Text(
                    'Appointment: ${_selectedAppointmentDate!.day}-${_selectedAppointmentDate!.month}-${_selectedAppointmentDate!.year} ${DateFormat('HH:mm').format(DateTime(
                      _selectedAppointmentDate!.year,
                      _selectedAppointmentDate!.month,
                      _selectedAppointmentDate!.day,
                      _selectedTime!.hour,
                      _selectedTime!.minute,
                    ))}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                : const Text('No appointment set'),
          ],
        ),
      ),
    );
  }
}
