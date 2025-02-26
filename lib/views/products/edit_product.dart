import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(title: Text("Edit Product")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: "Product Name")),
            TextField(controller: priceController, decoration: InputDecoration(labelText: "Price"), keyboardType: TextInputType.number),
            TextField(controller: stockController, decoration: InputDecoration(labelText: "Stock Quantity"), keyboardType: TextInputType.number),
            TextField(controller: descriptionController, decoration: InputDecoration(labelText: "Description")),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveChanges,
              child: Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}
