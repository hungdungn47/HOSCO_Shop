import 'dart:async';

import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:hosco_shop_2/models/supplier.dart';
import '../models/product.dart';
import '../networking/api/product_api_service.dart';
import '../utils/sl.dart';

class ProductController extends GetxController {
  final apiService = sl.get<ProductApiService>();
  var allProducts = <Product>[].obs;
  var selectedProduct = Rxn<Product>();
  // var displayedProducts = <Product>[].obs;
  var searchQuery = ''.obs;
  final RxBool isFetching = false.obs;
  var searchSuggestions = <String>[].obs;
  var selectedCategories = <String>[].obs;
  var allCategories = <String>[].obs;
  List<Supplier>? allSuppliers;
  // final DatabaseService productService = DatabaseService.instance;
  Timer? debouncer;
  // final log = Logger('ProductControllerLogger');

  // Pagination variables
  var isLoading = false.obs;
  var page = 1.obs;
  final int pageSize = 10; // Items per page
  var hasMoreData = true.obs; // Check if more data is available

  @override
  void onInit() async {
    super.onInit();
    await getProducts('');
    try {
      await fetchCategories();
    } catch (error) {
      Get.snackbar("Network error while getting categories", error.toString());
    }
    selectedCategories.assignAll(allCategories);
  }

  Future<void> fetchCategories() async {
    final categories = await apiService.getAllCategories();
    allCategories.assignAll(categories.map((c) => c.toString()));
  }

  void debounce(Callback callback,
      {Duration duration = const Duration(milliseconds: 300)}) {
    if (debouncer != null) {
      debouncer!.cancel();
    }
    debouncer = Timer(duration, callback);
  }

  Future<Product?> getProductById(String productId) async {
    final product = await apiService.getProductById(productId);
    return product;
  }

  void setSelectedProduct(Product product) {
    selectedProduct.value = product;
  }

  Future<void> addProduct(Product product) async {
    try {
      await apiService.createProduct(product);
    } catch (error) {
      rethrow;
    }
    refreshProducts();
  }

  Future<void> updateProduct(Product updatedProduct) async {
    int index = allProducts.indexWhere((p) => p.id == updatedProduct.id);
    if (index != -1) {
      allProducts[index] = updatedProduct;
      selectedProduct.value = updatedProduct;
    }
    await apiService.updateProduct(updatedProduct);
    refreshProducts();
  }

  void deleteProduct() async {
    final product = selectedProduct.value;
    if (product == null) return;

    try {
      // await productService.deleteProduct(product.id); // Ensure product is deleted first
      allProducts.removeWhere((p) => p.id == product.id);
      refreshProducts();
      selectedProduct.value = null;
    } catch (e) {
      print("Error deleting product: $e");
    }
  }

  Future<void> searchProducts(String newQuery) async {
    debounce(() async {
      searchQuery.value = newQuery;
      final suggestions = await apiService.searchSuggestion(searchQuery.value);
      searchSuggestions.assignAll(suggestions.map((s) => s['name'].toString()));
    });
  }

  Future<void> getProducts(String query, {bool resetPage = true}) async {
    print('Controller - getting products');
    if (resetPage) {
      page.value = 1; // Reset to first page
      hasMoreData.value = true; // Reset data flag
      allProducts.clear();
    }

    if (!hasMoreData.value || isLoading.value) return;

    isLoading.value = true;
    if (page.value == 1) {
      isFetching.value = true;
    }

    searchQuery.value = query;

    try {
      final searchResult = await apiService.getAllProducts(
          query: searchQuery.value,
          page: page.value.toString(),
          pageSize: pageSize.toString(),
          categories: selectedCategories);

      if (searchResult.length < pageSize && page.value >= 1) {
        hasMoreData.value = false;
      }

      if (page.value == 1) {
        allProducts.assignAll(searchResult);
      } else {
        allProducts.addAll(searchResult);
      }
    } catch (error) {
      print('error');
      // Get.snackbar("Network error while getting products", error.toString());
    } finally {
      print('finally');
      isLoading.value = false;
      isFetching.value = false;
    }

    // refreshProducts();
  }

  Future<void> getProductDetails(String productId) async {
    final tmp = await apiService.getProductById(productId);
    selectedProduct.value = tmp;
  }

  void loadNextPage() {
    if (hasMoreData.value && !isLoading.value) {
      page.value++;
      getProducts(searchQuery.value, resetPage: false);
    }
  }

  void selectSuggestion(String suggestion) {
    searchQuery.value = suggestion;
    getProducts(suggestion); // Perform search with the selected suggestion
    searchSuggestions.clear(); // Hide suggestions
  }

  void refreshProducts() async {
    isFetching.value = true;
    final response =
        await apiService.getAllProducts(categories: selectedCategories);
    allProducts.assignAll(response);
    isFetching.value = false;
  }
}
