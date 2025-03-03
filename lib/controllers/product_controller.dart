import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:hosco_shop_2/networking/api/api_service_impl.dart';
import 'package:hosco_shop_2/networking/data/fakeProducts.dart';
import '../models/product.dart';
import '../networking/api/api_service.dart';
import '../utils/sl.dart';

class ProductController extends GetxController {
  final apiService = sl.get<ApiService>();
  var allProducts = <Product>[].obs;
  var selectedProduct = Rxn<Product>();
  var filteredProducts = <Product>[].obs;
  var searchQuery = ''.obs;
  var searchSuggestions = <String>[].obs;
  var selectedCategories = <String>[].obs;

  @override
  void onInit() async {
    super.onInit();
    await loadProducts();
    allProducts.forEach((product) {
      print('Id: ${product.id} - Name: ${product.name} \n');
    });
    filteredProducts.assignAll(allProducts);
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

  Future<void> loadProducts() async {
    final productList = await apiService.getAllProducts();
    allProducts.assignAll(productList);
  }

  void setSelectedProduct(Product product) {
    selectedProduct.value = product;
  }

  Future<void> addProduct(Product product) async {
    await apiService.createProduct(product);
    allProducts.add(product);
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
    var filtered = allProducts.where((p) {
      bool matchesSearch = p.name.toLowerCase().contains(searchQuery.value);
      bool matchesCategory = selectedCategories.isEmpty || selectedCategories.contains(p.category);
      return matchesSearch && matchesCategory;
    }).toList();
    filteredProducts.assignAll(filtered);
  }
}