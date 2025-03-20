import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hosco_shop_2/controllers/cart_controller.dart';
import 'package:hosco_shop_2/controllers/sales_report_controller.dart';
import 'package:hosco_shop_2/models/transaction.dart';
import 'package:hosco_shop_2/utils/constants.dart';
import 'package:hosco_shop_2/utils/navigation_drawer.dart';
import 'package:hosco_shop_2/views/history/transaction_details.dart';
import 'package:intl/intl.dart';

class TransactionHistoryScreen extends StatelessWidget {
  final CartController cartController = Get.find<CartController>();
  final SalesReportController salesReportController =
      Get.find<SalesReportController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lịch sử giao dịch')),
      drawer: MyNavigationDrawer(),
      body: Container(
        margin: const EdgeInsets.all(16),
        child: Obx(() {
          if (salesReportController.transactionsList.isEmpty) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/icons/empty_icon.png', height: 80),
                Text('Chưa có giao dịch nào!', style: TextStyle(fontSize: 18))
              ],
            ));
          }

          return ListView.builder(
            itemCount: salesReportController.transactionsList.length,
            itemBuilder: (context, index) {
              CustomTransaction transaction =
                  salesReportController.transactionsList[index];
              return GestureDetector(
                onTap: () =>
                    Get.to(TransactionDetailsScreen(transaction: transaction)),
                child: transactionInfoCard(transaction),
              );
            },
          );
        }),
      ),
    );
  }

  Widget transactionInfoCard(CustomTransaction transaction) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Color(0xffd9d9d9),
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(4)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Loại giao dịch',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
              ),
              Text(
                transaction.type == transactionTypeSale
                    ? "Bán hàng"
                    : "Nhập hàng",
                style: TextStyle(
                  fontSize: 18,
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Giá trị',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
              ),
              Text(
                transaction.type == transactionTypeSale
                    ? "+${NumberFormat.decimalPattern().format(transaction.totalAmount)}"
                    : "-${NumberFormat.decimalPattern().format(transaction.totalAmount)}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ngày giao dịch',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
              ),
              Text(
                DateFormat('dd/MM/yyyy').format(transaction.transactionDate!),
                style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w300),
              )
            ],
          ),
        ],
      ),
    );
  }
}
