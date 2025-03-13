import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hosco_shop_2/controllers/product_controller.dart';
import 'package:hosco_shop_2/models/product.dart';
import 'package:hosco_shop_2/utils/constants.dart';
import 'package:hosco_shop_2/utils/navigation_drawer.dart';
import 'package:hosco_shop_2/views/cart/barcode_scanner.dart';
import 'package:hosco_shop_2/views/common_widgets/item_card.dart';
import 'package:hosco_shop_2/views/products/product_details.dart';

class ProductsManagement extends StatelessWidget {

  final ProductController productController = Get.find<ProductController>();
  final TextEditingController searchQueryController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  ProductsManagement({super.key}) {
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        productController.loadNextPage(); // Load more data when reaching bottom
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyNavigationDrawer(),
      appBar: AppBar(
        title: Text('Quản lý sản phẩm'),
        actions: [
          // IconButton(onPressed: () {
          //   productController.
          // }, icon: icon)
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 75),
        // Container(
        //   margin: const EdgeInsets.only(top: 8, left: 12),
        //   width: double.infinity,
        //   height: 35,
        //   child: ListView.builder(
        //     scrollDirection: Axis.horizontal,
        //     itemCount: productController.allCategories?.length,
        //     itemBuilder: (context, index) {
        //       // Lấy biến selectedCategory từ controller
        //       // final selectedCategory = productController.selectedCategory.value;
        //       //
        //       // bool isSelected = selectedCategory == productTypes[index];
        //       final category = productController.allCategories?[index];
        //       return Obx(() => GestureDetector(
        //         onTap: () {
        //           productController.addSelectedCategory(category); // Cập nhật trạng thái
        //         },
        //         child: Container(
        //           margin: const EdgeInsets.only(right: 6),
        //           padding: const EdgeInsets.all(8),
        //           decoration: BoxDecoration(
        //             border: Border.all(color: productController.isSelectedCategory(category!) ? primaryColor : Colors.black, width: 1),
        //             borderRadius: BorderRadius.circular(4),
        //           ),
        //           child: Text(
        //             category,
        //             style: TextStyle(color: productController.isSelectedCategory(category!) ? primaryColor : Colors.black),
        //           ),
        //         ),
        //       )) ;
        //     },
        //   ),
        // ),

        Expanded(
                child: Obx(() {
                  List<Product> products = productController.allProducts;
                  if (products.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/icons/not_found_icon.png', height: 80),
                          const SizedBox(height: 30),
                          Text('Không tìm thấy sản phẩm phù hợp', style: TextStyle(fontSize: 18),)
                        ],
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await productController.refreshProductList();
                      },
                      child: ListView.builder(
                          controller: scrollController,
                          itemCount: products.length + 1,
                          itemBuilder: (context, index) {
                            if(index < products.length) {
                              final Product product = products[index];
                              return GestureDetector(
                                  onTap: () {
                                    productController.setSelectedProduct(product);
                                    Get.to(() => ProductDetailScreen());
                                  },
                                  child: ItemCard(product: product)
                              );
                            } else if (productController.hasMoreData.value) {
                              return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ));
                            }
                            return null;

                          }
                      ),
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
                // Obx(() => productController.searchSuggestions.isEmpty
                //     ? SizedBox.shrink()
                //     : Container(
                //   margin: EdgeInsets.symmetric(vertical: 4),
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     border: Border.all(color: Colors.grey),
                //     borderRadius: BorderRadius.circular(8),
                //   ),
                //   child: Column(
                //     children: productController.searchSuggestions
                //         .map((suggestion) => ListTile(
                //       title: Text(suggestion),
                //       onTap: () {
                //         searchQueryController.text = suggestion;
                //         productController.selectSuggestion(suggestion);
                //       },
                //     ))
                //         .toList(),
                //   ),
                // )),
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
