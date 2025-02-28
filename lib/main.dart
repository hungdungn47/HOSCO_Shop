import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hosco_shop_2/controllers/cart_controller.dart';
import 'package:hosco_shop_2/controllers/product_controller.dart';
import 'package:hosco_shop_2/networking/api/api_service.dart';
import 'package:hosco_shop_2/networking/api/api_service_impl.dart';
import 'package:hosco_shop_2/utils/theme.dart';
import 'package:hosco_shop_2/views/cart/cart.dart';
import 'package:hosco_shop_2/views/history/transaction_history.dart';
import 'package:hosco_shop_2/views/products/add_product.dart';
import 'package:hosco_shop_2/views/products/products_management.dart';
import 'package:hosco_shop_2/views/report/sales_report.dart';
import 'package:hosco_shop_2/utils/sl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();
  runApp(const MyApp());
}

Future<void> setup() async {
  sl.registerSingleton<ApiService>(ApiServiceImpl.instance);
  Get.put(ProductController());
  Get.put(CartController());
  Get.put(ApiServiceImpl());
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
      getPages: [
        GetPage(name: '/products', page: () => ProductsManagement()),
        GetPage(name: '/add-product', page: () => CreateProductScreen()),
        GetPage(name: '/cart', page: () => Cart()),
        GetPage(name: '/history', page: () => TransactionHistoryScreen()),
        GetPage(name: '/report', page: () => SalesReport())
      ],
    );
  }
}