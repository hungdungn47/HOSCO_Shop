import 'package:hosco_shop_2/models/transaction.dart';
import 'package:hosco_shop_2/networking/http_client.dart';

class TransactionApiService {
  static final TransactionApiService _instance =
      TransactionApiService._internal();

  TransactionApiService._internal();
  static TransactionApiService get instance => _instance;
  TransactionApiService();

  Future<List<CustomTransaction>> getAllTransactions() async {
    final response = await HttpClient.get(endPoint: '/api/v1/transactions');
    print('Getting transactions: ');
    print(response?['message']);
    return response?['result']['transactions']
        .map<CustomTransaction>((json) => CustomTransaction.fromJson(json))
        .toList();
    // return [];
  }
}
