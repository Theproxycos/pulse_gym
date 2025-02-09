import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriptionPage extends StatefulWidget {
  final String userId; // Passar o ID do usuário ao navegar para esta página

  const SubscriptionPage({super.key, required this.userId});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _userName; // Para armazenar o nome do usuário
  int? selectedPlanIndex; // Para acompanhar o plano selecionado
  int? currentPlanIndex; // Índice do plano já comprado

  @override
  void initState() {
    super.initState();
    if (widget.userId.isEmpty) {
      print('Error: User ID is empty!');
      return;
    }
    _fetchUserName();
    _fetchUserPlan();
  }

  // Buscar o plano atual do usuário
  Future<void> _fetchUserPlan() async {
    try {
      final userDoc =
          await _firestore.collection('users').doc(widget.userId).get();
      if (userDoc.exists && userDoc.data()!.containsKey('subscription_plan')) {
        String currentPlan = userDoc['subscription_plan'];

        setState(() {
          currentPlanIndex = _getPlanIndex(currentPlan);
        });
      }
    } catch (e) {
      print('Error fetching user plan: $e');
    }
  }

  // Converter nome do plano salvo no Firestore para um índice correspondente
  int? _getPlanIndex(String plan) {
    switch (plan) {
      case "Plan One":
        return 0;
      case "Plan Two":
        return 1;
      case "Plan Three":
        return 2;
      default:
        return null;
    }
  }

  Future<void> _fetchUserName() async {
    try {
      final userDoc =
          await _firestore.collection('users').doc(widget.userId).get();
      if (userDoc.exists) {
        setState(() {
          _userName = userDoc['username']; // Supondo que o campo é 'username'
        });
      }
    } catch (e) {
      print('Error fetching user name: $e');
    }
  }

  // Este método atualiza o plano selecionado do usuário no Firestore
  Future<void> _updateUserPlan() async {
    if (selectedPlanIndex == null) {
      // Se nenhum plano foi selecionado
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a plan to proceed")),
      );
      return;
    }

    String selectedPlan;
    switch (selectedPlanIndex) {
      case 0:
        selectedPlan = "Plan One";
        break;
      case 1:
        selectedPlan = "Plan Two";
        break;
      case 2:
        selectedPlan = "Plan Three";
        break;
      default:
        selectedPlan = "Unknown";
    }

    try {
      // Atualizando no Firestore o plano selecionado
      await _firestore.collection('users').doc(widget.userId).update({
        'subscription_plan': selectedPlan, // Atualizando o campo do plano
      });

      // Atualizando o estado local para refletir o plano comprado
      setState(() {
        currentPlanIndex = selectedPlanIndex;
      });

      // Exibindo uma mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Plan selected successfully")),
      );

      // Aqui você pode navegar para a próxima página (página de pagamento, por exemplo)
      // Navigator.push(...);
    } catch (e) {
      print("Error updating user plan: $e");
      print(widget.userId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to select plan")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        title: Text(
            _userName != null ? "Hello, $_userName!" : "Subscription Plan"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
              description:
                  "Unlock custom creation further than 6 exercises and unlock features.",
            ),
            const SizedBox(height: 10),
            _buildPlanCard(
              context: context,
              title: "Plan Two",
              price: "30€",
              index: 1,
              description:
                  "Access personalized training features and additional services.",
            ),
            const SizedBox(height: 10),
            _buildPlanCard(
              context: context,
              title: "Plan Three",
              price: "40€",
              index: 2,
              description:
                  "Full access to training and nutrition plans. All features unlocked.",
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: selectedPlanIndex != null
                  ? () {
                      _updateUserPlan(); // Atualizar plano no Firestore
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    selectedPlanIndex != null ? Colors.blue : Colors.grey,
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
    required String description,
  }) {
    final isSelected = selectedPlanIndex == index;
    final isCurrentPlan =
        currentPlanIndex == index; // Verifica se é o plano comprado

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPlanIndex = isSelected ? null : index;
        });
      },
      child: Card(
        color: isSelected ? Colors.orange[300] : Colors.orange,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: isCurrentPlan // Adiciona borda ao plano comprado
              ? BorderSide(color: Colors.blue, width: 3)
              : BorderSide.none,
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
                      color: isSelected || isCurrentPlan
                          ? Colors.black
                          : Colors
                              .white, // Texto escuro para selecionado ou comprado
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected || isCurrentPlan
                          ? Colors.black
                          : Colors
                              .white, // Preço em preto quando selecionado ou comprado
                    ),
                  ),
                ],
              ),
              if (isSelected)
                IconButton(
                  icon: const Icon(
                    Icons.info_outline,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    // Exibir um diálogo personalizado quando o ícone de informações for pressionado
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10), // Cantos arredondados
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize
                                  .min, // Tamanho baseado no conteúdo
                              children: [
                                Text(
                                  title, // Título do plano passado aqui
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  description, // Descrição do plano passada aqui
                                  style: const TextStyle(fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Fechar o diálogo
                                  },
                                  child: const Text(
                                    'Close',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                )
            ],
          ),
        ),
      ),
    );
  }
}
