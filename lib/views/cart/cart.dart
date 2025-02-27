import 'package:awesome_dialog/awesome_dialog.dart';
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
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Stack(
          children: [

            Column(
              children: [
                const SizedBox(height: 80),
                Expanded(
                  child: Obx(() {
                    List<CartItem> cartItems = cartController.cartItems;
                    if (cartItems.isEmpty) {
                      return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/icons/cart_empty_icon.png', height: 80, width: 80),
                            const SizedBox(height: 30),
                            Text('Giỏ hàng đang rỗng!', style: TextStyle(fontSize: 18)),
                          ]
                      );
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
            Column(
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

              ],
            ),
          ],
        )
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
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.warning,
                    animType: AnimType.rightSlide,
                    title: "Xóa tất cả",
                    desc: 'Bạn có chắc chắn muốn xóa các sản phẩm khỏi giỏ hàng?',
                    btnCancelText: 'Hủy',
                    btnCancelOnPress: () {},
                    btnOkText: 'Xóa',
                    btnOkOnPress: () {
                      cartController.clearCartItems();
                    },
                  ).show();
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
                  if(cartController.cartItems.isEmpty) {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.rightSlide,
                      title: "Lỗi",
                      desc: 'Giỏ hàng đang rỗng',
                      btnCancelOnPress: () {},
                      btnOkOnPress: () {
                      },
                    ).show();
                  } else {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.info,
                      animType: AnimType.rightSlide,
                      title: "Thanh toán",
                      desc: 'Hãy chọn phương thức thanh toán',
                      btnCancelColor: Colors.green,
                      btnCancelText: 'Tiền mặt',
                      btnCancelOnPress: () {

                      },
                      btnOkColor: primaryColor,
                      btnOkText: 'Chuyển khoản',
                      btnOkOnPress: () {
                        cartController.completeTransaction();
                      },
                    ).show();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
