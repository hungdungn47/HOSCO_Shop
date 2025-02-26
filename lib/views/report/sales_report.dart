import 'package:flutter/material.dart';
import 'package:hosco_shop_2/utils/navigation_drawer.dart';

class SalesReport extends StatelessWidget {
  const SalesReport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyNavigationDrawer(),
      appBar: AppBar(
        title: Text('Báo cáo kinh doanh'),
      ),
    );
  }
}
