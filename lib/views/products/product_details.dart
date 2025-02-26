import 'package:flutter/material.dart';
import 'package:hosco_shop_2/utils/constants.dart';
import '../../models/product.dart';
import 'edit_product.dart';
import 'package:intl/intl.dart';

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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text(widget.product.name)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Center(
              child: Image.network(
                widget.product.imageUrl,
                height: size.height * 0.35,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.image_not_supported, size: 100, color: Colors.grey),
              ),
            ),
            SizedBox(height: 16.0),

            // Product Name
            Text(widget.product.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8.0),

            // Product Price
            Text(
              "${NumberFormat.decimalPattern().format(widget.product.price)} VND",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            SizedBox(height: 8.0),

            // Stock Quantity
            RichText(
              text: TextSpan(
                text: "Số lượng có sẵn: ",
                style: TextStyle(fontSize: 22, color: Colors.black54),
                children: [
                  TextSpan(
                    text: "${widget.product.stockQuantity}",
                    style: TextStyle(fontSize: 22, color: primaryColor, fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
            SizedBox(height: 16.0),

            // Description
            Text("Mô tả", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 4.0),
            Text(
              widget.product.description.isNotEmpty ? widget.product.description : "No description available.",
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
            SizedBox(height: 16.0),

            // Supplier Info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Nhà cung cấp:", style: TextStyle(fontSize: 18, color: Colors.black54)),
                Text(widget.product.supplier, style: TextStyle(fontSize: 18, color: Colors.black54)),
              ],
            ),
            SizedBox(height: 8.0),

            // Receiving Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Ngày nhập hàng:", style: TextStyle(fontSize: 18, color: Colors.black54)),
                Text(
                  widget.product.receivingDate.toLocal().toString().split(' ')[0],
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
      ),

      // Edit & Delete Buttons at Bottom
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(24.0),
        child: Row(
          children: [
            // Edit Button
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Set border radius here
                  ),
                ),
                icon: Icon(Icons.edit, color: Colors.white),
                label: Text("Chỉnh sửa", style: TextStyle(fontSize: 18, color: Colors.white)),
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
            ),
            SizedBox(width: 16.0),

            // Delete Button
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Set border radius here
                  ),
                ),
                icon: Icon(Icons.delete, color: Colors.white),
                label: Text("Xóa", style: TextStyle(fontSize: 18, color: Colors.white)),
                onPressed: _confirmDelete,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Xóa sản phẩm"),
        content: Text("Bạn có chắc chắn muốn xóa sản phẩm này không?"),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(// Neutral color for cancel button
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: primaryColor,
                  width: 1
                ),
                borderRadius: BorderRadius.circular(5), // Set border radius
              ),
            ),
            onPressed: () => Navigator.pop(context),
            child: Text("Hủy", style: TextStyle(color: primaryColor)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, // Red for delete button
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5), // Set border radius
              ),
            ),
            onPressed: () {
              widget.onDelete(widget.product.id);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text("Xóa", style: TextStyle(color: Colors.white)),
          ),
        ],

      ),
    );
  }
}
