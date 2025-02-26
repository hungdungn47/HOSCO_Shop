import 'package:hosco_shop_2/networking/api/api_service.dart';

class ApiServiceImpl implements ApiService {
  @override
  Future<List> getProducts() async {
    print('getting products');
    return [];
  }
}