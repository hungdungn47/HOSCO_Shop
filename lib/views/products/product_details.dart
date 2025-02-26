import 'package:flutter/material.dart';
import '../../models/product.dart';
import 'edit_product.dart'; // Import the Product model


// import 'package:flutter/material.dart';
// import 'product.dart';
// import 'mock_products.dart';
// import 'edit_product_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final Function(Product) onUpdate;
  final Function(String) onDelete;

  const ProductDetailScreen({
    Key? key,
    required this.product,
    required this.onUpdate,
    required this.onDelete,
  }) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        actions: [
          // Edit Button
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              final updatedProduct = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProductScreen(product: widget.product),
                ),
              );
              if (updatedProduct != null) {
                widget.onUpdate(updatedProduct);
                setState(() {});
              }
            },
          ),
          // Delete Button
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              _confirmDelete();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                widget.product.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported, size: 100, color: Colors.grey),
              ),
            ),
            SizedBox(height: 16.0),
            Text(widget.product.name, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 8.0),
            Text("\$${widget.product.price.toStringAsFixed(2)}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
            SizedBox(height: 8.0),
            Text("Stock: ${widget.product.stockQuantity} left", style: TextStyle(fontSize: 16, color: Colors.black54)),
            SizedBox(height: 16.0),
            Text("Description:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 4.0),
            Text(widget.product.description, style: TextStyle(fontSize: 16, color: Colors.black87)),
          ],
        ),
      ),
    );
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Product"),
        content: Text("Are you sure you want to delete this product?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          TextButton(
            onPressed: () {
              widget.onDelete(widget.product.id);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
