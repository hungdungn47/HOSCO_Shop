import 'package:hosco_shop_2/models/product.dart';

abstract class ApiService {
  Future<List<Product>> getAllProducts();
  Future<Product> getProductById(String productId);
  Future<void> createProduct(Product productData);
  Future<void> updateProduct(Product productData);
  Future<void> deleteProduct(String productId);
}