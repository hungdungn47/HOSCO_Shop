

import 'package:hosco_shop_2/models/customer.dart';
import 'package:hosco_shop_2/models/supplier.dart';

import '../networking/data/default_model.dart';
import './cart_item.dart';
import './product.dart';

class CustomTransaction {
  final int? id;
  final List<CartItem> items;
  final double totalAmount;
  final DateTime date;
  final String type;
  final String paymentMethod;
  Customer? customer;

  CustomTransaction({
    this.id,
    required this.items,
    required this.totalAmount,
    required this.date,
    this.type = "sale",
    this.paymentMethod = "cash",
    this.customer,
  });

  // Convert Transaction to JSON (for storage)
  Map<String, dynamic> toJson() => {
    "id": id,
    "totalAmount": totalAmount,
    "date": date.toIso8601String(),
    "type": type,
    "paymentMethod": paymentMethod,
    "customerId": customer?.id
  };

  // Convert JSON to Transaction
  factory CustomTransaction.fromJson(Map<String, dynamic> json, List<CartItem> items, Customer? customer) {
    return CustomTransaction(
      id: json['id'],
      items: items,
      totalAmount: json['totalAmount'],
      date: DateTime.parse(json['date']),
      type: json['type'],
      paymentMethod: json['paymentMethod'],
      customer: customer
    );
  }
}
