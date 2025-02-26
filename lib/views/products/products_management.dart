import 'package:flutter/material.dart';
import 'package:hosco_shop_2/utils/navigation_drawer.dart';
import 'package:hosco_shop_2/views/common_widgets/item_card.dart';

class ProductsManagement extends StatelessWidget {
  const ProductsManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyNavigationDrawer(),
      appBar: AppBar(
        title: Text('Quản lý sản phẩm'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: 12,
          itemBuilder: (context, index) {
            return ItemCard(imageUrl: 'assets/product_images/iphone_15_pro.png', name: 'Iphone 15', price: 16000000, quantity: 20);
          }
        ),
      ),
    );
  }
}
