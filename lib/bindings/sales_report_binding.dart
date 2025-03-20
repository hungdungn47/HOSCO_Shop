import 'package:get/get.dart';
import 'package:hosco_shop_2/controllers/sales_report_controller.dart';

class SalesReportBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<SalesReportController>(() => SalesReportController());
  }
}
