import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../widgets/custom_bottom_nav_bar.dart';

class GymPage extends StatefulWidget {
  @override
  _GymPageState createState() => _GymPageState();
}

class _GymPageState extends State<GymPage> {
  List<dynamic> exercises = [];
  List<dynamic> filteredExercises = [];
  List<String> bodyParts = [];
  List<String> equipment = [];
  bool isLoading = true;
  String selectedBodyPart = 'all';
  String selectedEquipment = 'all';
  String searchQuery = "";

  final String apiKey =
      'a5f6544e3bmsh3eb01b7e96b3e2ap13bb85jsn989013367bbe'; // Substituir pela sua API key.
  final String apiHost = 'exercisedb.p.rapidapi.com';

  @override
  void initState() {
    super.initState();
    fetchBodyParts();
    fetchEquipment();
    fetchExercises();
  }

  // Função para buscar os grupos musculares
  Future<void> fetchBodyParts() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://$apiHost/exercises/bodyPartList'), // URL para bodyParts
        headers: {
          'X-RapidAPI-Key': apiKey,
          'X-RapidAPI-Host': apiHost,
        },
      );
      final data = json.decode(response.body);

      setState(() {
        bodyParts =
            List<String>.from(data); // Ajustar conforme a resposta da API
        bodyParts.insert(0, 'all'); // Adicionar a opção "all"
      });
    } catch (e) {
      print("Erro ao buscar bodyParts: $e");
    }
  }

  // Função para buscar os equipamentos
  Future<void> fetchEquipment() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://$apiHost/exercises/equipmentList'), // URL para equipment
        headers: {
          'X-RapidAPI-Key': apiKey,
          'X-RapidAPI-Host': apiHost,
        },
      );
      final data = json.decode(response.body);

      setState(() {
        equipment =
            List<String>.from(data); // Ajustar conforme a resposta da API
        equipment.insert(0, 'all'); // Adicionar a opção "all"
      });
    } catch (e) {
      print("Erro ao buscar equipment: $e");
    }
  }

  // Função para buscar os exercícios
  Future<void> fetchExercises() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://$apiHost/exercises?limit=400&offset=0'), // Aumente o limite para mais exercícios
        headers: {
          'X-RapidAPI-Key': apiKey,
          'X-RapidAPI-Host': apiHost,
        },
      );

      final data = json.decode(response.body);

      setState(() {
        exercises = data;
        filteredExercises = data;
        isLoading = false;
      });
    } catch (e) {
      print("Erro ao buscar exercícios: $e");
    }
  }

  void applyFilters() {
    setState(() {
      filteredExercises = exercises.where((exercise) {
        final matchesBodyPart = selectedBodyPart == 'all' ||
            exercise['bodyPart']?.toLowerCase() ==
                selectedBodyPart.toLowerCase(); // Normalizar comparação

        final matchesEquipment = selectedEquipment == 'all' ||
            exercise['equipment']?.toLowerCase() ==
                selectedEquipment.toLowerCase(); // Normalizar comparação

        final matchesSearch = searchQuery.isEmpty ||
                exercise['name']!
                    .toString()
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) ??
            false;

        return matchesBodyPart && matchesEquipment && matchesSearch;
      }).toList();
    });
  }

  // Função para mostrar a janela de filtro de "Muscle Parts"
  void showBodyPartsFilter() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Muscle Part"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: bodyParts.map((bodyPart) {
                return ListTile(
                  title: Text(bodyPart),
                  onTap: () {
                    setState(() {
                      selectedBodyPart = bodyPart;
                      applyFilters();
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  // Função para mostrar a janela de filtro de "Equipments"
  void showEquipmentFilter() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Equipment"),
          content: SingleChildScrollView(
            // Adicionando o scroll vertical
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: equipment.map((equip) {
                return ListTile(
                  title: Text(equip),
                  onTap: () {
                    setState(() {
                      selectedEquipment = equip;
                      applyFilters();
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gym Exercises"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Barra de Busca
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Search for exercises",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      searchQuery = value;
                      applyFilters();
                    },
                  ),
                ),
                // Filtros
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      // Filtro de "All" - Exibe todos os exercícios
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedBodyPart = 'all';
                            selectedEquipment = 'all';
                            searchQuery = '';
                            applyFilters();
                          });
                        },
                        child: Text("All"),
                      ),
                      SizedBox(width: 10),
                      // Filtro de Grupos Musculares (Body Parts)
                      ElevatedButton(
                        onPressed: showBodyPartsFilter,
                        child: Text("Muscle Parts"),
                      ),
                      SizedBox(width: 10),
                      // Filtro de Equipamentos
                      ElevatedButton(
                        onPressed: showEquipmentFilter,
                        child: Text("Equipments"),
                      ),
                    ],
                  ),
                ),
                // Grid de Exercícios
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: filteredExercises.length,
                    itemBuilder: (context, index) {
                      final exercise = filteredExercises[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ExerciseDetailPage(exercise: exercise),
                            ),
                          );
                        },
                        child: ExerciseCard(exercise: exercise),
                      );
                    },
                  ),
                ),
              ],
            ),
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 3,
        currentRoute: 'Exercises',
      ),
    );
  }
}

// Widget do Card de Exercício
class ExerciseCard extends StatelessWidget {
  final dynamic exercise;

  const ExerciseCard({required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            exercise['gifUrl'],
            height: 80,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 10),
          Text(
            exercise['name'],
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Página de Detalhes do Exercício
class ExerciseDetailPage extends StatelessWidget {
  final dynamic exercise;

  const ExerciseDetailPage({required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(exercise['name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              exercise['gifUrl'],
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Text(
              "Name: ${exercise['name']}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text("Body Part: ${exercise['bodyPart']}"),
            Text("Target: ${exercise['target']}"),
            SizedBox(height: 20),
            Text(
              "Description:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(exercise['description'] ?? "No description available."),
          ],
        ),
      ),
    );
  }
}
