import './product.dart';

class TransactionItem {
  int? id;
  final String transactionId;
  final Product product;
  int quantity;

  TransactionItem({
    this.id,
    required this.transactionId,
    required this.product,
    this.quantity = 1
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transactionId': transactionId,
      'productId': product.id,
      'quantity': quantity,
    };
  }

  factory TransactionItem.fromJson(Map<String, dynamic> json, Product product) {
    return TransactionItem(
      id: json['id'],
      transactionId: json['transactionId'],
      product: product,
      quantity: json['quantity'],
    );
  }
}
