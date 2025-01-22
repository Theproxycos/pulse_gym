import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'all_exercises.dart';

class WorkoutDetailPage extends StatefulWidget {
  final String title;
  final String subtitle;
  final String userId;

  const WorkoutDetailPage({
    required this.title,
    required this.subtitle,
    Key? key, required this.userId,
  }) : super(key: key);

  @override
  State<WorkoutDetailPage> createState() => _WorkoutDetailPageState();
}

class _WorkoutDetailPageState extends State<WorkoutDetailPage> {
  static final Map<String, List<dynamic>> workoutExercises = {};

  List<dynamic> get selectedExercises =>
      workoutExercises[widget.title] ??= [];

  void _navigateToAllExercises(BuildContext context) async {
    final selectedExercise = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GymPage(
          onExerciseSelected: (exercise) {
            Navigator.pop(context, exercise); // Return selected exercise
          }, userId: widget.userId,
        ),
      ),
    );

    if (selectedExercise != null) {
      setState(() {
        selectedExercises.add(selectedExercise);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.brown,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.subtitle,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            const Text(
              "Selected Exercises",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: selectedExercises.isEmpty
                  ? const Center(
                      child: Text(
                        "No exercises added yet. Click below to add.",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: selectedExercises.length,
                      itemBuilder: (context, index) {
                        final exercise = selectedExercises[index];
                        return ListTile(
                          leading: Image.network(
                            exercise['gifUrl'],
                            width: 50,
                            height: 50,
                          ),
                          title: Text(exercise['name']),
                          subtitle: Text(
                              "Body Part: ${exercise['bodyPart']}\nEquipment: ${exercise['equipment']}"),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                selectedExercises.removeAt(index);
                              });
                            },
                          ),
                        );
                      },
                    ),
            ),
            ElevatedButton(
              onPressed: () => _navigateToAllExercises(context),
              child: const Text('Add Exercise'),
            ),
          ],
        ),
      ),
    );
  }
}

// Página de detalhes do exercício
class ExerciseDetailPage extends StatelessWidget {
  final dynamic exercise;

  const ExerciseDetailPage({required this.exercise, Key? key})
      : super(key: key);

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
            const SizedBox(height: 20),
            Text(
              "Name: ${exercise['name']}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text("Body Part: ${exercise['bodyPart']}"),
            Text("Target: ${exercise['target']}"),
            Text("Equipment: ${exercise['equipment']}"),
          ],
        ),
      ),
    );
  }
}

class AddExercisePage extends StatefulWidget {
  @override
  _AddExercisePageState createState() => _AddExercisePageState();
}

class _AddExercisePageState extends State<AddExercisePage> {
  final _nameController = TextEditingController();
  final _bodyPartController = TextEditingController();
  final _equipmentController = TextEditingController();
  final _gifUrlController = TextEditingController();

  void _addExercise() {
    final newExercise = {
      'name': _nameController.text,
      'bodyPart': _bodyPartController.text,
      'equipment': _equipmentController.text,
      'gifUrl': _gifUrlController.text,
    };

    // Validar campos
    if (_nameController.text.isEmpty ||
        _bodyPartController.text.isEmpty ||
        _equipmentController.text.isEmpty ||
        _gifUrlController.text.isEmpty) {
      return; // Adicione uma mensagem de erro se necessário
    }

    // Navegar de volta e adicionar o exercício na lista de exercícios
    Navigator.pop(context, newExercise);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Novo Exercício'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nome do Exercício'),
            ),
            TextField(
              controller: _bodyPartController,
              decoration: const InputDecoration(labelText: 'Parte do Corpo'),
            ),
            TextField(
              controller: _equipmentController,
              decoration: const InputDecoration(labelText: 'Equipamento'),
            ),
            TextField(
              controller: _gifUrlController,
              decoration: const InputDecoration(labelText: 'URL do GIF'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addExercise,
              child: const Text('Adicionar Exercício'),
            ),
          ],
        ),
      ),
    );
  }
}
