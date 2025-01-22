import 'package:flutter/material.dart';
import '../services/firestore.dart';
import 'all_exercises.dart';

class WorkoutDetailPage extends StatefulWidget {
  final String title;
  final String subtitle;
  final String userId;

  const WorkoutDetailPage({
    required this.title,
    required this.subtitle,
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<WorkoutDetailPage> createState() => _WorkoutDetailPageState();
}

class _WorkoutDetailPageState extends State<WorkoutDetailPage> {
  final FirestoreService _firestoreService = FirestoreService();
  String? workoutCardId;
  List<dynamic> exercises = [];

  @override
  void initState() {
    super.initState();
    _loadWorkoutCard();
  }

  Future<void> _loadWorkoutCard() async {
    try {
      final workoutCard = await _firestoreService.getWorkoutCardByTitle(
        widget.userId,
        widget.title,
      );

      if (workoutCard != null) {
        setState(() {
          workoutCardId = workoutCard['id'];
          exercises = List<dynamic>.from(workoutCard['data']['exercises'] ?? []);
        });
      }
    } catch (e) {
      print('Error loading workout card: $e');
    }
  }

  Future<void> _saveExercisesToFirestore() async {
    if (workoutCardId == null) return;

    final workoutCard = {
      'title': widget.title,
      'subtitle': widget.subtitle,
      'exercises': exercises,
    };

    try {
      await _firestoreService.updateWorkoutCard(
        widget.userId,
        workoutCardId!,
        workoutCard,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Workout updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update workout: $e')),
      );
    }
  }

  void _addExercise(Map<String, dynamic> exercise) async {
    setState(() {
      exercises.add(exercise);
    });
    await _saveExercisesToFirestore();
  }

  void _removeExercise(int index) async {
    setState(() {
      exercises.removeAt(index);
    });
    await _saveExercisesToFirestore();
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
            // Text(
            //   widget.title,
            //   style: const TextStyle(
            //     fontSize: 24,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
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
              child: exercises.isEmpty
                  ? const Center(
                      child: Text(
                        "No exercises added yet. Click below to add.",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: exercises.length,
                      itemBuilder: (context, index) {
                        final exercise = exercises[index];
                        return ListTile(
                          leading: Image.network(
                            exercise['gifUrl'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(
                            exercise['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            "Body Part: ${exercise['bodyPart']}\nEquipment: ${exercise['equipment']}",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeExercise(index),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ExerciseDetailPage(
                                  exercise: exercise,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                final newExercise = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GymPage(
                      onExerciseSelected: (exercise) {
                        Navigator.pop(context, exercise);
                      },
                      userId: widget.userId,
                    ),
                  ),
                );

                if (newExercise != null) {
                  _addExercise(newExercise);
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Exercise'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExerciseDetailPage extends StatelessWidget {
  final dynamic exercise;

  const ExerciseDetailPage({required this.exercise, Key? key}) : super(key: key);

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
