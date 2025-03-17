import 'dart:convert';

import 'package:hosco_shop_2/models/product.dart';
import 'package:hosco_shop_2/models/supplier.dart';
import 'package:hosco_shop_2/networking/api/product_api_service.dart';
import 'package:hosco_shop_2/networking/config.dart';
// import 'package:hosco_shop_2/networking/data/fakeProducts.dart';
import 'package:hosco_shop_2/services/local_db_service.dart';
import 'package:hosco_shop_2/networking/http_client.dart';
import 'package:hosco_shop_2/utils/formatters.dart';
import 'package:http/http.dart' as http;

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
    if (query != null && query.trim() != "") queryParams['q'] = query;
    if (page != null) queryParams['page'] = page;
    if (pageSize != null) queryParams['pageSize'] = pageSize;

    // Add categories if they exist
    if (categories != null && categories.isNotEmpty) {
      queryParams['category'] = concatenateAndEncodeStrings(categories);
    }

    // Make the API call with appropriate parameters
    final response = await http.get(
      Uri.http(Config.baseUrl, '/api/v1/products', queryParams)
      // queryParams: queryParams.isEmpty ? null : queryParams,
    );


    final result = json.decode(utf8.decode(response.bodyBytes));
    // Parse the response
    final productList = result['products'];
    if (productList == null) {
      throw Exception("Invalid response format");
    }

    // Convert JSON to Product objects
    return productList.map<Product>((json) => Product.fromJson(json)).toList();
  }
  @override
  Future<void> createProduct(Product productData) async {
    final response = await HttpClient.post(endPoint: '/api/v1/products', body: productData);
    print('Create product response:${jsonEncode(response)}');
    if(response?["message"] == "Failed to create product") {
      throw Exception(response?["error"]);
    }
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
  Future<List<dynamic>> getAllCategories() async {
    final response = await HttpClient.get(endPoint: '/api/v1/products/category');
    return response?['categories'];
  }

  @override
  Future<List<dynamic>> searchAutocomplete(String query) async {
    final response = await HttpClient.get(endPoint: '/api/v1/products/autocomplete', queryParams: {"q": query});

    return response?['result'];
  }

  @override
  Future<List<dynamic>> searchSuggestion(String query) async {
    final response = await HttpClient.get(endPoint: '/api/v1/products/search', queryParams: {"q": query});

    return response?['products'];
  }
}