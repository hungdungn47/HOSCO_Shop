import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hosco_shop_2/controllers/product_controller.dart';
import 'package:hosco_shop_2/models/product.dart';
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

  // Function to select and upload an image
  Future<void> _selectAndUploadImage() async {
    File? image = await _imageService.pickImage();
    if (image == null) return;

    setState(() {
      _selectedImage = image;
      _isUploading = true;
    });

    String? downloadUrl = await _imageService.uploadImage(image);
    // String downloadUrl = 'hehehe';
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
        _imageUrl == null) {
      Get.snackbar("Error", "Please fill all fields and upload an image", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final newProduct = Product(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // Unique ID
      name: nameController.text,
      category: "Default", // Modify to allow category selection
      price: double.tryParse(priceController.text) ?? 0.0,
      stockQuantity: int.tryParse(stockController.text) ?? 0,
      supplier: "Unknown", // Modify to allow supplier selection
      receivingDate: DateTime.now(),
      imageUrl: _imageUrl!,
      description: descriptionController.text,
      isAvailable: (int.tryParse(stockController.text) ?? 0) > 0,
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
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: primaryColor, width: 1.5),
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: _selectAndUploadImage,
              icon: Icon(Icons.upload),
              label: Text("Chọn ảnh"),
            ),

            SizedBox(height: 20),

            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Tên sản phẩm"),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: "Giá sản phẩm"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: stockController,
              decoration: InputDecoration(labelText: "Số lượng tồn kho"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Mô tả",
                border: OutlineInputBorder(), // ✅ Looks more like a text area
              ),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: _saveProduct,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: primaryColor, width: 1.5),
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Text("Lưu sản phẩm"),
            ),
          ],
        ),
      ),
    );
  }
}
