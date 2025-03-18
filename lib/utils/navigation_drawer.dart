import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyNavigationDrawer extends StatelessWidget {
  const MyNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xff2E4E6B),
      child: SingleChildScrollView(
        child: Column(
          children: [_buildHeader(), _buildMenuItems(context)],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 100, bottom: 30),
      child: Text(
        'HOSCO Shop',
        style: TextStyle(
            fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    final double iconSize = 30;
    final TextStyle whiteMedium = TextStyle(
        color: Colors.white, fontSize: 18, fontWeight: FontWeight.w300);
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          ListTile(
            leading: Image.asset(
              'assets/icons/shop_icon.png',
              height: iconSize,
              width: iconSize,
            ),
            title: Text(
              'Quản lý sản phẩm',
              style: whiteMedium,
            ),
            onTap: () {
              Navigator.pop(context);
              Get.offAndToNamed('/products');
            },
          ),
          ListTile(
            leading: Image.asset(
              'assets/icons/add_product_icon.png',
              height: iconSize,
              width: iconSize,
            ),
            title: Text(
              'Thêm sản phẩm',
              style: whiteMedium,
            ),
            onTap: () {
              Navigator.pop(context);
              Get.toNamed('/add-product');
            },
          ),
          ListTile(
            leading: Image.asset(
              'assets/icons/new_cart_icon.png',
              height: iconSize,
              width: iconSize,
            ),
            title: Text(
              'Đơn hàng mới',
              style: whiteMedium,
            ),
            onTap: () {
              Navigator.pop(context);
              Get.offAndToNamed('/cart');
            },
          ),
          ListTile(
            leading: Image.asset(
              'assets/icons/history_icon.png',
              height: iconSize,
              width: iconSize,
            ),
            title: Text(
              'Lịch sử giao dịch',
              style: whiteMedium,
            ),
            onTap: () {
              Navigator.pop(context);
              Get.offAndToNamed('/history');
            },
          ),
          ListTile(
            leading: Image.asset(
              'assets/icons/report_icon.png',
              height: iconSize,
              width: iconSize,
            ),
            title: Text(
              'Báo cáo kinh doanh ',
              style: whiteMedium,
            ),
            onTap: () {
              Navigator.pop(context);
              Get.offAndToNamed('/report');
            },
          ),
          ListTile(
            leading: Image.asset(
              'assets/icons/user_icon.png',
              height: iconSize,
              width: iconSize,
              color: Colors.white,
            ),
            title: Text(
              'Khách hàng ',
              style: whiteMedium,
            ),
            onTap: () {
              Navigator.pop(context);
              Get.offAndToNamed('/customers');
            },
          )
        ],
      ),
    );
  }
}
