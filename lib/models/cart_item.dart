import './product.dart';

// enum DiscountType { percentage, fixed }
// discountType: vnd / percentage
class CartItem {
  final Product product;
  int quantity;
  double discount;
  String discountUnit;
  double unitPrice;
  String? warehouseId;

  CartItem(
      {required this.product,
      this.quantity = 1,
      this.discount = 0.0,
      this.warehouseId,
      this.discountUnit = 'vnd', // Default to fixed discount
      required this.unitPrice});

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
      'discount': discount,
      'discountUnit': discountUnit,
      'warehouseId': warehouseId
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json, Product product) {
    return CartItem(
        unitPrice: json['unitPrice'].toDouble(),
        product: product,
        quantity: json['quantity'],
        discount: json['discount'] != null ? json['discount'].toDouble() : 0.0,
        discountUnit: json['discountUnit']);
  }

  double getFinalPrice() {
    if (discountUnit == 'percentage') {
      return product.wholesalePrice * (1 - discount / 100);
    } else {
      return product.wholesalePrice - discount;
    }
  }
}
