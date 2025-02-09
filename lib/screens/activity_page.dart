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
    // Agora, buscar os registos de peso apenas depois de os dados do utilizador serem carregados
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
      Map<double, String> xToDate = {}; // Armazenar mapeamento de x -> Data
      double xValue =
          0.0; // Começar do 0 e incrementar para garantir posições únicas

      for (var doc in logs.docs) {
        double weightValue = (doc['weight'] as num).toDouble();
        DateTime date = (doc['date'] as Timestamp).toDate();
        String formattedDate = DateFormat("dd MMM").format(date);

        // Armazenar a data para cada valor de x
        xToDate[xValue] = formattedDate;

        weightData.add(FlSpot(xValue, weightValue));
        xValue += 1.0; // Incrementar valor de x para o próximo ponto de dados
      }

      weightDates = xToDate.values
          .toList(); // Garantir que os rótulos alinhem com os valores de X
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

    // Determinar os valores mínimos e máximos do eixo Y com base nos dados
    double minY, maxY;
    if (weightData.isNotEmpty) {
      if (weightData.length == 1) {
        // Um único ponto de dados: centralizar no gráfico
        double weightValue = weightData.first.y;
        minY = weightValue - 10; // Espaço de 10kg abaixo
        maxY = weightValue + 10; // Espaço de 10kg acima
      } else {
        // Múltiplos pontos de dados: calcular com base nos dados
        double minWeight =
            weightData.map((spot) => spot.y).reduce((a, b) => a < b ? a : b);
        double maxWeight =
            weightData.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
        minY = minWeight - 10;
        maxY = maxWeight + 10;
      }
    } else {
      minY = 0;
      maxY = 100;
    }

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
                                  // Exibir títulos apenas para múltiplos de 5
                                  if (value % 5 == 0) {
                                    return Text(
                                      value.toStringAsFixed(0),
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                    );
                                  }
                                  return const SizedBox
                                      .shrink(); // Esconder títulos para outros valores
                                },
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 22,
                                getTitlesWidget: (value, meta) {
                                  // Exibir a data correta para cada valor de x
                                  int index = value.toInt();
                                  if (index >= 0 &&
                                      index < weightDates.length) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        weightDates[
                                            index], // Mapear índice para data
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                      ),
                                    );
                                  }
                                  return const SizedBox
                                      .shrink(); // Esconder para valores de x inválidos
                                },
                              ),
                            ),
                            rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                          ),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval:
                                5, // Intervalo de 5 na linha horizontal
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
                              color: Colors.orange,
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
                          minY: minY,
                          maxY: maxY,
                        ),
                      ),
                    )
                  : const Center(child: Text("No weight data available")),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _showAddMeasurementDialog(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              child: const Text(
                'Add Measurement',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1,
        currentRoute: 'BodyMeasurements',
        userId: widget.userId,
      ),
    );
  }

  void _showAddMeasurementDialog() {
    final theme = Theme.of(context);
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
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel",
                    style: TextStyle(color: theme.primaryColor))),
            ElevatedButton(
              onPressed: () {
                double? newWeight = double.tryParse(weightController.text);
                double? newHeight = double.tryParse(heightController.text);
                if (newWeight != null) {
                  _updateMeasurements(newWeight, newHeight);
                }
                Navigator.pop(context);
              },
              child: Text("Save", style: TextStyle(color: Colors.orange)),
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
