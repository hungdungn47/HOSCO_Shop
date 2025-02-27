import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hosco_shop_2/controllers/cart_controller.dart';
import 'package:hosco_shop_2/models/transaction.dart';
import 'package:hosco_shop_2/utils/constants.dart';
import 'package:hosco_shop_2/utils/navigation_drawer.dart';
import 'package:hosco_shop_2/views/history/transaction_details.dart';

class TransactionHistoryScreen extends StatelessWidget {
  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lịch sử giao dịch')),
      drawer: MyNavigationDrawer(),
      body: Container(
        margin: const EdgeInsets.all(16),
        child: Obx(() {
          if (cartController.transactions.isEmpty) {
            return Center(child: Text('Chưa có giao dịch nào!'));
          }

          return ListView.builder(
            itemCount: cartController.transactions.length,
            itemBuilder: (context, index) {
              Transaction transaction = cartController.transactions[index];

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  boxShadow: [
                    BoxShadow(
                        color: primaryColor,
                        blurRadius: 3,
                        spreadRadius: 1
                    )
                  ]
              ),
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
