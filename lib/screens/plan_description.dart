import 'package:flutter/material.dart';

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
        backgroundColor: Colors.orange,
        title: Text(planTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              planDescription,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
