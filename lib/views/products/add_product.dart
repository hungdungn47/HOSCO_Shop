import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hosco_shop_2/controllers/product_controller.dart';
import 'package:hosco_shop_2/models/product.dart';
import 'package:hosco_shop_2/services/image_upload_service.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:logger/logger.dart';

class CreateProductScreen extends StatefulWidget {
  @override
  _CreateProductScreenState createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  final ProductController productController = Get.find<ProductController>();
  final ImageUploadService _imageService = ImageUploadService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController retailPriceController = TextEditingController();
  final TextEditingController wholesalePriceController =
      TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final FocusNode categoryFocusNode = FocusNode(); // Handle focus

  File? _selectedImage;
  String? _imageUrl;
  bool _isUploading = false;

  String? _selectedCategory;
  String _discountUnit = "percentage";

  final List<String> discountUnits = ["percentage", "vnd"];

  // Function to select and upload an image
  Future<void> _selectAndUploadImage() async {
    File? image = await _imageService.pickImageWithDialog(context);
    if (image == null) return;

    setState(() {
      _selectedImage = image;
      _isUploading = true;
    });

    // Map<String, dynamic> geminiResponse =
    //     await _imageService.getGeminiResponseToImage(image);

    _imageService.getGeminiResponseToImage(image).then((geminiResponse) {
      var logger = Logger();
      logger.d('Got gemini response:');
      logger.i(geminiResponse);
      if (geminiResponse['success']) {
        nameController.text = geminiResponse['data']['productName'] ?? "";
        wholesalePriceController.text =
            geminiResponse['data']['wholesalePrice'].toString() ?? "";
        retailPriceController.text =
            geminiResponse['data']['retailPrice'].toString() ?? "";
        categoryController.text = geminiResponse['data']['category'] ?? "";
        descriptionController.text =
            geminiResponse['data']['description'] ?? "";
      }
    });

    _imageService.uploadImage(image).then((downloadUrl) {
      if (downloadUrl != null) {
        setState(() {
          _imageUrl = downloadUrl;
          _isUploading = false;
        });
      } else {
        setState(() {
          _isUploading = false;
        });
        Get.snackbar("Error", "Failed to upload image",
            snackPosition: SnackPosition.BOTTOM);
      }
    });
  }

  // Function to save the new product
  void _saveProduct() {
    if (nameController.text.isEmpty ||
        retailPriceController.text.isEmpty ||
        wholesalePriceController.text.isEmpty ||
        _imageUrl == null) {
      Get.snackbar(
          "Error", "Please fill all required fields and upload an image",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final newProduct = Product(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: nameController.text,
      category: categoryController.text,
      retailPrice: double.tryParse(retailPriceController.text) ?? 0.0,
      wholesalePrice: double.tryParse(wholesalePriceController.text) ?? 0.0,
      stockQuantity: int.tryParse(stockController.text) ?? 0,
      imageUrl: _imageUrl!,
      description: descriptionController.text,
      discount: double.tryParse(discountController.text) ?? 0.0,
      discountUnit: _discountUnit,
    );

    try {
      productController.addProduct(newProduct);
      Get.back();
    } catch (error) {
      Get.snackbar("Error", error.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text("Thêm sản phẩm")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Product Image Upload Section
            Center(
              child: _selectedImage != null
                  ? Image.file(_selectedImage!,
                      height: 150, width: 150, fit: BoxFit.cover)
                  : _imageUrl != null
                      ? Image.network(_imageUrl!,
                          height: 150, width: 150, fit: BoxFit.cover)
                      : Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child:
                              Icon(Icons.image, size: 50, color: Colors.grey),
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

            TypeAheadField<String>(
              controller: categoryController,
              suggestionsCallback: (search) async {
                return productController.allCategories
                    .where((c) => c.toLowerCase().contains(search))
                    .toList();
              },
              focusNode: categoryFocusNode,
              builder: (context, controller, focusNode) {
                return TextField(
                    controller: categoryController,
                    focusNode: focusNode,
                    // autofocus: true,
                    decoration: InputDecoration(
                      // border: OutlineInputBorder(),
                      labelText: 'Danh mục',
                    ));
              },
              itemBuilder: (context, category) {
                return ListTile(title: Text(category));
              },
              onSelected: (category) {
                setState(() {
                  _selectedCategory = category;
                  categoryController.text = category;
                  categoryFocusNode.unfocus();
                });
              },
              offset: Offset(0, 12),
              constraints: BoxConstraints(maxHeight: 500),
            ),

            _selectedCategory != null
                ? Row(
                    children: [
                      Text('Danh mục đã chọn:'),
                      Text(
                        _selectedCategory!,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  )
                : SizedBox.shrink(),

            SizedBox(height: 10),

            // Retail Price
            TextField(
              controller: retailPriceController,
              decoration: InputDecoration(labelText: "Giá bán lẻ"),
              keyboardType: TextInputType.number,
            ),

            SizedBox(height: 10),

            // Wholesale Price
            TextField(
              controller: wholesalePriceController,
              decoration: InputDecoration(labelText: "Giá bán buôn"),
              keyboardType: TextInputType.number,
            ),

            // SizedBox(height: 10),

            // // Stock Quantity
            // TextField(
            //   controller: stockController,
            //   decoration:
            //       InputDecoration(labelText: "Số lượng "),
            //   keyboardType: TextInputType.number,
            // ),

            // SizedBox(height: 10),

            // Discount
            TextField(
              controller: discountController,
              decoration: InputDecoration(labelText: "Chiết khấu"),
              keyboardType: TextInputType.number,
            ),

            SizedBox(height: 10),

            // Discount Unit Dropdown
            DropdownButtonFormField<String>(
              value: _discountUnit,
              onChanged: (value) {
                setState(() {
                  _discountUnit = value!;
                });
              },
              items: discountUnits.map((unit) {
                return DropdownMenuItem(value: unit, child: Text(unit));
              }).toList(),
              decoration: InputDecoration(labelText: "Đơn vị chiết khấu"),
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
              child: Text("Tạo sản phẩm"),
            ),
          ],
        ),
      ),
    );
  }
}
