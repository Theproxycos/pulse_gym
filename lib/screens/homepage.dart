import 'package:flutter/material.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime today = DateTime.now(); // Data selecionada pelo usuário
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Seu código que depende do layout finalizado
      print('Renderização concluída!');
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calcula o mês anterior e seguinte
    DateTime prevMonth = DateTime(today.year, today.month - 1, 1);
    DateTime nextMonth = DateTime(today.year, today.month + 1, 1);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                // Navega para a página de perfil ao clicar na imagem
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
              child: CircleAvatar(
                radius: 18,
                backgroundImage: AssetImage('assets/user_image.png'),
                backgroundColor: Colors.grey[300],
              ),
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
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(116),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 10.0),
            child: EasyDateTimeLine(
              initialDate: today, // Usando a data atual diretamente
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
              _buildSectionTitle("Personalized Training"),
              _buildSectionSubitle(
                  "Gain muscular mass with an individualized routine"),
              const SizedBox(height: 10),
              _buildWorkoutCard(),
              const SizedBox(height: 20),
              _buildSectionTitle("My training sessions"),
              _buildSectionSubitle("Create your own personalized routine"),
              const SizedBox(height: 10),
              _buildMyWorkoutCards(), // Cards com scroll horizontal
              const SizedBox(height: 20),
              _buildSectionTitle("Your personal Trainer"),
              _buildTrainerCard(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 0,
        currentRoute: 'homepage',
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
    );
  }

  Widget _buildSectionSubitle(String title) {
    return Text(
      title,
      style:
          const TextStyle(fontSize: 14, color: Color.fromARGB(255, 49, 48, 48)),
    );
  }

  Widget _buildWorkoutCard() {
    return SizedBox(
      width: double.infinity,
      height: 150,
      child: Card(
        elevation: 2,
        color: const Color(0xff3371FF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWorkoutItem(
                icon: Icons.directions_run,
                title: "Ganho de Massa Muscular",
                subtitle: "Hipertrofia • Balanceado",
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Alinha o texto à esquerda
                    children: [
                      Text(
                        "Progresso 0%",
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                      SizedBox(
                        height:
                            8, // Espaço entre o texto e o LinearProgressIndicator
                      ),
                      SizedBox(
                        width:
                            120, // Define a largura fixa para o LinearProgressIndicator
                        child: LinearProgressIndicator(
                          value: 0.0,
                          backgroundColor: Colors.white,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.orange),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
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
        Icon(icon, color: Colors.orange, size: 30),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontSize: 16, color: Colors.white)),
            Text(subtitle, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  List<Map<String, String>> workoutData = [
    {'title': 'Treino Segunda a Quinta', 'subtitle': '55 min de treino'},
    {'title': 'Treino Sábado', 'subtitle': '40 min de treino'},
    {'title': 'Treino Domingo', 'subtitle': '50 min de treino'},
  ];

  Widget _buildMyWorkoutCards() {
    return SizedBox(
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: workoutData.map((workout) {
          return _buildMyWorkoutCard(
            title: workout['title']!,
            subtitle: workout['subtitle']!,
            icon: Icons.fitness_center,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMyWorkoutCard(
      {required String title,
      required String subtitle,
      required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Card(
        elevation: 2,
        color: const Color(0xff3371FF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
    );
  }

  Widget _buildTrainerCard() {
    return Card(
      color: Colors.blue[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: const ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage('assets/trainer_image.png'),
        ),
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
