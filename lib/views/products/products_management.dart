import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hosco_shop_2/controllers/product_controller.dart';
import 'package:hosco_shop_2/models/product.dart';
import 'package:hosco_shop_2/networking/data/fakeProducts.dart';
import 'package:hosco_shop_2/utils/navigation_drawer.dart';
import 'package:hosco_shop_2/views/common_widgets/item_card.dart';
import 'package:hosco_shop_2/views/products/product_details.dart';

class ProductsManagement extends StatelessWidget {
  ProductsManagement({super.key});
  final ProductController productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyNavigationDrawer(),
      appBar: AppBar(
        title: Text('Quản lý sản phẩm'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextField(
                  onChanged: productController.searchProduct,
                  decoration: InputDecoration(
                    hintText: "Tìm kiếm sản phẩm...",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),

                // 🔹 Show search suggestions
                Obx(() => productController.searchSuggestions.isEmpty
                    ? SizedBox.shrink()
                    : Container(
                  margin: EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: productController.searchSuggestions
                        .map((suggestion) => ListTile(
                      title: Text(suggestion),
                      onTap: () => productController.selectSuggestion(suggestion),
                    ))
                        .toList(),
                  ),
                )),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              List<Product> products = productController.filteredProducts;
              if (products.isEmpty) {
                return Center(child: Text('Không tìm thấy sản phẩm phù hợp'));
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
                child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final Product product = products[index];
                      return GestureDetector(
                          onTap: () {
                            productController.setSelectedProduct(product);
                            Get.to(() => ProductDetailScreen());
                          },
                          child: ItemCard(product: product)
                      );
                    }
                ),
              );
            }),
          ),
        ],
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
