import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/add-product');
        },
        backgroundColor: Color(0xff2F98F5),
        shape: CircleBorder(), // Custom FAB color
        child: Icon(
          Icons.add, // Plus icon
          size: 30, // Big icon size
          color: Colors.white, // White color for the icon
        ),
      ),
    );
  }
}
