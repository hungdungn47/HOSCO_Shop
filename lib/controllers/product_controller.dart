import 'package:get/get.dart';
import 'package:hosco_shop_2/networking/data/fakeProducts.dart';
import '../models/product.dart';

class ProductController extends GetxController {
  var products = <Product>[].obs; // Observable list of products
  var selectedProduct = Rxn<Product>();

  @override
  void onInit() {
    super.onInit();
    loadProducts(); // Load mock data when the controller initializes
  }

  void loadProducts() {
    products.assignAll(mockProducts); // Assign mock data to observable list
  }

  void setSelectedProduct(Product product) {
    selectedProduct.value = product; // Update selected product
  }

  void updateProduct(Product updatedProduct) {
    int index = products.indexWhere((p) => p.id == updatedProduct.id);
    if (index != -1) {
      products[index] = updatedProduct;
      selectedProduct.value = updatedProduct;
    }
  }

  void deleteProduct() {
    products.removeWhere((p) => p.id == selectedProduct.value?.id);
    selectedProduct.value = null;
  }
}