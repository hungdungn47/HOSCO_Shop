import 'package:get/get.dart';
import 'package:hosco_shop_2/models/cartItem.dart';
import 'package:hosco_shop_2/models/product.dart';
import 'package:hosco_shop_2/models/transaction.dart';
import 'package:hosco_shop_2/networking/data/fakeProducts.dart';
import 'package:uuid/uuid.dart';

import '../networking/api/api_service.dart';
import '../utils/sl.dart';

class CartController extends GetxController {
  final apiService = sl.get<ApiService>();
  var allProducts = <Product>[].obs;
  var cartItems = <CartItem>[].obs;
  var searchQuery = ''.obs;
  var searchSuggestions = <String>[].obs;
  var transactions = <Transaction>[].obs;
  Set<int> productIdSet = <int>{}.obs;

  @override
  void onInit() async {
    super.onInit();
    final productList = await apiService.getAllProducts();
    allProducts.assignAll(productList);
  }

  void addToCart(Product product) {
    int index = cartItems.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      cartItems[index] = CartItem(
        product: cartItems[index].product,
        quantity: cartItems[index].quantity + 1,
      );
    } else {
      productIdSet.add(product.id);
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
        productIdSet.remove(product.id);
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

  void completeTransaction() {
    if (cartItems.isEmpty) return;

    // Create a new transaction
    var newTransaction = Transaction(
      id: Uuid().v4(), // Generate unique ID
      items: List.from(cartItems),
      totalAmount: totalPrice,
      date: DateTime.now(),
    );

    // Add to transaction history
    transactions.insert(0, newTransaction);

    // Clear cart after payment
    cartItems.clear();
    productIdSet.clear();
  }
}
