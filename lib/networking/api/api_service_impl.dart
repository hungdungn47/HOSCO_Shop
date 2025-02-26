import 'package:hosco_shop_2/networking/api/api_service.dart';

class ApiServiceImpl implements ApiService {
  static final ApiServiceImpl _instance = ApiServiceImpl._internal();

  ApiServiceImpl._internal();
  static ApiServiceImpl get instance => _instance;
  @override
  Future<List> getProducts() async {
    print('getting products');
    return [];
  }
}