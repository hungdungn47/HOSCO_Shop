import './cartItem.dart';
import './product.dart';

class Transaction {
  final String id;
  final List<CartItem> items;
  final double totalAmount;
  final DateTime date;

  Transaction({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.date,
  });

  // Convert Transaction to JSON (for storage)
  Map<String, dynamic> toJson() => {
    "id": id,
    "items": items.map((item) => item.toJson()).toList(),
    "totalAmount": totalAmount,
    "date": date.toIso8601String(),
  };

  // Convert JSON to Transaction
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      items: (json['items'] as List).map((item) => CartItem.fromJson(item)).toList(),
      totalAmount: json['totalAmount'],
      date: DateTime.parse(json['date']),
    );
  }
}
