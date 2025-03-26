// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:hosco_shop_2/controllers/cart_controller.dart';
// import 'package:hosco_shop_2/models/cart_item.dart';
// import 'package:hosco_shop_2/utils/constants.dart';
// import 'package:hosco_shop_2/views/cart/discount_widget.dart';
// import 'package:intl/intl.dart';

// // Define a model for warehouse stock
// class WarehouseStock {
//   final String id;
//   final String name;
//   final int totalQuantity;

//   WarehouseStock({
//     required this.id,
//     required this.name,
//     required this.totalQuantity
//   });

//   factory WarehouseStock.fromJson(Map<String, dynamic> json) {
//     return WarehouseStock(
//       id: json['warehouse']['id'],
//       name: json['warehouse']['name'],
//       totalQuantity: json['totalQuantity']
//     );
//   }
// }

// class CartItemCard extends StatelessWidget {
//   final CartItem cartItem;
//   final CartController cartController = Get.find<CartController>();
//   final bool inCheckout;

//   final TextEditingController discountController = TextEditingController();

//   final TextStyle fieldNameTextStyle =
//       TextStyle(fontSize: 16, fontWeight: FontWeight.w300);
//   final TextStyle boldText =
//       TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
//   final TextStyle blueBoldText =
//       TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor);
//   final TextStyle italicLightText = TextStyle(
//       fontSize: 16, fontWeight: FontWeight.w400, fontStyle: FontStyle.italic);

//   CartItemCard({required this.cartItem, this.inCheckout = true}) {
//     // discountController.text = "50000";
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.all(Radius.circular(12)),
//           boxShadow: [
//             BoxShadow(color: primaryColor, blurRadius: 3, spreadRadius: 1)
//           ]),
//       margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
//       child: Row(
//         children: [
//           // Product Image
//           Container(
//               padding: const EdgeInsets.all(6.0),
//               width: 120,
//               height: 120,
//               decoration: BoxDecoration(
//                 border:
//                     Border(right: BorderSide(color: primaryColor, width: 1)),
//                 // borderRadius: BorderRadius.all(Radius.circular(12)),
//               ),
//               child: cartItem.product.imageUrl != null
//                   ? CachedNetworkImage(
//                       imageUrl: cartItem.product.imageUrl!,
//                       placeholder: (context, url) => Center(
//                         child: SizedBox(
//                           height: 50,
//                           width: 50,
//                           child: CircularProgressIndicator(),
//                         ),
//                       ),
//                       errorWidget: (context, url, error) => Icon(Icons.error),
//                     )
//                   : Icon(Icons.error)),

//           // Product Details
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Sản phẩm",
//                         style: fieldNameTextStyle,
//                       ),
//                       Flexible(
//                         child: Text(
//                           cartItem.product.name,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: boldText,
//                         ),
//                       ),
//                     ],
//                   ),
//                   // const SizedBox(height: 8),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Đơn giá",
//                         style: fieldNameTextStyle,
//                       ),
//                       Flexible(
//                         child: Text(
//                           NumberFormat.decimalPattern()
//                               .format(cartItem.product.wholesalePrice),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: boldText,
//                         ),
//                       ),
//                     ],
//                   ),
//                   // const SizedBox(height: 8),
//                   inCheckout
//                       ? _unchangableAmountWidget()
//                       : _changableAmountWidget(),
//                   inCheckout
//                       ? DiscountWidget(
//                           cartItem: cartItem, cartController: cartController)
//                       : SizedBox.shrink()
//                 ],
//               ),
//             ),
//           ),

//           // Quantity Controls
//         ],
//       ),
//     );
//   }

//   Widget _unchangableAmountWidget() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           "Số lượng",
//           style: fieldNameTextStyle,
//         ),
//         Obx(() => Text(
//               '${cartController.getQuantity(cartItem.product)}',
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               style: blueBoldText,
//             )),
//       ],
//     );
//   }

//   Widget _changableAmountWidget() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           "Số lượng",
//           style: fieldNameTextStyle,
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             // Remove 1 button
//             GestureDetector(
//               onTap: () {
//                 cartController.removeFromCart(cartItem.product);
//               },
//               child: Image.asset('assets/icons/red_minus_icon.png', height: 25),
//             ),
//             const SizedBox(width: 8),
//             Obx(() => Text(
//                   '${cartController.getQuantity(cartItem.product)}',
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: blueBoldText,
//                 )),
//             // Add 1 button
//             const SizedBox(width: 8),
//             GestureDetector(
//               onTap: () {
//                 cartController.addToCart(cartItem.product);
//               },
//               child: Image.asset('assets/icons/blue_add_icon.png', height: 25),
//             )
//           ],
//         )
//       ],
//     );
//   }
// }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hosco_shop_2/controllers/cart_controller.dart';
import 'package:hosco_shop_2/models/cart_item.dart';
import 'package:hosco_shop_2/utils/constants.dart';
import 'package:hosco_shop_2/views/cart/discount_widget.dart';
import 'package:intl/intl.dart';

// Define a model for warehouse stock
class WarehouseStock {
  final String id;
  final String name;
  final int totalQuantity;

  WarehouseStock(
      {required this.id, required this.name, required this.totalQuantity});

  factory WarehouseStock.fromJson(Map<String, dynamic> json) {
    return WarehouseStock(
        id: json['warehouse']['id'],
        name: json['warehouse']['name'],
        totalQuantity: json['totalQuantity']);
  }
}

