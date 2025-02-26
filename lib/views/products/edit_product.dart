import 'package:flutter/material.dart';
import 'package:hosco_shop_2/utils/constants.dart';
import '../../models/product.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;

  const EditProductScreen({Key? key, required this.product}) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController stockController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product.name);
    priceController = TextEditingController(text: widget.product.price.toString());
    stockController = TextEditingController(text: widget.product.stockQuantity.toString());
    descriptionController = TextEditingController(text: widget.product.description);
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    stockController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final updatedProduct = Product(
      id: widget.product.id,
      name: nameController.text,
      category: widget.product.category,
      price: double.tryParse(priceController.text) ?? widget.product.price,
      stockQuantity: int.tryParse(stockController.text) ?? widget.product.stockQuantity,
      supplier: widget.product.supplier,
      receivingDate: widget.product.receivingDate,
      imageUrl: widget.product.imageUrl,
      description: descriptionController.text,
      isAvailable: (int.tryParse(stockController.text) ?? widget.product.stockQuantity) > 0,
    );

    Navigator.pop(context, updatedProduct);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text("Cập nhật sản phẩm")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Image.network(
                widget.product.imageUrl,
                height: size.height * 0.4,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported, size: 100, color: Colors.grey),
              ),
            ),
            TextField(style: TextStyle(fontSize: 18), controller: nameController, decoration: InputDecoration(labelText: "Product Name", labelStyle: TextStyle(fontSize: 18))),
            TextField(style: TextStyle(fontSize: 18), controller: priceController, decoration: InputDecoration(labelText: "Price", labelStyle: TextStyle(fontSize: 18)), keyboardType: TextInputType.number),
            TextField(style: TextStyle(fontSize: 18), controller: stockController, decoration: InputDecoration(labelText: "Stock Quantity", labelStyle: TextStyle(fontSize: 18)), keyboardType: TextInputType.number),
            TextField(style: TextStyle(fontSize: 18), controller: descriptionController, decoration: InputDecoration(labelText: "Description", labelStyle: TextStyle(fontSize: 18))),
            SizedBox(height: 20),
            GestureDetector(
              onTap: _saveChanges,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: primaryColor,
                    width: 1
                  )
                ),
                child: Text('Lưu thay đổi', style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                  fontSize: 18
                ),),
              ),
            )
          ],
        ),
      ),
    );
  }
}
