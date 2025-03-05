import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hosco_shop_2/controllers/sales_report_controller.dart';
import 'package:hosco_shop_2/networking/data/fake_transactions.dart';
import 'package:hosco_shop_2/utils/navigation_drawer.dart';
import 'package:hosco_shop_2/views/common_widgets/line_chart.dart';
import 'package:hosco_shop_2/views/common_widgets/pie_chart.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import '../../models/transaction.dart';

class SalesReport extends StatelessWidget {
  SalesReport({super.key});

  final transactions = fakeTransactions;
  final SalesReportController salesReportController = Get.put(SalesReportController());

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

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Doanh thu", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(
                  width: 130,
                  child: DropdownButtonFormField<String>(
                    value: salesReportController.timeUnit.value,
                    onChanged: (value) => salesReportController.timeUnit.value = value ?? "Ngày" ,
                    items: ["Tuần này", "Tháng này"].map((supplier) {
                      return DropdownMenuItem(value: supplier, child: Text(supplier));
                    }).toList(),
                    // decoration: InputDecoration(labelText: "Chọn nhà cung cấp"),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 200, 
              child: Obx(() => LineChartBuilder(
                  chartData: salesReportController.getRevenueData(transactions)
              ))
            ),

            SizedBox(height: 40),
            Text("Phương thức thanh toán", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: PieChartBuilder(chartData: salesReportController.getPaymentDistribution(transactions))
            ),
          ],
        ),
      ),
    );
  }
}
