import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../widgets/custom_bottom_nav_bar.dart';

class GymPage extends StatefulWidget {
  final Function(dynamic)? onExerciseSelected;
  final String userId; // Add userId parameter

  const GymPage({
    this.onExerciseSelected,
    required this.userId, // Make userId a required field
    Key? key,
  }) : super(key: key);

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
      'a5f6544e3bmsh3eb01b7e96b3e2ap13bb85jsn989013367bbe'; // Substitua pela sua chave de API.
  final String apiHost = 'exercisedb.p.rapidapi.com';

  @override
  void initState() {
    super.initState();
    fetchBodyParts();
    fetchEquipment();
    fetchExercises();
  }

  // Busca os grupos musculares (body parts) da API
  Future<void> fetchBodyParts() async {
    try {
      final response = await http.get(
        Uri.parse('https://$apiHost/exercises/bodyPartList'),
        headers: {
          'X-RapidAPI-Key': apiKey,
          'X-RapidAPI-Host': apiHost,
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          bodyParts = List<String>.from(data);
          bodyParts.insert(0, 'all'); // Adicionar a opção "all"
        });
      }
    } catch (e) {
      print("Erro ao buscar bodyParts: $e");
    }
  }

  // Busca os equipamentos da API
  Future<void> fetchEquipment() async {
    try {
      final response = await http.get(
        Uri.parse('https://$apiHost/exercises/equipmentList'),
        headers: {
          'X-RapidAPI-Key': apiKey,
          'X-RapidAPI-Host': apiHost,
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          equipment = List<String>.from(data);
          equipment.insert(0, 'all'); // Adicionar a opção "all"
        });
      }
    } catch (e) {
      print("Erro ao buscar equipment: $e");
    }
  }

  // Busca todos os exercícios da API
  Future<void> fetchExercises() async {
    try {
      final response = await http.get(
        Uri.parse('https://$apiHost/exercises?limit=400&offset=0'),
        headers: {
          'X-RapidAPI-Key': apiKey,
          'X-RapidAPI-Host': apiHost,
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          exercises = data;
          filteredExercises = data;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Erro ao buscar exercícios: $e");
    }
  }

  // Aplica os filtros de busca, bodyPart e equipamento
  void applyFilters() {
    setState(() {
      filteredExercises = exercises.where((exercise) {
        final matchesBodyPart = selectedBodyPart == 'all' ||
            exercise['bodyPart']?.toLowerCase() ==
                selectedBodyPart.toLowerCase();

        final matchesEquipment = selectedEquipment == 'all' ||
            exercise['equipment']?.toLowerCase() ==
                selectedEquipment.toLowerCase();

        final matchesSearch = searchQuery.isEmpty ||
            (exercise['name'] != null &&
                exercise['name']
                    .toString()
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()));

        return matchesBodyPart && matchesEquipment && matchesSearch;
      }).toList();
    });
  }

  // Exibe o modal para selecionar body parts
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

  // Exibe o modal para selecionar equipamentos
  void showEquipmentFilter() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Equipment"),
          content: SingleChildScrollView(
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
        title: const Text(
          "Gym Exercises",
          style: TextStyle(color: Colors.orange),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Barra de busca
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
                      // Filtro "All"
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedBodyPart = 'all';
                            selectedEquipment = 'all';
                            searchQuery = '';
                            applyFilters();
                          });
                        },
                        child: Text("All", style: TextStyle(color: Colors.orange)),
                      ),
                      SizedBox(width: 10),
                      // Filtro de grupos musculares
                      ElevatedButton(
                        onPressed: showBodyPartsFilter,
                        child: Text("Muscle Parts",style: TextStyle(color: Colors.orange)),
                      ),
                      SizedBox(width: 10),
                      // Filtro de equipamentos
                      ElevatedButton(
                        onPressed: showEquipmentFilter,
                        child: Text("Equipments",style: TextStyle(color: Colors.orange)),
                      ),
                    ],
                  ),
                ),
                // Grid com os exercícios
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
                          if (Navigator.canPop(context)) {
                            // Apenas fecha a página se houver uma anterior no histórico
                            Navigator.pop(context, exercise);
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ExerciseDetailPage(exercise: exercise),
                              ),
                            );
                          }
                        },
                        onLongPress: () {
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
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 3,
        currentRoute: 'Exercises',
        userId: widget.userId,
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
