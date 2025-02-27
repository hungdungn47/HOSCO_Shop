import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hosco_shop_2/controllers/cart_controller.dart';
import 'package:hosco_shop_2/models/cartItem.dart';
import 'package:hosco_shop_2/utils/constants.dart';
import 'package:intl/intl.dart';

class CartItemCard extends StatelessWidget {
  final CartItem cartItem;
  final CartController cartController = Get.find<CartController>();

  final TextStyle fieldNameTextStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w300
  );
  final TextStyle boldText = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold
  );
  final TextStyle blueBoldText = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: primaryColor
  );
  final TextStyle italicLightText = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.italic
  );

  CartItemCard({required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(
                color: primaryColor,
                blurRadius: 3,
                spreadRadius: 1
            )
          ]
      ),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        children: [
          // Product Image
          Container(
              padding: const EdgeInsets.all(6.0),
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: primaryColor, width: 1)),
                // borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: CachedNetworkImage(
                imageUrl: cartItem.product.imageUrl,
                placeholder: (context, url) => Center(
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              )
          ),

          // Product Details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Sản phẩm", style: fieldNameTextStyle,),
                      Flexible(
                        child: Text( cartItem.product.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: boldText,),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Đơn giá", style: fieldNameTextStyle,),
                      Flexible(
                        child: Text( NumberFormat.decimalPattern().format(cartItem.product.price), maxLines: 1, overflow: TextOverflow.ellipsis, style: boldText,),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Số lượng", style: fieldNameTextStyle,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Remove 1 button
                          GestureDetector(
                            onTap: () {
                              cartController.removeFromCart(cartItem.product);
                            },
                            child: Image.asset(
                              'assets/icons/red_minus_icon.png',
                              height: 25
                            ),
                          ),
                          const SizedBox(width: 8),
                          Obx(() => Text( '${cartController.getQuantity(cartItem.product)}', maxLines: 1, overflow: TextOverflow.ellipsis, style: blueBoldText,)),
                          // Add 1 button
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              cartController.addToCart(cartItem.product);
                            },
                            child: Image.asset(
                              'assets/icons/blue_add_icon.png',
                              height: 25
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Quantity Controls

        ],
      ),
    );
  }
}
