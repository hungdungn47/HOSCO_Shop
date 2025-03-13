import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:get_it/get_it.dart';
import 'package:hosco_shop_2/models/supplier.dart';
import 'package:hosco_shop_2/networking/api/product_api_service_impl.dart';
// import 'package:hosco_shop_2/networking/data/fakeProducts.dart';
import 'package:hosco_shop_2/services/local_db_service.dart';
import '../models/product.dart';
import '../networking/api/product_api_service.dart';
import '../utils/sl.dart';
import 'package:logging/logging.dart';

class ProductController extends GetxController {
  final apiService = sl.get<ProductApiService>();
  var allProducts = <Product>[].obs;
  var selectedProduct = Rxn<Product>();
  // var displayedProducts = <Product>[].obs;
  var searchQuery = ''.obs;
  var searchSuggestions = <String>[].obs;
  var selectedCategories = <String>[].obs;
  List<String>? allCategories;
  List<Supplier>? allSuppliers;
  // final DatabaseService productService = DatabaseService.instance;
  Timer? debouncer;
  // final log = Logger('ProductControllerLogger');

  // Pagination variables
  var isLoading = false.obs;
  var page = 1.obs;
  final int pageSize = 5; // Items per page
  var hasMoreData = true.obs; // Check if more data is available

  @override
  void onInit() async {
    super.onInit();
    await searchProduct('');
  }

  Future<void> fetchCategories() async {
    final categories = await apiService.getAllCategories();
      allCategories?.assignAll(categories);
  }

  void debounce(Callback callback, {Duration duration = const Duration(milliseconds: 600)}) {
    if(debouncer != null) {
      debouncer!.cancel();
    }

    debouncer = Timer(duration, callback);
  }

  Future<Product?> getProductById(String productId) async {
    final product = await apiService.getProductById(productId);
    return product;
  }

  bool isSelectedCategory(String category) {
    return selectedCategories.contains(category);
  }

  void addSelectedCategory(String newSelectedCategory) {
    if(selectedCategories.contains(newSelectedCategory)) {
      selectedCategories.remove(newSelectedCategory);
      _applyFilters();
      return;
    }
    selectedCategories.add(newSelectedCategory);
    _applyFilters();
  }

  void setSelectedProduct(Product product) {
    selectedProduct.value = product;
  }

  Future<void> addProduct(Product product) async {
    await apiService.createProduct(product);
    _applyFilters();
  }



  Future<void> updateProduct(Product updatedProduct) async {
    int index = allProducts.indexWhere((p) => p.id == updatedProduct.id);
    if (index != -1) {
      allProducts[index] = updatedProduct;
      selectedProduct.value = updatedProduct;
    }
    await apiService.updateProduct(updatedProduct);
    _applyFilters();
  }

  void deleteProduct() async {
    final product = selectedProduct.value;
    if (product == null || product.id == null) return;

    try {
      // await productService.deleteProduct(product.id); // Ensure product is deleted first
      allProducts.removeWhere((p) => p.id == product.id);
      _applyFilters();
      selectedProduct.value = null;
    } catch (e) {
      print("Error deleting product: $e");
    }
  }

  Future<void> refreshProductList() async {
    print('Refreshing');
    final data = await apiService.getAllProducts();
    allProducts.clear();
    allProducts.assignAll(data);
    // _applyFilters();

  }

  Future<void> searchProduct(String query, {bool resetPage = true}) async {
    debounce(() async {
      if (resetPage) {
        page.value = 1; // Reset to first page
        hasMoreData.value = true; // Reset data flag
        allProducts.clear();
      }

      if (!hasMoreData.value || isLoading.value) return;

      isLoading.value = true;
      searchQuery.value = query;

      final searchResult = await apiService.getAllProducts(
        query: searchQuery.value,
        page: page.value.toString(),
        pageSize: pageSize.toString(),
          categories: allCategories
      );

      if (searchResult.length < pageSize && page.value >= 1) {
        hasMoreData.value = false;
      }

      if (page.value == 1) {
        allProducts.assignAll(searchResult);
      } else {
        allProducts.addAll(searchResult);
      }

      // _applyFilters();
      isLoading.value = false;
    });
  }

  void loadNextPage() {
    if (hasMoreData.value && !isLoading.value) {
      page.value++;
      searchProduct(searchQuery.value, resetPage: false);
    }
  }

  // void selectSuggestion(String suggestion) {
  //   searchQuery.value = suggestion;
  //   searchProduct(suggestion); // Perform search with the selected suggestion
  //   searchSuggestions.clear(); // Hide suggestions
  // }

  void _applyFilters() async {
    final response = await apiService.getAllProducts(categories: allCategories);
    allProducts.assignAll(response);
  }
}