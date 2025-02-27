import 'package:get/get.dart';
import 'package:hosco_shop_2/models/cartItem.dart';
import 'package:hosco_shop_2/models/product.dart';
import 'package:hosco_shop_2/networking/data/fakeProducts.dart';

class CartController extends GetxController {
  var allProducts = <Product>[].obs;
  var cartItems = <CartItem>[].obs;
  var searchQuery = ''.obs;
  var searchSuggestions = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    allProducts.assignAll(mockProducts);
  }

  void addToCart(Product product) {
    int index = cartItems.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      cartItems[index] = CartItem(
        product: cartItems[index].product,
        quantity: cartItems[index].quantity + 1,
      );
    } else {
      cartItems.add(CartItem(product: product, quantity: 1));
    }
    cartItems.refresh(); // ✅ Notify GetX of the change
  }

  void removeFromCart(Product product) {
    int index = cartItems.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      if (cartItems[index].quantity > 1) {
        cartItems[index] = CartItem(
          product: cartItems[index].product,
          quantity: cartItems[index].quantity - 1,
        );
      } else {
        cartItems.removeAt(index);
      }
    }
    cartItems.refresh(); // ✅ Notify GetX of the change
  }

  void clearCartItems() {
    cartItems.clear();
  }

  void selectSuggestion(String suggestion) {
    var filteredProducts = allProducts.where((p) => p.name == suggestion).toList();
    if (filteredProducts.isNotEmpty) {
      addToCart(filteredProducts[0]);
    } else {
      print("No product found with the name: $suggestion");
    }
  }

  void searchProduct(String query) {
    searchQuery.value = query.toLowerCase();
    if (query.isNotEmpty) {
      searchSuggestions.value = allProducts
          .where((p) => p.name.toLowerCase().contains(searchQuery.value))
          .map((p) => p.name)
          .toSet()
          .toList();
    } else {
      searchSuggestions.clear();
    }
  }

  void clearSearchQuery() {
    searchQuery.value = '';
    searchSuggestions.clear();
  }

  double get totalPrice =>
      cartItems.fold(0, (sum, item) => sum + (item.product.price * item.quantity));

  int getQuantity(Product product) {
    int index = cartItems.indexWhere((item) => item.product.id == product.id);
    return index != -1 ? cartItems[index].quantity : 0;
  }
}
