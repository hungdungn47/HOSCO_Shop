import 'package:get/get.dart';
import 'package:hosco_shop_2/models/transaction.dart';
import 'package:intl/intl.dart';

class SalesReportController extends GetxController {
  var timeUnit = "Tuần này".obs;

  // Map<String, double> calculateWeeklyRevenue(List<CustomTransaction> transactions) {
  //   Map<String, double> weeklyRevenue = {};
  //
  //   for (var transaction in transactions) {
  //     DateTime date = transaction.date;
  //     String weekKey = "${date.year}-W${(date.day / 7).ceil()}"; // Example: "2024-W5"
  //
  //     if (!weeklyRevenue.containsKey(weekKey)) {
  //       weeklyRevenue[weekKey] = 0.0;
  //     }
  //     weeklyRevenue[weekKey] = (weeklyRevenue[weekKey]! + transaction.totalAmount);
  //   }
  //
  //   return weeklyRevenue;
  // }

  Map<String, double> getRevenueData(List<CustomTransaction> transactions) {
    switch(timeUnit.value) {
      case "Tuần này":
        return getLastWeekRevenue(transactions);
        break;
      case "Tháng này":
        return getLastMonthRevenue(transactions);
        break;
      case "Tháng":
        return getLastWeekRevenue(transactions);
        break;
      default:
        return getLastWeekRevenue(transactions);
        break;
    }
  }

  // Map<String, double> calculateLast8WeeksRevenue(List<CustomTransaction> transactions) {
  //   Map<String, double> weeklyRevenue = {};
  //   DateTime now = DateTime.now();
  //   DateTime eightWeeksAgo = now.subtract(Duration(days: 56));
  //
  //   for (var transaction in transactions) {
  //     if (transaction.date.isAfter(eightWeeksAgo)) {
  //       // String weekNumber = DateFormat('w').format(transaction.date); // Week as string
  //       // String year = DateFormat('y').format(transaction.date); // Year as string
  //
  //       String weekKey = "hehe"; // Example: "2024-W05"
  //
  //       weeklyRevenue[weekKey] = (weeklyRevenue[weekKey] ?? 0) + transaction.totalAmount;
  //     }
  //   }
  //
  //   return weeklyRevenue;
  // }

  Map<String, double> getLastWeekRevenue(List<CustomTransaction> transactions) {
    Map<String, double> revenue = {};

    DateTime now = DateTime.now();
    DateTime oneWeekAgo = now.subtract(Duration(days: 7));

    // Generate the last 7 days starting from today (keeping the same order)
    List<String> lastWeekDays = List.generate(7,
            (i) => DateFormat('dd/MM').format(now.subtract(Duration(days: i)))
    ).reversed.toList(); // Reverse to maintain correct order

    // Initialize all days with 0 revenue
    for (var day in lastWeekDays) {
      revenue[day] = 0.0;
    }



    // Sum transaction amounts for each day
    for (var transaction in transactions) {
      if (transaction.date.isAfter(oneWeekAgo)) {
        String dateKey = DateFormat('dd/MM').format(transaction.date);
        if (revenue.containsKey(dateKey)) {
          revenue[dateKey] = (revenue[dateKey] ?? 0) + transaction.totalAmount;
        }
      }
    }

    return revenue;
  }

  Map<String, double> getLastMonthRevenue(List<CustomTransaction> transactions) {
    Map<String, double> revenue = {};

    DateTime now = DateTime.now();
    DateTime oneWeekAgo = now.subtract(Duration(days: 30));

    // Generate the last 7 days starting from today (keeping the same order)
    List<String> lastWeekDays = List.generate(30,
            (i) => DateFormat('dd/MM').format(now.subtract(Duration(days: i)))
    ).reversed.toList(); // Reverse to maintain correct order

    // Initialize all days with 0 revenue
    for (var day in lastWeekDays) {
      revenue[day] = 0.0;
    }


    revenue.keys.forEach((key) => print('$key : ${revenue[key]}'));
    // Sum transaction amounts for each day
    for (var transaction in transactions) {
      if (transaction.date.isAfter(oneWeekAgo)) {
        String dateKey = DateFormat('dd/MM').format(transaction.date);
        if (revenue.containsKey(dateKey)) {
          revenue[dateKey] = (revenue[dateKey] ?? 0) + transaction.totalAmount;
        }
      }
    }

    // revenue.keys.forEach((key) => print('$key : ${revenue[key]}'));

    return revenue;
  }

  // Calculate revenue distribution by payment method
  Map<String, double> getPaymentDistribution(List<CustomTransaction> transactions) {
    Map<String, double> paymentDistribution = {"Cash": 0, "Card": 0};
    for (var transaction in transactions) {
      paymentDistribution[transaction.paymentMethod] =
          (paymentDistribution[transaction.paymentMethod] ?? 0) + transaction.totalAmount;
    }
    return paymentDistribution;
  }
}