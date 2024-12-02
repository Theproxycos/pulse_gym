import 'package:flutter/material.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import '../widgets/custom_bottom_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
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
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(116),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 10.0),
            child: EasyDateTimeLine(
              initialDate: DateTime.now(), // Data inicial necessária
              onDateChange: (selectedDate) {
                setState(() {});
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
              _buildMyWorkoutCards(),
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
    return Card(
      elevation: 2,
      color: Color(0xff3371FF),
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
              children: const [
                Text(
                  "Progresso 0%",
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
                LinearProgressIndicator(
                  value: 0.0,
                  backgroundColor: Colors.white,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
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

  // Função que cria os cards de treino com scroll horizontal
  Widget _buildMyWorkoutCards() {
    return Container(
      height: 150, // Define a altura dos cards
      child: ListView(
        scrollDirection: Axis.horizontal, // Definir scroll horizontal
        children: [
          _buildMyWorkoutCard(
            title: "Treino Segunda a Quinta",
            subtitle: "55 min de treino",
            icon: Icons.fitness_center,
          ),
          _buildMyWorkoutCard(
            title: "Treino Sábado",
            subtitle: "40 min de treino",
            icon: Icons.fitness_center,
          ),
          _buildMyWorkoutCard(
            title: "Treino Domingo",
            subtitle: "50 min de treino",
            icon: Icons.fitness_center,
          ),
        ],
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
        color: Color(0xff3371FF),
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
