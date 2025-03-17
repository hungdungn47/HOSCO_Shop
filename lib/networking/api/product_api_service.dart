import 'package:hosco_shop_2/models/product.dart';

abstract class ProductApiService {
  Future<List<Product>> getAllProducts({String? query, List<String>? categories, String? page, String? pageSize});
  Future<List<dynamic>> getAllCategories();
  Future<Product?> getProductById(String productId);
  Future<void> createProduct(Product productData);
  Future<void> updateProduct(Product productData);
  Future<void> deleteProduct(String productId);
  // Search products, return only name and ID for fast and light data transferring
  Future<List<Map<String, dynamic>>> searchProducts(String searchQuery);
  Future<List<dynamic>> searchAutocomplete(String query);
  Future<List<dynamic>> searchSuggestion(String query);
}