import 'package:get/get.dart';
import 'package:hosco_shop_2/controllers/cart_controller.dart';
// import 'package:hosco_shop_2/controllers/customer_controller.dart';
import 'package:hosco_shop_2/controllers/product_controller.dart';
// import 'package:hosco_shop_2/controllers/purchase_controller.dart';
import 'package:hosco_shop_2/networking/api/product_api_service.dart';
import 'package:hosco_shop_2/networking/api/product_api_service_impl.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ProductApiService>(ProductApiServiceImpl.instance);
    Get.put<ProductController>(ProductController());
    Get.put<CartController>(CartController());
    // Get.put<CustomerController>(CustomerController());
    // Get.put<PurchaseController>(PurchaseController());
  }
}
