import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hosco_shop_2/models/product.dart';
import 'package:hosco_shop_2/networking/data/fakeProducts.dart';
import 'package:hosco_shop_2/utils/navigation_drawer.dart';
import 'package:hosco_shop_2/views/common_widgets/item_card.dart';
import 'package:hosco_shop_2/views/products/product_details.dart';

class ProductsManagement extends StatefulWidget {
  const ProductsManagement({super.key});

  @override
  State<ProductsManagement> createState() => _ProductsManagementState();
}

class _ProductsManagementState extends State<ProductsManagement> {
  void _updateProduct(Product updatedProduct) {
    setState(() {
      int index = mockProducts.indexWhere((p) => p.id == updatedProduct.id);
      if (index != -1) {
        mockProducts[index] = updatedProduct;
      }
    });
  }

  void _deleteProduct(String productId) {
    setState(() {
      mockProducts.removeWhere((p) => p.id == productId);
    });
  }
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
          itemCount: mockProducts.length,
          itemBuilder: (context, index) {
            final Product product = mockProducts[index];
            return GestureDetector(
              onTap: () {
                Get.to(() => ProductDetailScreen(product: product, onUpdate: _updateProduct,
                  onDelete: _deleteProduct,));
              },
              child: ItemCard(product: product)
            );
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
