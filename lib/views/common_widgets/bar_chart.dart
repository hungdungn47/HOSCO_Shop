import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartBuilder extends StatelessWidget {
  BarChartBuilder({super.key, required this.chartData});
  final Map<String, double> chartData;
  @override
  Widget build(BuildContext context) {
    return buildBarChart(chartData);
  }

  Widget buildBarChart(Map<String, double> data) {
    List<BarChartGroupData> barGroups = [];
    int index = 0;
    for (var entry in data.entries) {
      barGroups.add(
        BarChartGroupData(
          x: index,
          barRods: [BarChartRodData(toY: entry.value, color: Colors.blue, width: 14)],
        ),
      );
      index++;
    }

    return BarChart(
      curve: Curves.bounceIn,
      BarChartData(
        gridData: FlGridData(
          show: false,
        ),
        barGroups: barGroups,
        borderData: FlBorderData(
            show: false
        ),
        titlesData: FlTitlesData(
          topTitles: AxisTitles(
              sideTitles: SideTitles(
                  showTitles: false
              )
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(data.keys.toList()[value.toInt()], style: TextStyle(fontSize: 10));
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
              // interval: 30, // Label interval (100, 200, 300...)
            ),
          ),
          rightTitles: AxisTitles(
              sideTitles: SideTitles(
                  showTitles: false
              )
          ),
        ),
      ),
    );
  }
}
