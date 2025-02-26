import 'package:flutter/material.dart';
import 'package:hosco_shop_2/utils/navigation_drawer.dart';

class TransactionHistory extends StatelessWidget {
  const TransactionHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyNavigationDrawer(),
      appBar: AppBar(
        title: Text('Lịch sử giao dịch'),
      ),
    );
  }
}
