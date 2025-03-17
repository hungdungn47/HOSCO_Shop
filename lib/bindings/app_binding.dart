import 'package:get/get.dart';
import 'package:hosco_shop_2/controllers/cart_controller.dart';
import 'package:hosco_shop_2/controllers/customer_controller.dart';
import 'package:hosco_shop_2/controllers/product_controller.dart';
import 'package:hosco_shop_2/networking/api/product_api_service.dart';
import 'package:hosco_shop_2/networking/api/product_api_service_impl.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductApiService>(() => ProductApiServiceImpl.instance);
    Get.lazyPut<ProductController>(() => ProductController());
    Get.lazyPut<CartController>(() => CartController());
    Get.lazyPut<CustomerController>(() => CustomerController());
  }
}
