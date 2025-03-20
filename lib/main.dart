import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hosco_shop_2/bindings/app_binding.dart';
import 'package:hosco_shop_2/bindings/purchase_binding.dart';
import 'package:hosco_shop_2/bindings/sales_report_binding.dart';
import 'package:hosco_shop_2/networking/api/product_api_service.dart';
import 'package:hosco_shop_2/networking/api/product_api_service_impl.dart';
import 'package:hosco_shop_2/utils/theme.dart';
import 'package:hosco_shop_2/views/cart/cart.dart';
import 'package:hosco_shop_2/views/customers/customer_management.dart';
import 'package:hosco_shop_2/views/history/transaction_history.dart';
import 'package:hosco_shop_2/views/products/add_product.dart';
import 'package:hosco_shop_2/views/products/products_management.dart';
import 'package:hosco_shop_2/views/products/purchase_screen.dart';
import 'package:hosco_shop_2/views/report/sales_report.dart';
import 'package:hosco_shop_2/utils/sl.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();
  runApp(const MyApp());
}

Future<void> setup() async {
  sl.registerSingleton<ProductApiService>(ProductApiServiceImpl.instance);

  // Lazy load controllers
  // Get.lazyPut(() => ProductController());
  // Get.lazyPut(() => CartController());
  // Get.lazyPut(() => CustomerController());

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  requestStoragePermission();
}

void requestStoragePermission() async {
  // Check if the platform is not web, as web has no permissions
  if (!kIsWeb) {
    // Request storage permission
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    // Request camera permission
    var cameraStatus = await Permission.camera.status;
    if (!cameraStatus.isGranted) {
      await Permission.camera.request();
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,
      initialRoute: '/products',
      initialBinding: AppBinding(),
      getPages: [
        GetPage(name: '/products', page: () => ProductsManagement()),
        GetPage(name: '/add-product', page: () => CreateProductScreen()),
        GetPage(
            name: '/purchase',
            page: () => PurchasingProductScreen(),
            binding: PurchaseBinding()),
        GetPage(name: '/cart', page: () => Cart()),
        GetPage(
            name: '/history',
            page: () => TransactionHistoryScreen(),
            binding: SalesReportBinding()),
        GetPage(
            name: '/report',
            page: () => SalesReport(),
            binding: SalesReportBinding()),
        GetPage(name: '/customers', page: () => CustomerManagementScreen()),
        // GetPage(name: '/pdf-page', page: () => PdfPage())
      ],
    );
  }
}
