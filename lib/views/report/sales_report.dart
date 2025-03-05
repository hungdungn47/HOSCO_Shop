import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hosco_shop_2/networking/data/fake_transactions.dart';
import 'package:hosco_shop_2/utils/navigation_drawer.dart';
import 'package:hosco_shop_2/views/common_widgets/line_chart.dart';
import 'package:hosco_shop_2/views/common_widgets/pie_chart.dart';
import 'package:intl/intl.dart';

import '../../models/transaction.dart';

class SalesReport extends StatefulWidget {
  SalesReport({super.key});

  @override
  State<SalesReport> createState() => _SalesReportState();
}

class _SalesReportState extends State<SalesReport> {
  final transactions = fakeTransactions;
  bool isWeekly = true;

  // Calculate total revenue per day
  Map<String, double> getDailyRevenue() {
    Map<String, double> revenue = {};
    for (var transaction in transactions) {
      String dateKey = "${transaction.date.year}-${transaction.date.month}-${transaction.date.day}";
      revenue[dateKey] = (revenue[dateKey] ?? 0) + transaction.totalAmount;
    }
    return revenue;
  }

  Map<String, double> calculateWeeklyRevenue() {
    Map<String, double> weeklyRevenue = {};

    for (var transaction in transactions) {
      DateTime date = transaction.date;
      String weekKey = "${date.year}-W${(date.day / 7).ceil()}"; // Example: "2024-W5"

      if (!weeklyRevenue.containsKey(weekKey)) {
        weeklyRevenue[weekKey] = 0.0;
      }
      weeklyRevenue[weekKey] = (weeklyRevenue[weekKey]! + transaction.totalAmount);
    }

    return weeklyRevenue;
  }


  Map<String, double> calculateLast8WeeksRevenue() {
    Map<String, double> weeklyRevenue = {};
    DateTime now = DateTime.now();
    DateTime eightWeeksAgo = now.subtract(Duration(days: 56));

    for (var transaction in transactions) {
      if (transaction.date.isAfter(eightWeeksAgo)) {
        String weekNumber = DateFormat('w').format(transaction.date); // Week as string
        String year = DateFormat('y').format(transaction.date); // Year as string

        String weekKey = "$year-W$weekNumber"; // Example: "2024-W05"

        weeklyRevenue[weekKey] = (weeklyRevenue[weekKey] ?? 0) + transaction.totalAmount;
      }
    }

    return weeklyRevenue;
  }

  Map<String, double> getLastWeekRevenue(List<CustomTransaction> transactions) {
    Map<String, double> revenue = {};

    DateTime now = DateTime.now();
    DateTime oneWeekAgo = now.subtract(Duration(days: 7));

    // Generate the last 7 days starting from today (keeping the same order)
    List<String> lastWeekDays = List.generate(7,
            (i) => DateFormat('E').format(now.subtract(Duration(days: i)))
    ).reversed.toList(); // Reverse to maintain correct order

    // Initialize all days with 0 revenue
    for (var day in lastWeekDays) {
      revenue[day] = 0.0;
    }

    // Sum transaction amounts for each day
    for (var transaction in transactions) {
      if (transaction.date.isAfter(oneWeekAgo)) {
        String dateKey = DateFormat('E').format(transaction.date);
        if (revenue.containsKey(dateKey)) {
          revenue[dateKey] = (revenue[dateKey] ?? 0) + transaction.totalAmount;
        }
      }
    }

    return revenue;
  }

  // Calculate revenue distribution by payment method
  Map<String, double> getPaymentDistribution() {
    Map<String, double> paymentDistribution = {"Cash": 0, "Card": 0};
    for (var transaction in transactions) {
      paymentDistribution[transaction.paymentMethod] =
          (paymentDistribution[transaction.paymentMethod] ?? 0) + transaction.totalAmount;
    }
    return paymentDistribution;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: MyNavigationDrawer(),
      appBar: AppBar(
        title: Text("Báo cáo kinh doanh")
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text("Doanh thu", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            SizedBox(height: 200, child: LineChartBuilder(chartData: getLastWeekRevenue(transactions))),

            SizedBox(height: 40),
            Text("Phương thức thanh toán", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: PieChartBuilder(chartData: getPaymentDistribution())
            ),
          ],
        ),
      ),
    );
  }


}
