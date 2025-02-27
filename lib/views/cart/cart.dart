import 'package:cloudinary_url_gen/transformation/extract/extract.dart';
import 'package:flutter/material.dart';
import 'package:hosco_shop_2/controllers/cart_controller.dart';
import 'package:hosco_shop_2/controllers/product_controller.dart';
import 'package:hosco_shop_2/models/cartItem.dart';
import 'package:hosco_shop_2/utils/constants.dart';
import 'package:hosco_shop_2/utils/navigation_drawer.dart';
import 'package:get/get.dart';
import 'package:hosco_shop_2/views/common_widgets/cart_item_card.dart';
import 'package:intl/intl.dart';
import '../../models/product.dart';

class Cart extends StatelessWidget {
  Cart({super.key});
  final TextEditingController searchQueryController = TextEditingController();
  final CartController cartController = Get.find<CartController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyNavigationDrawer(),
      appBar: AppBar(
        title: Text('Đơn hàng mới'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12.0).copyWith(bottom: 0),
            child: Column(
              children: [
                TextField(
                  controller: searchQueryController,
                  onChanged: cartController.searchProduct,
                  decoration: InputDecoration(
                    hintText: "Tìm kiếm sản phẩm...",
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: IconButton(onPressed: () {
                      searchQueryController.clear();
                      cartController.clearSearchQuery();
                    }, icon: Icon(Icons.clear)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),

                // 🔹 Show search suggestions
                Obx(() => cartController.searchQuery == "" ?
                  SizedBox.shrink():
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: cartController.searchSuggestions
                          .map((suggestion) => ListTile(
                        title: Text(suggestion),
                        onTap: () {
                          searchQueryController.clear();
                          cartController.clearSearchQuery();
                          cartController.selectSuggestion(suggestion);
                        },
                      ))
                          .toList(),
                    ),
                  )
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              List<CartItem> cartItems = cartController.cartItems;
              if (cartItems.isEmpty) {
                return Center(child: Text('Giỏ hàng đang rỗng!'));
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
                child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final CartItem cartItem = cartItems[index];

                      return CartItemCard(cartItem: cartItem);
                    }
                ),
              );
            }),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            // decoration: BoxDecoration(
            //   color: Colors.white,
            //   border: Border(top: BorderSide(color: Colors.grey.shade300, width: 1)),
            // ),
            child: Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tổng tiền:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${NumberFormat.decimalPattern().format(cartController.totalPrice)} đ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor),
                ),
              ],
            )),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(24.0).copyWith(top: 0),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Set border radius here
                  ),
                ),
                icon: Icon(Icons.delete, color: Colors.white),
                label: Text("Xóa tất cả", style: TextStyle(fontSize: 18, color: Colors.white)),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Xóa tất cả"),
                          content: Text("Bạn muốn xóa tất cả sản phẩm trong giỏ hàng?"),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Hủy'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                  backgroundColor: Colors.red
                              ),
                              onPressed: () {
                                cartController.clearCartItems();
                                Navigator.pop(context);
                              },
                              child: Text('Xóa'),
                            )
                          ],
                        );
                      });

                },
              ),
            ),
            SizedBox(width: 16.0),
            // Edit Button
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Set border radius here
                  ),
                ),
                label: Text("Thanh toán", style: TextStyle(fontSize: 18, color: Colors.white)),
                onPressed: () {
                  cartController.completeTransaction();
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Thanh toán thành công!"),
                        content: Text("Bạn đã thanh toán thành công!"),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          )
                        ],
                      );
                    });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
