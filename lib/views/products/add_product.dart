import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hosco_shop_2/controllers/product_controller.dart';
import 'package:hosco_shop_2/utils/constants.dart';
import '../../models/product.dart';

class CreateProductScreen extends StatelessWidget {
  final ProductController productController = Get.find<ProductController>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  final TextEditingController supplierController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  void _saveProduct() {
    if (nameController.text.isEmpty || priceController.text.isEmpty || stockController.text.isEmpty) {
      Get.snackbar("Lỗi", "Vui lòng nhập đầy đủ thông tin sản phẩm!", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    final newProduct = Product(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // Unique ID
      name: nameController.text,
      category: categoryController.text,
      price: double.tryParse(priceController.text) ?? 0.0,
      stockQuantity: int.tryParse(stockController.text) ?? 0,
      supplier: supplierController.text,
      receivingDate: DateTime.now(),
      imageUrl: imageUrlController.text,
      description: descriptionController.text,
      isAvailable: (int.tryParse(stockController.text) ?? 0) > 0,
    );

    productController.addProduct(newProduct);
    Get.back(); // Close screen after adding product
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Thêm sản phẩm mới")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: nameController, decoration: InputDecoration(labelText: "Tên sản phẩm")),
              TextField(controller: priceController, decoration: InputDecoration(labelText: "Giá"), keyboardType: TextInputType.number),
              TextField(controller: stockController, decoration: InputDecoration(labelText: "Số lượng"), keyboardType: TextInputType.number),
              TextField(controller: categoryController, decoration: InputDecoration(labelText: "Danh mục")),
              TextField(controller: supplierController, decoration: InputDecoration(labelText: "Nhà cung cấp")),
              TextField(controller: imageUrlController, decoration: InputDecoration(labelText: "URL Hình ảnh")),
              TextField(controller: descriptionController, decoration: InputDecoration(labelText: "Mô tả")),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProduct,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: primaryColor, width: 1.5),
                      borderRadius: BorderRadius.circular(6)
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: Text("Thêm sản phẩm", style: TextStyle(fontSize: 18, color: primaryColor, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
