import 'package:hosco_shop_2/models/product.dart';
import 'package:hosco_shop_2/networking/api/api_service.dart';
import 'package:hosco_shop_2/networking/data/fakeProducts.dart';
import 'package:hosco_shop_2/services/local_db_service.dart';

class ApiServiceImpl implements ApiService {
  static final ApiServiceImpl _instance = ApiServiceImpl._internal();

  ApiServiceImpl._internal();
  static ApiServiceImpl get instance => _instance;

  ApiServiceImpl();

  final DatabaseService _productService = DatabaseService.instance;

  @override
  Future<List<Product>> getAllProducts() async {
    final productList = await _productService.getAllProducts();
    return productList;
  }

  @override
  Future<void> createProduct(Product productData) async {
    // TODO: implement createProduct
    await _productService.createProduct(productData);
  }

  @override
  Future<void> deleteProduct(String productId) async {
    // TODO: implement deleteProduct
    await _productService.deleteProduct(int.parse(productId));
  }

  @override
  Future<void> updateProduct(Product productData) async {
    // TODO: implement updateProduct
    await _productService.updateProduct(productData);
  }

  @override
  Future<Product?> getProductById(String productId) async {
    // TODO: implement getProductById
    final product = await _productService.getProductById(int.parse(productId));
    return product;
  }

}