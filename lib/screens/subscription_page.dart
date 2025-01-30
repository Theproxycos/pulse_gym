import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriptionPage extends StatefulWidget {
  final String userId; // Pass the user ID when navigating to this page

  const SubscriptionPage({super.key, required this.userId});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _userName; // To store the user's name
  int? selectedPlanIndex; // To track the selected plan

  @override
  void initState() {
    super.initState();
    if (widget.userId.isEmpty) {
      print('Error: User ID is empty!');
      return; // Stop further execution if userId is invalid
    }
    _fetchUserName(); // Fetch the user's name from Firestore
  }

  Future<void> _fetchUserName() async {
    try {
      final userDoc =
          await _firestore.collection('users').doc(widget.userId).get();
      if (userDoc.exists) {
        setState(() {
          _userName = userDoc['username']; // Assuming the field is 'username'
        });
      }
    } catch (e) {
      print('Error fetching user name: $e');
    }
  }

  // This method updates the user's selected plan in Firestore
  Future<void> _updateUserPlan() async {
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
      await _firestore.collection('users').doc(widget.userId).update({
        'subscription_plan': selectedPlan, // Update the subscription plan field
      });

      // After updating, you can navigate to the payment page or show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Plan selected successfully")),
      );
    } catch (e) {
      print("Error updating user plan: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to select plan")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(_userName != null ? "Hello, $_userName!" : "Subscription Plan"),
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: selectedPlanIndex != null
                  ? () {
                      _updateUserPlan(); // Update plan in Firestore
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedPlanIndex != null
                    ? Colors.blue
                    : Colors.grey,
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
                      color: isSelected ? Colors.black : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.black : Colors.white,
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

// Sample PlanDescriptionPage to show more details of a plan.
class PlanDescriptionPage extends StatelessWidget {
  final String planTitle;
  final String planDescription;

  const PlanDescriptionPage({
    super.key,
    required this.planTitle,
    required this.planDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(planTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(planDescription),
      ),
    );
  }
}
