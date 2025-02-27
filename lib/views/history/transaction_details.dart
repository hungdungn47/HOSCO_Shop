import 'package:flutter/material.dart';
import 'package:hosco_shop_2/models/transaction.dart';

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
            Text("Ngày: ${transaction.date.toLocal()}",
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text("Danh sách sản phẩm:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: transaction.items.length,
                itemBuilder: (context, index) {
                  final item = transaction.items[index];
                  return ListTile(
                    title: Text(item.product.name, style: TextStyle(fontSize: 16)),
                    subtitle: Text("Số lượng: ${item.quantity}"),
                    trailing: Text("${(item.product.price * item.quantity).toStringAsFixed(2)} đ"),
                  );
                },
              ),
            ),
            Divider(),
            Text(
              "Tổng tiền: ${transaction.totalAmount.toStringAsFixed(2)} đ",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(),
    );
  }
}
