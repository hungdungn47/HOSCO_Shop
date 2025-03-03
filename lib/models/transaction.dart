

import './cartItem.dart';
import './product.dart';

class CustomTransaction {
  final String id;
  final List<CartItem> items;
  final double totalAmount;
  final DateTime date;
  final String type;
  final String paymentMethod;

  CustomTransaction({
    this.id = "1",
    required this.items,
    required this.totalAmount,
    required this.date,
    this.type = "sale",
    this.paymentMethod = "cash"
  });

  // Convert Transaction to JSON (for storage)
  Map<String, dynamic> toJson() => {
    "id": id,
    "items": items.map((item) => item.toJson()).toList(),
    "totalAmount": totalAmount,
    "date": date.toIso8601String(),
    "type": type,
    "paymentMethod": paymentMethod
  };

  // Convert JSON to Transaction
  factory CustomTransaction.fromJson(Map<String, dynamic> json) {
    return CustomTransaction(
      id: json['id'],
      items: (json['items'] as List).map((item) => CartItem.fromJson(item)).toList(),
      totalAmount: json['totalAmount'],
      date: DateTime.parse(json['date']),
      type: json['type'],
      paymentMethod: json['paymentMethod']
    );
  }
}
