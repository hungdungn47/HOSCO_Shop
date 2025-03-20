import 'package:get/get.dart';
import 'package:hosco_shop_2/controllers/purchase_controller.dart';

class PurchaseBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<PurchaseController>(() => PurchaseController());
  }
}
