import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hosco_shop_2/controllers/sales_report_controller.dart';
import 'package:hosco_shop_2/utils/constants.dart';

class BarChartBuilder extends StatelessWidget {
  BarChartBuilder({super.key, required this.chartData, this.interval = 1});
  final Map<String, double> chartData;
  late int interval;
  final SalesReportController salesReportController = Get.find<SalesReportController>();
  @override
  Widget build(BuildContext context) {
    switch(salesReportController.timeRange.value) {
      case TimeRange.thisMonth:
        interval = 4;
        break;
      case TimeRange.today:
        interval = 2;
        break;
      case TimeRange.lastHour:
        interval = 6;
        break;
      default:
        break;
    }
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
        // backgroundColor: Color(0xff273b4a),
        gridData: FlGridData(
            getDrawingHorizontalLine: (value) {
              return FlLine(
                  color: Colors.grey,
                  strokeWidth: 0.5
              );
            },
            getDrawingVerticalLine: (value) {
              return FlLine(
                  color: Colors.grey,
                  strokeWidth: 0.5
              );
            }
        ),
        barGroups: barGroups,
        borderData: FlBorderData(
            show: true,
            border: Border(left: BorderSide(width: 1), bottom: BorderSide(width: 1))
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
              // interval: 5,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();

                if (index % interval == 0 && index >= 0 && index < data.keys.length) {
                  return Text(data.keys.elementAt(index), style: TextStyle(fontSize: 10));
                } else {
                  return SizedBox.shrink(); // Hide labels for non-matching indexes
                }
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 45,
              maxIncluded: false
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
