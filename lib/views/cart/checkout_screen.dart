import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hosco_shop_2/controllers/cart_controller.dart';
import 'package:get/get.dart';
import 'package:hosco_shop_2/controllers/customer_controller.dart';
import 'package:hosco_shop_2/views/common_widgets/toggle_button.dart';
import 'package:intl/intl.dart';

import '../../models/cart_item.dart';
import '../../utils/constants.dart';
import '../common_widgets/cart_item_card.dart';

class CheckoutScreen extends StatelessWidget {

  final CartController cartController = Get.find<CartController>();
  final CustomerController customerController = Get.find<CustomerController>();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController searchQueryController = TextEditingController();
  // CheckoutScreen({super.key});
  CheckoutScreen({Key? key}) : super(key: key) {
    discountController.text = "0";
    searchQueryController.text = "Khách lẻ";
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Thanh toán"),
        leading: IconButton(onPressed: () => Get.offAndToNamed('/cart'), icon: Icon(Icons.arrow_back)),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 80),
              Expanded(
                child: Obx(() {
                  List<CartItem> cartItems = cartController.cartItems;
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
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Tổng giá trị:",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${NumberFormat.decimalPattern().format(cartController.getTotalPrice())} đ",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Chiết khấu",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      // Init value = false: Choose unit VND
                      IosToggleButton(leftText: "VND", rightText: "%", initValue: false, onChange: (value) {
                        cartController.discountUnitPercentage.value = value;
                        cartController.discountAmount.value = 0;
                        discountController.text = "0";
                      }),
                      SizedBox(
                        width: 100,
                        child: TextField(
                          onChanged: (value) => cartController.discountAmount.value = double.parse(value),
                          textAlign: TextAlign.right,
                          controller: discountController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration.collapsed(
                              hintText: "Giá trị",
                              hintStyle: TextStyle(
                                color: Colors.grey,
                              )
                          ),
                        ),
                      ),
                    ],
                  )
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24).copyWith(bottom: 16),
                child: Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Thành tiền:",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${NumberFormat.decimalPattern().format(cartController.finalPrice())} đ",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor),
                    ),
                  ],
                )),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextField(
                  controller: searchQueryController,
                  onTap: () {
                    // Clear text field when tapped
                    searchQueryController.clear();
                    // Show suggestion list
                    customerController.isShowSuggestion.value = true;
                    // Trigger search with empty value to show all suggestions
                    customerController.searchCustomers('');
                  },
                  onChanged: (value) {
                    customerController.searchCustomers(value);
                    // Make sure suggestions remain visible when typing
                    if (!customerController.isShowSuggestion.value) {
                      customerController.toggleShowSuggestion();
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "Chọn khách hàng",
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: IconButton(
                        onPressed: () {
                          // Clear focus
                          FocusScope.of(context).requestFocus(new FocusNode());
                          // Set default text
                          searchQueryController.text = "Khách lẻ";
                          // Hide suggestion list
                          customerController.isShowSuggestion.value = false;
                        },
                        icon: Icon(Icons.clear)
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),

                // 🔹 Show search suggestions
                Obx(() => !customerController.isShowSuggestion.value
                    ? SizedBox.shrink()
                    : Container(
                  margin: EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: customerController.suggestionCustomers
                        .map((suggestion) => ListTile(
                      title: Text(suggestion.name),
                      onTap: () {
                        searchQueryController.text = suggestion.name;
                        customerController.isShowSuggestion.value = false;
                        // productController.selectSuggestion(suggestion);
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
                label: Text("Hủy đơn", style: TextStyle(fontSize: 18, color: Colors.white)),
                onPressed: () {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.warning,
                    animType: AnimType.rightSlide,
                    title: "Hủy đơn",
                    desc: 'Bạn có chắc chắn muốn hủy đơn hàng?',
                    btnCancelText: 'Không',
                    btnCancelOnPress: () {},
                    btnOkText: 'Có',
                    btnOkOnPress: () async {
                      cartController.clearCartItems();

                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.success,
                        title: "Thành công",
                        desc: "Hủy đơn hàng thành công!",
                      ).show();
                      await Future.delayed(Duration(seconds: 2));
                      Get.offAndToNamed('/cart');
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
                label: Text("Xác nhận", style: TextStyle(fontSize: 18, color: Colors.white)),
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
                      btnCancelOnPress: () async {
                        cartController.completeTransaction("cash");
                        discountController.text = "0";
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.success,
                          title: "Thành công",
                          desc: "Xác nhận thanh toán thành công!",
                        ).show();
                        await Future.delayed(const Duration(seconds: 2));
                        Get.offAndToNamed('/cart');
                      },
                      btnOkColor: primaryColor,
                      btnOkText: 'Chuyển khoản',
                      btnOkOnPress: () async {
                        cartController.completeTransaction("bank-transfer");
                        discountController.text = "0";
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.success,
                          title: "Thành công",
                          desc: "Xác nhận thanh toán thành công!",
                        ).show();
                        await Future.delayed(const Duration(seconds: 2));
                        Get.offAndToNamed('/cart');
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
