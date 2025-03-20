import 'package:flutter/material.dart';
import 'package:hosco_shop_2/models/cart_item.dart';
import 'package:hosco_shop_2/controllers/cart_controller.dart';

class DiscountWidget extends StatefulWidget {
  final CartItem cartItem;
  final CartController cartController;

  DiscountWidget({required this.cartItem, required this.cartController});

  @override
  _DiscountWidgetState createState() => _DiscountWidgetState();
}

class _DiscountWidgetState extends State<DiscountWidget> {
  late TextEditingController discountController;
  late FocusNode discountFocusNode;
  // late DiscountType selectedDiscountType;
  late String selectedDiscountType;

  @override
  void initState() {
    super.initState();
    discountController =
        TextEditingController(text: widget.cartItem.discount.toString());
    discountFocusNode = FocusNode();
    selectedDiscountType = widget.cartItem.discountUnit;
  }

  @override
  void dispose() {
    discountController.dispose();
    discountFocusNode.dispose();
    super.dispose();
  }

  void updateDiscount() {
    double discount = double.tryParse(discountController.text) ?? 0;
    widget.cartController.updateSingleDiscount(
        widget.cartItem.product, discount, selectedDiscountType);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Chiết khấu",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300)),
        Row(
          children: [
            SizedBox(
              width: 80,
              child: TextField(
                controller: discountController,
                focusNode: discountFocusNode, // Keep focus when updating
                textAlign: TextAlign.right,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  // Delay the update to avoid losing focus
                  Future.delayed(Duration(milliseconds: 300), updateDiscount);
                },
                decoration: InputDecoration(
                  hintText: "Giá trị",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // IosToggleButton(leftText: "VND", rightText: "%", initValue: true, onChange: (value) {
            //   if(value) {
            //     setState(() {
            //       selectedDiscountType = DiscountType.fixed;
            //     });
            //   } else {
            //     setState(() {
            //       selectedDiscountType = DiscountType.percentage;
            //     });
            //   }
            // },)
            DropdownButton<String>(
              value: selectedDiscountType,
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedDiscountType = newValue;
                  });
                  updateDiscount();
                }
              },
              items: [
                DropdownMenuItem(
                    value: 'vnd',
                    child: Text(
                      "VND",
                      style: TextStyle(fontSize: 14),
                    )),
                DropdownMenuItem(
                    value: 'percentage',
                    child: Text("%", style: TextStyle(fontSize: 14))),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
