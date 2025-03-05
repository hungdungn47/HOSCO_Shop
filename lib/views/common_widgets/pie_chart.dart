import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PieChartBuilder extends StatelessWidget {
  PieChartBuilder({super.key, required this.chartData});
  final Map<String, double> chartData;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: buildPieChart(chartData)),
        IndicatorsWidget()
      ],
    );
  }

  Widget buildPieChart(Map<String, double> data) {
    List<PieChartSectionData> sections = [];
    data.forEach((key, value) {
      sections.add(
        PieChartSectionData(
          value: value,
          titleStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
          title: NumberFormat.decimalPattern().format(value),
          color: key == "cash" ? Color(0xff02d39a) : Color(0xff23b6e6),
          radius: 100,
        ),
      );
    });

    return PieChart(

      PieChartData(
          sections: sections,
          centerSpaceRadius: 0,
          sectionsSpace: 0
      ),
    );
  }
}

class IndicatorsWidget extends StatelessWidget {
  const IndicatorsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      // width: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xff02d39a)
                ),
              ),
              const SizedBox(width: 10),
              Text('Tiền mặt')
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xff23b6e6)
                ),
              ),
              const SizedBox(width: 10),
              Text('Chuyển khoản')
            ],
          ),
        ],
      ),
    );
  }
}

