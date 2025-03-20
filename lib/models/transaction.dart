import 'package:hosco_shop_2/models/customer.dart';
import 'package:hosco_shop_2/models/partner.dart';
import 'package:hosco_shop_2/models/product.dart';
import 'package:hosco_shop_2/networking/api/partner_api_service.dart';

import './cart_item.dart';

class CustomTransaction {
  final int? id;
  final List<CartItem> items;
  final double? totalAmount;
  final DateTime? transactionDate;
  final String? type;
  final double? vat;
  final String? paymentMethod;
  final PartnerApiService partnerApiService = PartnerApiService.instance;
  Partner? partner;

  CustomTransaction({
    this.vat,
    this.id,
    required this.items,
    required this.totalAmount,
    required this.transactionDate,
    this.type = "sale",
    this.paymentMethod = "cash",
    this.partner,
  });

  // Convert Transaction to JSON (for storage)
  Map<String, dynamic> toJson() => {
        // "id": id,
        "totalAmount": totalAmount,
        "type": type,
        "paymentMethod": paymentMethod,
        "partner": partner?.id
      };

  // Convert JSON to Transaction
  factory CustomTransaction.fromJson(Map<String, dynamic> json) {
    List<CartItem> items = [];
    for (Map<String, dynamic> item in json['items']) {
      items.add(CartItem.fromJson(item, Product.fromJson(item['product'])));
    }
    for (CartItem item in items) {
      print('Item ${item.product.name}');
    }
    return CustomTransaction(
        id: json['id'],
        items: items,
        totalAmount: json['totalAmount'].toDouble(),
        transactionDate: DateTime.parse(json['transactionDate']),
        type: json['type'],
        paymentMethod: json['paymentMethod'],
        partner: Partner.fromJson(json['partner']));
  }
}
