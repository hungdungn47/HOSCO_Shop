import 'package:hosco_shop_2/models/product.dart';
import 'package:hosco_shop_2/models/supplier.dart';
import 'package:hosco_shop_2/networking/api/product_api_service.dart';
// import 'package:hosco_shop_2/networking/data/fakeProducts.dart';
import 'package:hosco_shop_2/services/local_db_service.dart';
import 'package:hosco_shop_2/networking/http_client.dart';
import 'package:hosco_shop_2/utils/formatters.dart';

class ProductApiServiceImpl implements ProductApiService {
  static final ProductApiServiceImpl _instance = ProductApiServiceImpl._internal();

  ProductApiServiceImpl._internal();
  static ProductApiServiceImpl get instance => _instance;

  ProductApiServiceImpl();

  final DatabaseService _productService = DatabaseService.instance;

  @override
  Future<List<Product>> getAllProducts({
    String? query,
    List<String>? categories,
    String? page,
    String? pageSize,
  }) async {
    // Prepare query parameters
    final Map<String, dynamic> queryParams = {};

    // Only add non-null parameters
    if (query != null) queryParams['q'] = query;
    if (page != null) queryParams['page'] = page;
    if (pageSize != null) queryParams['pageSize'] = pageSize;

    // Add categories if they exist
    if (categories != null && categories.isNotEmpty) {
      queryParams['category'] = concatenateAndEncodeStrings(categories);
    }

    // Make the API call with appropriate parameters
    final response = await HttpClient.get(
      endPoint: '/api/v1/products',
      queryParams: queryParams.isEmpty ? null : queryParams,
    );

    // Parse the response
    final productList = response?['products'];
    if (productList == null || productList is! List) {
      throw Exception("Invalid response format");
    }

    // Convert JSON to Product objects
    return productList.map<Product>((json) => Product.fromJson(json)).toList();
  }
  @override
  Future<void> createProduct(Product productData) async {
    await HttpClient.post(endPoint: '/api/v1/products');
  }

  @override
  Future<void> deleteProduct(String productId) async {
    await HttpClient.delete(endPoint: '/api/v1/products/$productId');
  }

  @override
  Future<void> updateProduct(Product productData) async {
    await HttpClient.put(endPoint: '/api/v1/products/${productData.id}', body: productData);
  }

  @override
  Future<Product?> getProductById(String productId) async {
    final productData = await HttpClient.get(endPoint: '/api/v1/products/$productId');
    return Product.fromJson(productData?['product']);
  }

  @override
  Future<List<Map<String, dynamic>>> searchProducts(String searchQuery) async {
    final response = await HttpClient.get(endPoint: '/api/v1/products', queryParams: {"q": searchQuery});
    return response?['products'];
  }

  @override
  Future<List<String>> getAllCategories() async {
    final response = await HttpClient.get(endPoint: '/api/v1/products/category');
    return response?['products'];
  }

}