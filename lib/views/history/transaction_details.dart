import 'package:flutter/material.dart';
import 'package:hosco_shop_2/models/transaction.dart';
import 'package:hosco_shop_2/utils/constants.dart';
import 'package:intl/intl.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final Transaction transaction;

  const TransactionDetailsScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chi tiết giao dịch')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Mã giao dịch: ${transaction.id}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Thời gian:", style: TextStyle(fontSize: 16)),
                Text(DateFormat('dd/MM/yyyy HH:mm:ss').format(transaction.date), style: TextStyle(fontSize: 16))
              ],
            ),
            SizedBox(height: 16),
            Text("Danh sách sản phẩm:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: transaction.items.length,
                itemBuilder: (context, index) {
                  final item = transaction.items[index];
                  // return ListTile(
                  //   title: Text(item.product.name, style: TextStyle(fontSize: 16)),
                  //   subtitle: Text("Số lượng: ${item.quantity}"),
                  //   trailing: Text("${(item.product.price * item.quantity).toStringAsFixed(2)} đ"),
                  // );
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.product.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),),
                          Text("Số lượng: ${item.quantity}", style: TextStyle(fontSize: 16)),
                          Text("Đơn giá: ${NumberFormat.decimalPattern().format(item.product.price)}", style: TextStyle(fontSize: 16))
                        ],
                      ),
                      Text(NumberFormat.decimalPattern().format(item.product.price * item.quantity), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor),)
                    ],
                  );
                },
              ),
            ),
            Divider(),
            Text(
              "Tổng tiền: ${NumberFormat.decimalPattern().format(transaction.totalAmount)} đ",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomAppBar(),
    );
  }
}
