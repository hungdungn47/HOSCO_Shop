import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hosco_shop_2/utils/navigation_drawer.dart';

class AddProduct extends StatelessWidget {
  const AddProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: Icon(Icons),
        //   onPressed: () {
        //     Get.back();
        //   },
        // ),
        title: Text("Thêm sản phẩm"),
      ),
    );;
  }
}