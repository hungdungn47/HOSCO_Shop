import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hosco_shop_2/controllers/sales_report_controller.dart';
import 'package:get/get.dart';

class LineChartBuilder extends StatelessWidget {
  LineChartBuilder({super.key, required this.chartData});

  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a)
  ];

  final SalesReportController salesReportController = Get.find<SalesReportController>();

  final Map<String, double> chartData;

  @override
  Widget build(BuildContext context) {
    return buildLineChart(chartData);
  }

  Widget buildLineChart(Map<String, double> data) {
    List<FlSpot> spots = [];
    int index = 0;
    for (var entry in data.entries) {
      spots.add(FlSpot(index.toDouble(), entry.value));
      index++;
    }

    return LineChart(
      LineChartData(
        backgroundColor: Color(0xff273b4a),
        lineBarsData: [
          LineChartBarData(
            barWidth: 5,
            belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(colors: gradientColors.map((c) => c.withOpacity(0.3)).toList())
            ),
            spots: spots,
            color: Color(0xff23b6e6),
            gradient: LinearGradient(colors: gradientColors),
            isCurved: true,
            dotData: FlDotData(show: false),
          ),
        ],
        borderData: FlBorderData(
          show: true,
        ),
        gridData: FlGridData(
            getDrawingHorizontalLine: (value) {
              return FlLine(
                  color: const Color(0xff6e9dc6),
                  strokeWidth: 0.5
              );
            },
            getDrawingVerticalLine: (value) {
              return FlLine(
                  color: const Color(0xff6e9dc6),
                  strokeWidth: 0.5
              );
            }
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
              interval: salesReportController.timeUnit.value == "Tuần này" ? 1 : 5,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index < 0 || index >= data.keys.length) {
                  return SizedBox.shrink(); // Avoid out-of-bounds errors
                }
                return Text(data.keys.elementAt(index), style: TextStyle(fontSize: 10));
              },
            ),
          ),
          leftTitles: AxisTitles(),
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
