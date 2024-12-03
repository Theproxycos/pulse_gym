import 'package:flutter/material.dart';
// Ajuste o caminho conforme necessário

import 'plan_description.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  int?
      selectedPlanIndex; // Índice do plano selecionado (null se nenhum plano for selecionado)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white, title: Text("Subscription Plan")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Centraliza o conteúdo verticalmente
          crossAxisAlignment: CrossAxisAlignment
              .center, // Centraliza o conteúdo horizontalmente
          children: [
            const Text(
              "Select a plan",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildPlanCard(
              context: context,
              title: "Plan One",
              price: "20€",
              index: 0,
              description: "Description for Plan One",
            ),
            const SizedBox(height: 10),
            _buildPlanCard(
              context: context,
              title: "Plan Two",
              price: "30€",
              index: 1,
              description: "Description for Plan Two",
            ),
            const SizedBox(height: 10),
            _buildPlanCard(
              context: context,
              title: "Plan Three",
              price: "40€",
              index: 2,
              description: "Description for Plan Three",
            ),
            const SizedBox(
                height: 20), // Espaço extra entre as caixas e o botão
            ElevatedButton(
              onPressed: selectedPlanIndex != null
                  ? () {
                      // Ação para "Proceed to Pay"
                    }
                  : null, // Desabilita o botão caso nenhum plano esteja selecionado
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedPlanIndex != null
                    ? Colors.blue
                    : Colors
                        .grey, // Azul se houver plano selecionado, cinza se não
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Center(
                child: Text(
                  "Proceed to Pay",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required BuildContext context,
    required String title,
    required String price,
    required int index,
    required String description, // Agora passa a descrição para cada plano
  }) {
    final isSelected = selectedPlanIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPlanIndex = isSelected
              ? null
              : index; // Alterna entre selecionado e desmarcado
        });
      },
      child: Card(
        color: isSelected
            ? Colors.orange[300]
            : Colors.orange, // Cor mais clara quando selecionado
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? Colors.black
                          : Colors.white, // Cor do texto invertida
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? Colors.black
                          : Colors.white, // Cor do texto invertida
                    ),
                  ),
                ],
              ),
              if (isSelected)
                IconButton(
                  icon: const Icon(
                    Icons.info_outline,
                    color: Colors
                        .black, // Ícone de descrição (aparece quando selecionado)
                  ),
                  onPressed: () {
                    // Navegar para a página de descrição do plano
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlanDescriptionPage(
                          planTitle: title,
                          planDescription: description,
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
