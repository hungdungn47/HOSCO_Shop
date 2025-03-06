import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hosco_shop_2/controllers/cart_controller.dart';
import 'package:hosco_shop_2/controllers/product_controller.dart';
import 'package:hosco_shop_2/models/cart_item.dart';
import 'package:hosco_shop_2/utils/constants.dart';
import 'package:hosco_shop_2/utils/navigation_drawer.dart';
import 'package:get/get.dart';
import 'package:hosco_shop_2/views/cart/checkout_screen.dart';
import 'package:hosco_shop_2/views/common_widgets/cart_item_card.dart';
import 'package:intl/intl.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import '../../models/product.dart';

class Cart extends StatelessWidget {
  Cart({super.key});
  final TextEditingController searchQueryController = TextEditingController();
  final CartController cartController = Get.find<CartController>();
  final ProductController productController = Get.find<ProductController>();
  // final FocusNode searchFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyNavigationDrawer(),
      appBar: AppBar(
        title: Text('Đơn hàng mới'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: () {
                cartController.toggleBarcode();
              },
              child: Obx(() {
                return Image(
                  color: Colors.white,
                  height: 25,
                  width: 25,
                  image: AssetImage( cartController.isBarcodeOn.value ? 'assets/icons/barcode_off_icon.png' : 'assets/icons/barcode_icon.png' ),
                );
              })
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: (){
          // print('hehe');
          FocusScope.of(context).requestFocus(new FocusNode());
          cartController.isShowSuggestion.value = false;
        },
        child: Stack(
          children: [
            // Danh sách sản phẩm trong giỏ và tổng tiền cần thanh toán, nằm bên dưới của stack
            Column(
              children: [
                // Sized Box để lấy khoảng trống cho ô tìm kiếm
                const SizedBox(height: 80),
                Obx(() {
                  return cartController.isBarcodeOn.value ? Container(
                      width: 300,
                      height: 150,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1)
                      ),

                      child: SimpleBarcodeScanner(
                        scaleHeight: 200,
                        // delayMillis: ,
                        scaleWidth: 400,
                        onScanned: (code) async {
                          if(cartController.productIdSet.contains(int.parse(code))) return;
                          cartController.productIdSet.add(int.parse(code));
                          print(code);
                          Product? newProduct = await productController.getProductById(code);
                          if(newProduct == null) {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.rightSlide,
                              title: "Lỗi",
                              desc: 'Không tồn tại sản phẩm với mã này!',
                              btnCancelOnPress: () {},
                              btnOkOnPress: () {
                              },
                            ).show();
                            print('hohoho');
                          } else {
                            print('Added new product: ${newProduct.name}');
                            cartController.addToCart(newProduct);
                          }

                          await Future.delayed(Duration(milliseconds: 1000));
                        },
                        continuous: false,
                        onBarcodeViewCreated: (BarcodeViewController controller) {
                          controller = controller;
                        },
                      )
                  ) : SizedBox(height: 0);
                }) ,
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

                            return CartItemCard(cartItem: cartItem, inCheckout: false,);
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
                        "${NumberFormat.decimalPattern().format(cartController.getTotalPrice())} đ",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor),
                      ),
                    ],
                  )),
                ),
              ],
            ),
            // Phần tìm kiếm
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(12.0).copyWith(bottom: 0),
                  child: Column(
                    children: [
                      TextField(
                        onTap: () {
                          cartController.isShowSuggestion.value = true;
                        },
                        controller: searchQueryController,
                        onChanged: cartController.searchProduct,
                        decoration: InputDecoration(
                          hintText: "Tìm kiếm sản phẩm...",
                          prefixIcon: Icon(Icons.search),
                          suffixIcon: IconButton(onPressed: () {
                            FocusScope.of(context).requestFocus(new FocusNode());
                            cartController.isShowSuggestion.value = false;
                            searchQueryController.clear();
                            cartController.clearSearchQuery();
                          }, icon: Icon(Icons.clear)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),

                      // 🔹 Show search suggestions
                      Obx(() => !cartController.isShowSuggestion.value ?
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
                            title: Text(suggestion['name']),
                            trailing: Text("${suggestion['id']}"),
                            onTap: () {
                              FocusScope.of(context).requestFocus(new FocusNode());
                              cartController.isShowSuggestion.value = false;
                              searchQueryController.clear();
                              cartController.clearSearchQuery();
                              cartController.selectSuggestion(suggestion);
                            },
                          ))
                              .toList(),
                        ),
                        // child: SizedBox(
                        //   height: 350,
                        //   child: ListView.builder(
                        //     itemCount: cartController.searchSuggestions.length,
                        //     itemBuilder: (context, index) {
                        //       final suggestion = cartController.searchSuggestions[index];
                        //       return ListTile(
                        //         title: Text(suggestion['name']),
                        //         trailing: Text("${suggestion['id']}"),
                        //         onTap: () {
                        //           FocusScope.of(context).requestFocus(new FocusNode());
                        //           searchQueryController.clear();
                        //           cartController.clearSearchQuery();
                        //           cartController.selectSuggestion(suggestion);
                        //         },
                        //       );
                        //     },
                        //   ),
                        // )
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
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.success,
                        title: "Thành công",
                        desc: "Xóa giỏ hàng thành công!",
                      ).show();
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
                    Get.off(() => CheckoutScreen());
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
