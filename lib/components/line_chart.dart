import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MyLineChart extends StatelessWidget {
  final List<FlSpot> dataPoints;
  final Color lineColor;

  const MyLineChart({
    super.key,
    required this.dataPoints,
    this.lineColor = Colors.blue, // Default color 
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false), // Hides background grid
          titlesData: FlTitlesData(
            // Hides titles on the top and right
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false), // Hides the chart border
          lineBarsData: [
            LineChartBarData(
              spots: dataPoints, // Uses the data passed from the main page
              isCurved: true,
              color: lineColor,
              barWidth: 4,
              dotData: FlDotData(show: true), // Shows a dot at each data point
            ),
          ],
        ),
      ),
    );
  }
}