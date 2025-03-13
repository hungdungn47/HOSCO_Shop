import 'package:hosco_shop_2/models/supplier.dart';

class Product {
  String id;
  String name;
  String category;
  double wholesalePrice;
  double retailPrice;
  int? stockQuantity;
  String? unit;
  String? imageUrl;
  String? description;
  double discount;
  String discountUnit;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.wholesalePrice,
    required this.retailPrice,
    this.stockQuantity,
    this.imageUrl,
    this.description,
    this.discountUnit = "percentage",
    this.discount = 0.0,
    this.unit
  });

  /// Convert Product to JSON (Store only supplierId)
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "category": category,
      "stockQuantity": stockQuantity,
      "wholesalePrice": wholesalePrice,
      "retailPrice": retailPrice,
      "imageUrl": imageUrl,
      "description": description,
      "discount": discount,
      "discountUnit": discountUnit,
      "unit": unit
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      wholesalePrice: (json['wholesalePrice'] as num).toDouble(),
      retailPrice: (json['retailPrice'] as num).toDouble(),
      stockQuantity: json['stockQuantity'] as int,
      imageUrl: json['imageUrl'] as String,
      description: json['description'] as String,
      discountUnit: json['discountUnit'] as String,
      discount: (json['discount'] as num).toDouble(),
      unit: json['unit'] as String?,
    );
  }
}
