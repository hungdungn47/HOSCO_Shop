import 'package:get/get.dart';
import 'package:hosco_shop_2/models/transaction.dart';
import 'package:hosco_shop_2/services/local_db_service.dart';
import 'package:hosco_shop_2/utils/constants.dart';
import 'package:intl/intl.dart';

class SalesReportController extends GetxController {
  var timeRange = TimeRange.thisWeek.obs;
  var transactions = <CustomTransaction>[].obs;
  var bestSellingProducts = <Map<String, dynamic>>[].obs;
  final DatabaseService databaseService = DatabaseService.instance;

  @override
  void onInit() {
    databaseService.getTransactions().then((res) => transactions.assignAll(res));
    loadBestSellingProducts();
    super.onInit();
  }

  Map<String, double> getRevenueData() {
    switch(timeRange.value) {
      case TimeRange.lastHour:
        return getLastHourRevenue();
      case TimeRange.today:
        return getTodayRevenue();
      case TimeRange.thisWeek:
        return getLastWeekRevenue();
      case TimeRange.thisMonth:
        return getLastMonthRevenue();
      }
  }

  Map<String, double> getRevenue(Duration interval, String format) {
    Map<String, double> revenue = {};

    DateTime now = DateTime.now();
    DateTime pastTime = now.subtract(interval);

    // Generate time labels based on the interval
    List<String> timeLabels = List.generate(
      interval.inHours > 1 ? interval.inHours : interval.inMinutes,
          (i) => DateFormat(format).format(now.subtract(
          interval.inHours > 1 ? Duration(hours: i) : Duration(minutes: i))),
    ).reversed.toList(); // Reverse to maintain order

    // Initialize with 0 revenue
    for (var label in timeLabels) {
      revenue[label] = 0.0;
    }

    // Sum transaction amounts
    for (var transaction in transactions) {
      if (transaction.date.isAfter(pastTime)) {
        String dateKey = DateFormat(format).format(transaction.date);
        if (revenue.containsKey(dateKey)) {
          revenue[dateKey] = (revenue[dateKey] ?? 0) + transaction.totalAmount;
        }
      }
    }

    return revenue;
  }
  Map<String, double> getLastWeekRevenue() => getRevenue(Duration(days: 7), 'dd/MM');
  Map<String, double> getTodayRevenue() => getRevenue(Duration(hours: 24), 'HH\'h\'');
  Map<String, double> getLastHourRevenue() => getRevenue(Duration(hours: 1), 'HH:mm');
  Map<String, double> getLastMonthRevenue() => getRevenue(Duration(days: 30), 'dd/MM');

  // Calculate revenue distribution by payment method
  Map<String, double> getPaymentDistribution() {
    Map<String, double> paymentDistribution = {"bank-transfer": 0, "cash": 0};
    for (var transaction in transactions) {
      paymentDistribution[transaction.paymentMethod] =
          (paymentDistribution[transaction.paymentMethod] ?? 0) + transaction.totalAmount;
    }
    return paymentDistribution;
  }

  double getTotalRevenue() {
    DateTime now = DateTime.now();
    DateTime startTime;

    switch (timeRange.value) {
      case TimeRange.lastHour:
        startTime = now.subtract(Duration(hours: 1));
        break;
      case TimeRange.today:
        startTime = DateTime(now.year, now.month, now.day); // Start of today
        break;
      case TimeRange.thisWeek:
        startTime = now.subtract(Duration(days: now.weekday - 1)); // Start of the week (Monday)
        startTime = DateTime(startTime.year, startTime.month, startTime.day);
        break;
      case TimeRange.thisMonth:
        startTime = DateTime(now.year, now.month, 1); // Start of the month
        break;
    }

    // Sum totalAmount of transactions within the selected time range
    return transactions
        .where((transaction) => transaction.date.isAfter(startTime))
        .fold(0.0, (sum, transaction) => sum + transaction.totalAmount);
  }
  void loadBestSellingProducts() async {
    final products = await databaseService.getBestSellingProducts();
    bestSellingProducts.assignAll(products);
  }
}