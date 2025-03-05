import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hosco_shop_2/models/cartItem.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:hosco_shop_2/models/product.dart';
import 'package:hosco_shop_2/models/transaction.dart';
import 'package:hosco_shop_2/networking/data/fakeProducts.dart';
import 'package:uuid/uuid.dart';

import '../networking/api/api_service.dart';
import '../services/products_service.dart';
import '../utils/sl.dart';

class CartController extends GetxController {
  final apiService = sl.get<ApiService>();
  var cartItems = <CartItem>[].obs;
  var searchQuery = ''.obs;
  var searchSuggestions = <Map<String, dynamic>>[].obs;
  var transactions = <CustomTransaction>[].obs;
  var discountUnitPercentage = false.obs;
  var discountAmount = 0.0.obs;
  var isBarcodeOn = true.obs;
  var isShowSuggestion = false.obs;
  Set<int> productIdSet = <int>{}.obs;
  final ProductService productService = ProductService.instance;
  Timer? debouncer;
  final int pageSize = 6; // Items per page


  @override
  void onInit() async {
    super.onInit();
    await searchProduct('');
    print('Hello');
  }
  void debounce(Callback callback, {Duration duration = const Duration(milliseconds: 600)}) {
    if(debouncer != null) {
      debouncer!.cancel();
    }

    debouncer = Timer(duration, callback);
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

  Future<void> selectSuggestion(Map<String, dynamic> suggestion) async {
    var product = await productService.getProductById(suggestion['id']);
    if(product != null) addToCart(product);
  }

  // void searchProduct(String query) {
  //   searchQuery.value = query.toLowerCase();
  //   if (query.isNotEmpty) {
  //     searchSuggestions.value = allProducts
  //         .where((p) => p.name.toLowerCase().contains(searchQuery.value))
  //         .map((p) => p.name)
  //         .toSet()
  //         .toList();
  //   } else {
  //     searchSuggestions.clear();
  //   }
  // }

  Future<void> searchProduct(String query, {bool resetPage = true}) async {
    debounce(() async {
      searchQuery.value = query;

      final searchResult = await productService.searchProductsPaginated(
        query: query,
        page: 1,
        limit: pageSize,
      );
      searchSuggestions.assignAll(searchResult.map((p) => {
        "name": p.name,
        "id": p.id
      }).toList());
    });
  }

  // void loadNextPage() {
  //   if (hasMoreData.value && !isLoading.value) {
  //     page.value++;
  //     searchProduct(searchQuery.value, resetPage: false);
  //   }
  // }

  void clearSearchQuery() {
    searchQuery.value = '';
    // searchSuggestions.clear();
  }

  double get totalPrice =>
      cartItems.fold(0, (sum, item) => sum + (item.product.price * item.quantity));
  double finalPrice() {
    if(!discountUnitPercentage.value) {
      return totalPrice - discountAmount.value;
    } else {
      return totalPrice  - totalPrice * discountAmount.value / 100;
    }
  }
  int getQuantity(Product product) {
    int index = cartItems.indexWhere((item) => item.product.id == product.id);
    return index != -1 ? cartItems[index].quantity : 0;
  }

  void completeTransaction(String paymentMethod) {
    if (cartItems.isEmpty) return;

    // Create a new transaction
    var newTransaction = CustomTransaction(
      items: List.from(cartItems),
      totalAmount: finalPrice(),
      date: DateTime.now(),
      paymentMethod: paymentMethod
    );

    // Add to transaction history
    transactions.insert(0, newTransaction);

    // Clear cart after payment
    cartItems.clear();
    productIdSet.clear();
    discountAmount.value = 0.0;
  }

  void toggleBarcode() {
    isBarcodeOn.value = !isBarcodeOn.value;
  }
}
