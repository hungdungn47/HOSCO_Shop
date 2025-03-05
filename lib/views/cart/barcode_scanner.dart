import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hosco_shop_2/controllers/product_controller.dart';
import 'package:hosco_shop_2/models/product.dart';
import 'package:hosco_shop_2/utils/navigation_drawer.dart';
import 'package:intl/intl.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import '../../controllers/cart_controller.dart';
import '../../models/cart_item.dart';
import '../../utils/constants.dart';
import '../common_widgets/cart_item_card.dart';

class BarcodeScanner extends StatelessWidget {
  BarcodeScanner({super.key});

  final ProductController productController = Get.find<ProductController>();

  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quét mã sản phẩm")
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1)
              ),

              child: SimpleBarcodeScanner(
                scaleHeight: 200,
                scaleWidth: 400,
                onScanned: (code) async {
                  if(cartController.productIdSet.contains(int.parse(code))) return;
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
                  } else {
                    print('Added new product: ${newProduct.name}');
                    cartController.addToCart(newProduct);
                  }

                },
                continuous: false,
                onBarcodeViewCreated: (BarcodeViewController controller) {
                  controller = controller;
                },
              )
            ),
            const SizedBox(height: 30),
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
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.info,
                      animType: AnimType.rightSlide,
                      title: "Thanh toán",
                      desc: 'Hãy chọn phương thức thanh toán',
                      btnCancelColor: Colors.green,
                      btnCancelText: 'Tiền mặt',
                      btnCancelOnPress: () {
                        cartController.completeTransaction("cash");
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.success,
                          title: "Thành công",
                          desc: "Xác nhận thanh toán thành công!",
                        ).show();
                      },
                      btnOkColor: primaryColor,
                      btnOkText: 'Chuyển khoản',
                      btnOkOnPress: () {
                        cartController.completeTransaction("bank-transfer");
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.success,
                          title: "Thành công",
                          desc: "Xác nhận thanh toán thành công!",
                        ).show();
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
