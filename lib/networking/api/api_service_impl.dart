import 'package:hosco_shop_2/models/product.dart';
import 'package:hosco_shop_2/networking/api/api_service.dart';
import 'package:hosco_shop_2/networking/data/fakeProducts.dart';
import 'package:hosco_shop_2/services/database_service.dart';

class ApiServiceImpl implements ApiService {
  static final ApiServiceImpl _instance = ApiServiceImpl._internal();

  ApiServiceImpl._internal();
  static ApiServiceImpl get instance => _instance;

  ApiServiceImpl();

  final DatabaseService _databaseService = DatabaseService.instance;

  @override
  Future<List<Product>> getAllProducts() async {
    final productList = await _databaseService.getAllProducts();
    return productList;
  }

  @override
  Future<void> createProduct(Product productData) async {
    // TODO: implement createProduct
    await _databaseService.createProduct(productData);
  }

  @override
  Future<void> deleteProduct(String productId) async {
    // TODO: implement deleteProduct
    await _databaseService.deleteProduct(int.parse(productId));
  }

  @override
  Future<void> updateProduct(Product productData) async {
    // TODO: implement updateProduct
    await _databaseService.updateProduct(productData);
  }

  @override
  Future<Product> getProductById(String productId) async {
    // TODO: implement getProductById
    Product product = mockProducts.firstWhere((p) => p.id == productId);
    return product;
  }

}