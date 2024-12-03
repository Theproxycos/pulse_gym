import 'package:flutter/material.dart';
import '../data/muscle_groups.dart';
import '../widgets/custom_bottom_nav_bar.dart'; // Supondo que você tenha uma lista de grupos musculares com suas imagens.

class ExercisesPage extends StatefulWidget {
  const ExercisesPage({super.key});

  @override
  _ExercisesPageState createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Escolha um grupo muscular',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Campo de pesquisa

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  bottom: 5.0), // Padding à esquerda e direita
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 boxes por linha
                  crossAxisSpacing: 10.0, // Espaçamento horizontal
                  mainAxisSpacing: 10.0, // Espaçamento vertical
                  childAspectRatio:
                      1, // Faz com que todas as caixas tenham o mesmo tamanho
                ),
                itemCount: muscleGroups
                    .length, // Certifique-se de que você tem essa lista
                itemBuilder: (context, index) {
                  var muscle =
                      muscleGroups[index]; // A lista de grupos musculares
                  var image = muscle[
                      'image']; // Supondo que você tenha uma chave 'image' para as imagens

                  return GestureDetector(
                    onTap: () {
                      // Navegar para a página de detalhes do grupo muscular
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExerciseDetailsPage(
                              group: muscle['name'] ??
                                  'Grupo Desconhecido'), // Valor padrão se for nulo
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Imagem do grupo muscular
                          Image.asset(
                            image ??
                                'assets/default_image.png', // Valor padrão para imagem se for nulo
                            height: 80, // Tamanho da imagem
                            width: 80,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            muscle['name'] ??
                                'Grupo Desconhecido', // Valor padrão se for nulo
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
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

class ExerciseDetailsPage extends StatelessWidget {
  final String group;

  const ExerciseDetailsPage({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Exercícios para $group',
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Aqui estão os exercícios para o grupo muscular $group',
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
