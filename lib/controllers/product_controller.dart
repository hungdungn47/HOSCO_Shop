import 'package:get/get.dart';
import 'package:hosco_shop_2/networking/data/fakeProducts.dart';
import '../models/product.dart';

class ProductController extends GetxController {
  var allProducts = <Product>[].obs;
  var selectedProduct = Rxn<Product>();
  var filteredProducts = <Product>[].obs;
  var searchQuery = ''.obs;
  var searchSuggestions = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
    filteredProducts.assignAll(allProducts);
  }

  void loadProducts() {
    allProducts.assignAll(mockProducts);
  }

  void setSelectedProduct(Product product) {
    selectedProduct.value = product;
  }

  void addProduct(Product product) {
    print('Adding product ${product.name} with image ${product.imageUrl}');
    allProducts.add(product);
    _applyFilters();
  }

  void updateProduct(Product updatedProduct) {
    int index = allProducts.indexWhere((p) => p.id == updatedProduct.id);
    if (index != -1) {
      allProducts[index] = updatedProduct;
      selectedProduct.value = updatedProduct;
    }
    _applyFilters();
  }

  void deleteProduct() {
    allProducts.removeWhere((p) => p.id == selectedProduct.value?.id);
    selectedProduct.value = null;
    _applyFilters();
  }

  void searchProduct(String query) {
    searchQuery.value = query.toLowerCase();

    // Generate suggestions based on input
    if (query.isNotEmpty) {
      searchSuggestions.value = allProducts
          .where((p) => p.name.toLowerCase().contains(searchQuery.value))
          .map((p) => p.name)
          .toSet()
          .toList();
    } else {
      searchSuggestions.clear();
    }

    _applyFilters();
  }

  void selectSuggestion(String suggestion) {
    searchQuery.value = suggestion;
    searchProduct(suggestion); // Perform search with the selected suggestion
    searchSuggestions.clear(); // Hide suggestions
  }

  void _applyFilters() {
    var filtered = allProducts.where((p) => p.name.toLowerCase().contains(searchQuery.value)).toList();
    filteredProducts.assignAll(filtered);
  }
}