import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hosco_shop_2/controllers/sales_report_controller.dart';
import 'package:hosco_shop_2/networking/data/fake_transactions.dart';
import 'package:hosco_shop_2/utils/constants.dart';
import 'package:hosco_shop_2/utils/navigation_drawer.dart';
import 'package:hosco_shop_2/views/common_widgets/bar_chart.dart';
import 'package:hosco_shop_2/views/common_widgets/best_selling_item_card.dart';
import 'package:hosco_shop_2/views/common_widgets/line_chart.dart';
import 'package:hosco_shop_2/views/common_widgets/pie_chart.dart';
import 'package:hosco_shop_2/views/report/best_selling_products_table.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import '../../models/transaction.dart';

class SalesReport extends StatelessWidget {
  SalesReport({super.key});
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Doanh thu", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(
                    width: 130,
                    child: DropdownButtonFormField<TimeRange>(
                      value: salesReportController.timeRange.value,
                      onChanged: (value) => salesReportController.timeRange.value = value ?? TimeRange.thisWeek ,
                      items: timeRangeLabels.entries.map((entry) {
                        return DropdownMenuItem(
                          value: entry.key,
                          child: Text(entry.value),
                        );
                      }).toList(),
                      // decoration: InputDecoration(labelText: "Chọn nhà cung cấp"),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: Obx(() => BarChartBuilder(
                    chartData: salesReportController.getRevenueData()
                ))
              ),
          
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Tổng doanh thu:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Obx(() => Text(
                      '${NumberFormat.decimalPattern().format(salesReportController.getTotalRevenue())} đ',
                      style: TextStyle(
                          fontSize: 18,
                          color: primaryColor,
                          fontWeight: FontWeight.bold
                      )
                  ))
                ],
              ),
              SizedBox(height: 20),
              Text("Phương thức thanh toán", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: Obx(() => PieChartBuilder(chartData: salesReportController.getPaymentDistribution()))
              ),
              SizedBox(height: 20),
              Text("Sản phẩm bán chạy", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              // Obx(() {
              //   return Column(
              //     children: salesReportController.bestSellingProducts.map((product) {
              //       return ListTile(
              //         leading: Image.network(product['imageUrl'], width: 50, height: 50, fit: BoxFit.cover),
              //         title: Text(product['name']),
              //         subtitle: RichText(
              //           text: TextSpan(
              //             children: [
              //               TextSpan(text: "Đã bán: ", style: TextStyle(color: Colors.black, fontSize: 15)),
              //               TextSpan(
              //                 text: "${product['totalSold']}",
              //                 style: TextStyle(color: primaryColor, fontSize: 18, fontWeight: FontWeight.bold),
              //               ),
              //             ],
              //           ),
              //         ),
              //         trailing: Text("${NumberFormat.decimalPattern().format(product['price'])} đ",
              //               style: TextStyle(
              //                 fontSize: 15,
              //                 color: primaryColor
              //               ),
              //             ),
              //       );
              //     }).toList(),
              //   );
              // }),
              Obx(() {
                return Column(
                  children: salesReportController.bestSellingProducts.map((product) {
                    return BestSellingItemCard(product: product);
                  }).toList(),
                );
              }),
              Center(child: BestSellingProductsTable(products: salesReportController.bestSellingProducts))
            ],
          ),
        ),
      ),
    );
  }
}
