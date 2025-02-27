import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hosco_shop_2/controllers/cart_controller.dart';
import 'package:hosco_shop_2/models/transaction.dart';
import 'package:hosco_shop_2/utils/navigation_drawer.dart';
import 'package:hosco_shop_2/views/history/transaction_details.dart';

class TransactionHistoryScreen extends StatelessWidget {
  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lịch sử giao dịch')),
      drawer: MyNavigationDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (cartController.transactions.isEmpty) {
            return Center(child: Text('Chưa có giao dịch nào!'));
          }

          return ListView.builder(
            itemCount: cartController.transactions.length,
            itemBuilder: (context, index) {
              Transaction transaction = cartController.transactions[index];

              return Card(
                child: ListTile(
                  onTap: () {
                    Get.to(TransactionDetailsScreen(transaction: transaction,));
                  },
                  title: Text("Giao dịch ${transaction.id}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Ngày: ${transaction.date.toLocal()}"),
                      Text("Tổng tiền: ${transaction.totalAmount.toStringAsFixed(2)} đ"),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
