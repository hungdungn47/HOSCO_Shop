import './product.dart';
// class CartItem {
//   final Product product;
//   int quantity;
//   double discount;
//
//   CartItem({
//     required this.product,
//     this.quantity = 1
//   });
//
//   Map<String, dynamic> toJson() {
//     return {
//       'productId': product.id,
//       'quantity': quantity,
//     };
//   }
//
//   factory CartItem.fromJson(Map<String, dynamic> json, Product product) {
//     return CartItem(
//       product: product,
//       quantity: json['quantity'],
//     );
//   }
// }

enum DiscountType { percentage, fixed }

class CartItem {
  final Product product;
  int quantity;
  double discount;
  DiscountType discountType;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.discount = 0.0,
    this.discountType = DiscountType.fixed, // Default to fixed discount
  });

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
      'discount': discount,
      'discountType': discountType.index, // Store as int
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json, Product product) {
    return CartItem(
      product: product,
      quantity: json['quantity'],
      discount: json['discount'] ?? 0.0,
      discountType: DiscountType.values[json['discountType'] ?? 0],
    );
  }

  double getFinalPrice() {
    if (discountType == DiscountType.percentage) {
      return product.price * (1 - discount / 100);
    } else {
      return product.price - discount;
    }
  }
}
