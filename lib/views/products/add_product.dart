import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hosco_shop_2/controllers/product_controller.dart';
import 'package:hosco_shop_2/models/product.dart';
import 'package:hosco_shop_2/models/supplier.dart';
import 'package:hosco_shop_2/services/image_upload_service.dart';
import 'package:hosco_shop_2/utils/constants.dart';

class CreateProductScreen extends StatefulWidget {
  @override
  _CreateProductScreenState createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  final ProductController productController = Get.find<ProductController>();
  final ImageUploadService _imageService = ImageUploadService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  File? _selectedImage;
  String? _imageUrl;
  bool _isUploading = false;

  String? _selectedCategory;
  String? _selectedSupplier;

  final List<String> categories = ["Electronics", "Fashion", "Home", "Beauty", "Sports"];
  final List<String> suppliers = ["Supplier A", "Supplier B", "Supplier C"];



  // Function to select and upload an image
  Future<void> _selectAndUploadImage() async {
    File? image = await _imageService.pickImage();
    if (image == null) return;

    setState(() {
      _selectedImage = image;
      _isUploading = true;
    });

    String? downloadUrl = await _imageService.uploadImage(image);
    if (downloadUrl != null) {
      setState(() {
        _imageUrl = downloadUrl;
        _isUploading = false;
      });
    } else {
      setState(() {
        _isUploading = false;
      });
      Get.snackbar("Error", "Failed to upload image", snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Function to save the new product
  void _saveProduct() {
    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        stockController.text.isEmpty ||
        _imageUrl == null ||
        _selectedCategory == null ||
        _selectedSupplier == null) {
      Get.snackbar("Error", "Please fill all fields and upload an image", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final newProduct = Product(
      id: "Product123",
      name: nameController.text,
      category: _selectedCategory!,
      retailPrice: double.tryParse(priceController.text) ?? 0.0,
      wholesalePrice: double.tryParse(priceController.text) ?? 0.0,
      stockQuantity: int.tryParse(stockController.text) ?? 0,
      imageUrl: _imageUrl!,
      description: descriptionController.text,
    );

    productController.addProduct(newProduct);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tạo sản phẩm mới")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Product Image Upload Section
            Center(
              child: _selectedImage != null
                  ? Image.file(_selectedImage!, height: 150, width: 150, fit: BoxFit.cover)
                  : _imageUrl != null
                  ? Image.network(_imageUrl!, height: 150, width: 150, fit: BoxFit.cover)
                  : Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.image, size: 50, color: Colors.grey),
              ),
            ),

            SizedBox(height: 10),

            _isUploading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton.icon(
              onPressed: _selectAndUploadImage,
              icon: Icon(Icons.upload, color: Colors.white),
              label: Text("Chọn ảnh"),
            ),

            SizedBox(height: 20),

            // Product Name
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Tên sản phẩm"),
            ),

            SizedBox(height: 10),

            // Category Selection
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              onChanged: (value) => setState(() => _selectedCategory = value),
              items: productController.allCategories?.map((category) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),
              decoration: InputDecoration(labelText: "Chọn danh mục"),
            ),

            SizedBox(height: 10),

            // Price
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: "Giá sản phẩm"),
              keyboardType: TextInputType.number,
            ),

            SizedBox(height: 10),

            // Stock Quantity
            TextField(
              controller: stockController,
              decoration: InputDecoration(labelText: "Số lượng tồn kho"),
              keyboardType: TextInputType.number,
            ),

            SizedBox(height: 10),

            // Supplier Selection
            DropdownButtonFormField<String>(
              value: _selectedSupplier,
              onChanged: (value) => setState(() => _selectedSupplier = value),
              items: suppliers.map((supplier) {
                return DropdownMenuItem(value: supplier, child: Text(supplier));
              }).toList(),
              decoration: InputDecoration(labelText: "Chọn nhà cung cấp"),
            ),

            SizedBox(height: 10),

            // Product Description
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Mô tả sản phẩm",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),

            // Save Product Button
            ElevatedButton(
              onPressed: _saveProduct,
              child: Text("Lưu sản phẩm"),
            ),
          ],
        ),
      ),
    );
  }
}
