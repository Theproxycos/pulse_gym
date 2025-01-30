import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../widgets/custom_bottom_nav_bar.dart';

class BodyMeasurementsPage extends StatefulWidget {
  final String userId;

  const BodyMeasurementsPage({Key? key, required this.userId})
      : super(key: key);

  @override
  _BodyMeasurementsPageState createState() => _BodyMeasurementsPageState();
}

class _BodyMeasurementsPageState extends State<BodyMeasurementsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  double? weight;
  double? height;
  List<FlSpot> weightData = [];
  List<String> weightDates = [];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() async {
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(widget.userId).get();
    if (userDoc.exists) {
      setState(() {
        weight = (userDoc['weight'] as num?)?.toDouble();
        height = (userDoc['height'] as num?)?.toDouble();
      });
    }
    // Now fetch weight logs only after user data is fetched
    _fetchWeightLogs();
  }

  void _fetchWeightLogs() async {
    QuerySnapshot logs = await _firestore
        .collection('users')
        .doc(widget.userId)
        .collection('weightLogs')
        .orderBy('date', descending: false)
        .get();

    setState(() {
      weightData = [];
      weightDates = [];
      int index = 0;
      for (var doc in logs.docs) {
        double weightValue = (doc['weight'] as num).toDouble();
        DateTime date = (doc['date'] as Timestamp).toDate();
        weightData.add(FlSpot(index.toDouble(), weightValue));
        weightDates.add(DateFormat("dd MMM").format(date));
        index++;
      }
      // Preprocess weightDates to ensure uniqueness
      List<String> uniqueWeightDates = [];
      for (int i = 0; i < weightDates.length; i++) {
        if (i == 0 || weightDates[i] != weightDates[i - 1]) {
          uniqueWeightDates.add(weightDates[i]);
        }
      }
      weightDates = uniqueWeightDates;
    });
  }

  double? _calculateBMI() {
    if (weight != null && height != null && height! > 0) {
      return weight! / ((height! / 100) * (height! / 100));
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    double? bmi = _calculateBMI();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Activity",
          style: TextStyle(color: Colors.orange),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Current Weight: ${weight?.toStringAsFixed(1) ?? "--"} kg",
                style: TextStyle(fontSize: 18)),
            Text("Height: ${height?.toStringAsFixed(1) ?? "--"} cm",
                style: TextStyle(fontSize: 18)),
            Text("BMI: ${bmi != null ? bmi.toStringAsFixed(2) : "--"}",
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Expanded(
              child: weightData.isNotEmpty
                  ? Container(
                      height: 300,
                      child: LineChart(
                        LineChartData(
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    value.toStringAsFixed(0),
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                  );
                                },
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  int index = value.toInt();
                                  if (index >= 0 &&
                                      index < weightDates.length) {
                                    // Only show unique dates
                                    if (index == 0 ||
                                        (index > 0 &&
                                            weightDates[index] !=
                                                weightDates[index - 1])) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          weightDates[index],
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 12),
                                        ),
                                      );
                                    }
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                            ),
                          ),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: 2,
                            getDrawingHorizontalLine: (value) => FlLine(
                              color: Colors.grey.shade800,
                              strokeWidth: 0.5,
                            ),
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(
                                color: Colors.grey.shade800, width: 1),
                          ),
                          lineBarsData: [
                            LineChartBarData(
                              spots: weightData,
                              isCurved: false,
                              color: Colors.blue,
                              barWidth: 2,
                              belowBarData: BarAreaData(show: false),
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, barData, index) {
                                  return FlDotCirclePainter(
                                    radius: 4,
                                    color: Colors.blue,
                                    strokeWidth: 2,
                                    strokeColor: Colors.white,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ))
                  : Center(child: Text("No weight data available")),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _showAddMeasurementDialog(),
              child: Text("Add Measurement"),
            )
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1, // Update based on your navigation index
        currentRoute: 'BodyMeasurements',
        userId: widget.userId,
      ),
    );
  }

  void _showAddMeasurementDialog() {
    TextEditingController weightController = TextEditingController();
    TextEditingController heightController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Measurement"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: weightController,
                  decoration: InputDecoration(labelText: "Weight (kg)"),
                  keyboardType: TextInputType.number),
              TextField(
                  controller: heightController,
                  decoration: InputDecoration(labelText: "Height (cm)"),
                  keyboardType: TextInputType.number),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context), child: Text("Cancel")),
            ElevatedButton(
              onPressed: () {
                double? newWeight = double.tryParse(weightController.text);
                double? newHeight = double.tryParse(heightController.text);
                if (newWeight != null) {
                  _updateMeasurements(newWeight, newHeight);
                }
                Navigator.pop(context);
              },
              child: Text("Save"),
            )
          ],
        );
      },
    );
  }

  void _updateMeasurements(double newWeight, double? newHeight) async {
    await _firestore.collection('users').doc(widget.userId).update({
      'weight': newWeight,
      if (newHeight != null) 'height': newHeight,
    });
    await _firestore
        .collection('users')
        .doc(widget.userId)
        .collection('weightLogs')
        .add({
      'weight': newWeight,
      'date': Timestamp.now(),
    });
    _fetchUserData();
  }
}
