import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hosco_shop_2/controllers/product_controller.dart';
import 'package:hosco_shop_2/models/product.dart';
import 'package:hosco_shop_2/networking/data/fakeProducts.dart';
import 'package:hosco_shop_2/utils/constants.dart';
import 'package:hosco_shop_2/utils/navigation_drawer.dart';
import 'package:hosco_shop_2/views/common_widgets/item_card.dart';
import 'package:hosco_shop_2/views/products/product_details.dart';

class ProductsManagement extends StatelessWidget {
  ProductsManagement({super.key});
  final ProductController productController = Get.find<ProductController>();
  final TextEditingController searchQueryController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyNavigationDrawer(),
      appBar: AppBar(
        title: Text('Quản lý sản phẩm'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 75),
        Container(
          margin: const EdgeInsets.only(top: 8, left: 12),
          width: double.infinity,
          height: 35,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: productTypes.length,
            itemBuilder: (context, index) {
              // Lấy biến selectedCategory từ controller
              // final selectedCategory = productController.selectedCategory.value;
              //
              // bool isSelected = selectedCategory == productTypes[index];

              return Obx(() => GestureDetector(
                onTap: () {
                  productController.addSelectedCategory(productTypes[index]); // Cập nhật trạng thái
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: productController.isSelectedCategory(productTypes[index]) ? primaryColor : Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    productTypes[index],
                    style: TextStyle(color: productController.isSelectedCategory(productTypes[index]) ? primaryColor : Colors.black),
                  ),
                ),
              )) ;
            },
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
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextField(
                  controller: searchQueryController,
                  onChanged: productController.searchProduct,
                  decoration: InputDecoration(
                    hintText: "Tìm kiếm sản phẩm...",
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: IconButton(onPressed: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      searchQueryController.clear();
                      productController.searchProduct('');
                    }, icon: Icon(Icons.clear)),
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
                      onTap: () {
                        searchQueryController.text = suggestion;
                        productController.selectSuggestion(suggestion);
                      },
                    ))
                        .toList(),
                  ),
                )),
              ],
            ),
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