class CartItemCard extends StatefulWidget {
  final CartItem cartItem;
  final bool inCheckout;

  const CartItemCard({Key? key, required this.cartItem, this.inCheckout = true})
      : super(key: key);

  @override
  _CartItemCardState createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard> {
  final CartController cartController = Get.find<CartController>();
  final TextEditingController discountController = TextEditingController();

  // Warehouse-related variables
  List<WarehouseStock> _availableWarehouses = [];
  WarehouseStock? _selectedWarehouse;

  final TextStyle fieldNameTextStyle =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w300);
  final TextStyle boldText =
      TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  final TextStyle blueBoldText =
      TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor);
  final TextStyle italicLightText = TextStyle(
      fontSize: 16, fontWeight: FontWeight.w400, fontStyle: FontStyle.italic);

  @override
  void initState() {
    super.initState();
    // Fetch warehouse stock when the widget is first created
    if (widget.inCheckout) {
      _fetchWarehouseStock();
    }
  }

  Future<void> _fetchWarehouseStock() async {
    try {
      // Assuming you have a method in your CartController to fetch warehouse stock
      final response = await cartController
          .getProductAvailableWarehouses(widget.cartItem.product.id);
      if (response != null) {
        setState(() {
          _availableWarehouses = (response['warehouseStocks'] as List)
              .map((warehouseJson) => WarehouseStock.fromJson(warehouseJson))
              .toList();

          // Automatically select the first warehouse if available
          if (_availableWarehouses.isNotEmpty) {
            _selectedWarehouse = _availableWarehouses.first;
            widget.cartItem.warehouseId = _selectedWarehouse?.id;
          }
        });

        print("Available warehouse: ${_availableWarehouses}");
      }
    } catch (e) {
      print('Error fetching warehouse stock: $e');
      // Handle error - maybe show a snackbar or log the error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(color: primaryColor, blurRadius: 3, spreadRadius: 1)
          ]),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Column(
        children: [
          Row(
            children: [
              // Product Image (existing code remains the same)
              Container(
                  padding: const EdgeInsets.all(6.0),
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    border: Border(
                        right: BorderSide(color: primaryColor, width: 1)),
                  ),
                  child: widget.cartItem.product.imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: widget.cartItem.product.imageUrl!,
                          placeholder: (context, url) => Center(
                            child: SizedBox(
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        )
                      : Icon(Icons.error)),

              // Product Details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Existing product name and price rows
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Sản phẩm",
                            style: fieldNameTextStyle,
                          ),
                          Flexible(
                            child: Text(
                              widget.cartItem.product.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: boldText,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Đơn giá",
                            style: fieldNameTextStyle,
                          ),
                          Flexible(
                            child: Text(
                              NumberFormat.decimalPattern().format(
                                  widget.cartItem.product.wholesalePrice),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: boldText,
                            ),
                          ),
                        ],
                      ),

                      // Quantity widget (existing code)
                      widget.inCheckout
                          ? _unchangableAmountWidget()
                          : _changableAmountWidget(),

                      // Warehouse Selector
                      _buildWarehouseSelector(),

                      // Discount widget
                      widget.inCheckout
                          ? DiscountWidget(
                              cartItem: widget.cartItem,
                              cartController: cartController)
                          : SizedBox.shrink()
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWarehouseSelector() {
    if (_availableWarehouses.isEmpty) {
      return SizedBox.shrink(); // Hide if no warehouses available
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Kho xuất",
          style: fieldNameTextStyle,
        ),
        DropdownButton<WarehouseStock>(
          value: _selectedWarehouse,
          hint: Text('Chọn kho', style: blueBoldText),
          items: _availableWarehouses.map((warehouse) {
            return DropdownMenuItem<WarehouseStock>(
              value: warehouse,
              child: Text(
                '${warehouse.id}',
                style: blueBoldText,
              ),
            );
          }).toList(),
          onChanged: (WarehouseStock? newValue) {
            widget.cartItem.warehouseId = newValue?.id;
            print('Updated cart item: ${widget.cartItem.toJson()}');
            // setState(() {
            //   _selectedWarehouse = newValue;
            //   // Optionally, you can add logic to update cart item with selected warehouse
            //   cartController.updateCartItemWarehouse(
            //     widget.cartItem,
            //     newValue?.id
            //   );
            // });
          },
        ),
      ],
    );
  }

  Widget _unchangableAmountWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Số lượng",
          style: fieldNameTextStyle,
        ),
        Obx(() => Text(
              '${cartController.getQuantity(widget.cartItem.product)}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: blueBoldText,
            )),
      ],
    );
  }

  Widget _changableAmountWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Số lượng",
          style: fieldNameTextStyle,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Remove 1 button
            GestureDetector(
              onTap: () {
                cartController.removeFromCart(widget.cartItem.product);
              },
              child: Image.asset('assets/icons/red_minus_icon.png', height: 25),
            ),
            const SizedBox(width: 8),
            Obx(() => Text(
                  '${cartController.getQuantity(widget.cartItem.product)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: blueBoldText,
                )),
            // Add 1 button
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                cartController.addToCart(widget.cartItem.product);
              },
              child: Image.asset('assets/icons/blue_add_icon.png', height: 25),
            )
          ],
        )
      ],
    );
  }
}
