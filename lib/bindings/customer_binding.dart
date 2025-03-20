import 'package:get/get.dart';
import 'package:hosco_shop_2/controllers/customer_controller.dart';

class CustomerBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<CustomerController>(() => CustomerController());
  }
}
