import 'dart:async';

import 'package:get/get.dart';
import 'package:hosco_shop_2/models/cart_item.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:hosco_shop_2/models/product.dart';
import 'package:hosco_shop_2/models/transaction.dart';
import 'package:hosco_shop_2/networking/api/transaction_api_service.dart';
// import 'package:hosco_shop_2/networking/api/transaction_api_service.dart';
import '../models/customer.dart';
import '../networking/api/product_api_service.dart';
// import '../services/local_db_service.dart';
import '../utils/sl.dart';

class CartController extends GetxController {
  final apiService = sl.get<ProductApiService>();
  // final transactionService = TransactionApiService.instance;
  var cartItems = <CartItem>[].obs;
  var searchQuery = ''.obs;
  var searchSuggestions = <Map<String, dynamic>>[].obs;
  var transactions = <CustomTransaction>[].obs;
  var discountUnitPercentage = false.obs;
  var discountAmount = 0.0.obs;
  var isBarcodeOn = true.obs;
  var isShowSuggestion = false.obs;
  Set<String> productIdSet = <String>{}.obs;
  var customer = Customer(name: "Khách lẻ").obs;
  // final DatabaseService databaseService = DatabaseService.instance;
  Timer? debouncer;
  final int pageSize = 6; // Items per page
  final TransactionApiService transactionApiService =
      TransactionApiService.instance;

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    await searchProduct('');
    // fetchTransactions();
  }

  void debounce(Callback callback,
      {Duration duration = const Duration(milliseconds: 600)}) {
    if (debouncer != null) {
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
          unitPrice: product.retailPrice);
    } else {
      productIdSet.add(product.id);
      cartItems.add(CartItem(
          product: product, quantity: 1, unitPrice: product.retailPrice));
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
            unitPrice: product.retailPrice);
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
    var product = await apiService.getProductById(suggestion['id']);
    if (product != null) addToCart(product);
  }

  Future<void> searchProduct(String query, {bool resetPage = true}) async {
    debounce(() async {
      searchQuery.value = query;

      final searchResult = await apiService.searchProducts(query);
      // final searchResult = [];
      searchSuggestions.assignAll(searchResult);
    });
  }

  void clearSearchQuery() {
    searchQuery.value = '';
    // searchSuggestions.clear();
  }

  double finalPrice() {
    if (!discountUnitPercentage.value) {
      return getTotalPrice() - discountAmount.value;
    } else {
      return getTotalPrice() - getTotalPrice() * discountAmount.value / 100;
    }
  }

  int getQuantity(Product product) {
    int index = cartItems.indexWhere((item) => item.product.id == product.id);
    return index != -1 ? cartItems[index].quantity : 0;
  }

  Future<Map<String, dynamic>> completeTransaction(String paymentMethod) async {
    if (cartItems.isEmpty) return {"success": false, "error": "Cart is empty!"};

    // Create a new transaction
    // var newTransaction = CustomTransaction(
    //     items: List.from(cartItems),
    //     totalAmount: finalPrice(),
    //     date: DateTime.now(),
    //     paymentMethod: paymentMethod);

    // await databaseService.insertTransaction(newTransaction);

    // Clear cart after payment

    // Prepare sale items list
    List<Map<String, dynamic>> saleItems = cartItems
        .map((item) => {
              "productId": item.product.id,
              "quantity": item.quantity,
              "unitPrice": item.unitPrice
            })
        .toList();

    // Prepare request body
    Map<String, dynamic> requestBody = {
      "customerId": customer.value.id ?? 2, // Default to 0 if no customer ID
      "warehouseId": "my-dinh-02",
      "paymentMethod": paymentMethod,
      "saleItems": saleItems,
      "discount": discountAmount.value,
      "discountUnit": discountUnitPercentage.value ? "percentage" : "vnd",
      "vat": 7.5, // Assuming VAT is fixed at 7.5%
      "saleNote": "Priority customer, expedited shipping requested"
    };

    print(requestBody);

    final result =
        await transactionApiService.createSaleTransaction(requestBody);

    if (result['success']) {
      cartItems.clear();
      productIdSet.clear();
      discountAmount.value = 0.0;
    }
    return result;
  }

  void toggleBarcode() {
    isBarcodeOn.value = !isBarcodeOn.value;
  }

  void updateSingleDiscount(
      Product product, double discount, String discountUnit) {
    int index = cartItems.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      cartItems[index] = CartItem(
          unitPrice: product.retailPrice,
          product: cartItems[index].product,
          quantity: cartItems[index].quantity,
          discount: discount,
          discountUnit: discountUnit);
      cartItems.refresh(); // Update UI
    }
  }

  CartItem getCartItem(Product product) {
    return cartItems.firstWhere((item) => item.product.id == product.id,
        orElse: () =>
            CartItem(product: product, unitPrice: product.retailPrice));
  }

  double getTotalPrice() {
    return cartItems.fold(
        0.0, (sum, item) => sum + (item.getFinalPrice() * item.quantity));
  }
}
