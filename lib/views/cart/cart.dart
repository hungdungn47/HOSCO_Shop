import 'package:flutter/material.dart';
import 'package:hosco_shop_2/utils/navigation_drawer.dart';

class Cart extends StatelessWidget {
  const Cart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyNavigationDrawer(),
      appBar: AppBar(
        title: Text('Đơn hàng mới'),
      ),
    );
  }
}
