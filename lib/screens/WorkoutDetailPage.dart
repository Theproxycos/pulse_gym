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
  String? subscriptionPlan; // Armazena o plano de subscrição do utilizador

  @override
  void initState() {
    super.initState();
    _loadWorkoutCard();
    _loadSubscriptionPlan(); // Carrega o plano de subscrição do utilizador
  }

// Busca o plano de subscrição do utilizador
  Future<void> _loadSubscriptionPlan() async {
    try {
      final userDoc = await _firestoreService.getUserById(widget.userId);
      if (userDoc != null) {
        setState(() {
          subscriptionPlan = userDoc['subscription_plan'];
        });
      }
    } catch (e) {
      print('Error fetching subscription plan: $e');
    }
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
          exercises =
              List<dynamic>.from(workoutCard['data']['exercises'] ?? []);
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

      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Workout atualizado com sucesso!')),
      // );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update workout: $e')),
      );
    }
  }

  void _addExercise(Map<String, dynamic> exercise) async {
    if (subscriptionPlan == null && exercises.length >= 6) {
      // Se não houver subscrição e o utilizador atingir o limite, mostra um alerta
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                "You can only add up to 6 exercises without a subscription.")),
      );
      return;
    }

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

  void _deleteWorkoutCard() async {
    if (workoutCardId == null) return;

    try {
      await _firestoreService.deleteWorkoutCard(widget.userId, workoutCardId!);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Workout deleted successfully!')),
      );

      Navigator.pop(
          context, true); // Envia 'true' de volta para a tela anterior
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete workout: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () =>
              Navigator.of(context).pushReplacementNamed('/homepage'),
        ),
        title: Text(widget.title),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Workout'),
                  content: const Text(
                      'Are you sure you want to delete this workout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _deleteWorkoutCard();
                      },
                      child: const Text('Delete',
                          style: TextStyle(color: Colors.orange)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: Text(
                            "Body Part: ${exercise['bodyPart']}\nEquipment: ${exercise['equipment']}",
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 14),
                          ),
                          trailing: IconButton(
                            icon:
                                const Icon(Icons.delete, color: Colors.orange),
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
                // Limita a adição de exercícios com base no plano de subscrição
                if (subscriptionPlan == null && exercises.length >= 6) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            "You can only add up to 6 exercises without a subscription.")),
                  );
                  return;
                }

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
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Add Exercise',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
                backgroundColor: Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
