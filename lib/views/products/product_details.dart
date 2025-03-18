import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hosco_shop_2/controllers/purchase_controller.dart';
import 'package:intl/intl.dart';
import 'package:hosco_shop_2/controllers/product_controller.dart';
import 'package:hosco_shop_2/utils/constants.dart';

class ProductDetailScreen extends StatelessWidget {
  ProductDetailScreen({Key? key}) : super(key: key);

  final ProductController productController = Get.find<ProductController>();
  final PurchaseController purchaseController = Get.find<PurchaseController>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Chi tiết sản phẩm", style: TextStyle(fontSize: 18)),
      ),
      body: Obx(() {
        final product = productController.selectedProduct.value;
        if (product == null)
          return Center(
              child: Text("Không có sản phẩm nào được chọn.",
                  style: TextStyle(fontSize: 14)));

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Center(
                child: CachedNetworkImage(
                  height: size.height * 0.3,
                  width: double.infinity,
                  fit: BoxFit.contain,
                  imageUrl: product.imageUrl!,
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(
                      Icons.image_not_supported,
                      size: 80,
                      color: Colors.grey),
                ),
              ),
              SizedBox(height: 16.0),

              // Product Info
              _buildInfoRow("Tên sản phẩm", product.name),
              _buildInfoRow("Mã sản phẩm", product.id),
              _buildInfoRow("Danh mục", product.category),
              _buildInfoRow("Giá bán lẻ",
                  "${NumberFormat.decimalPattern().format(product.retailPrice)} VND"),
              _buildInfoRow("Giá bán sỉ",
                  "${NumberFormat.decimalPattern().format(product.wholesalePrice)} VND"),
              _buildInfoRow("Số lượng có sẵn", "${product.stockQuantity}"),
              SizedBox(height: 16.0),

              // Description
              Text("Mô tả",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 4.0),
              Text(product.description ?? "Không có mô tả.",
                  style: TextStyle(fontSize: 14, color: Colors.black87)),
              SizedBox(height: 16.0),
            ],
          ),
        );
      }),

      // Edit & Delete Buttons at Bottom
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Edit Button
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                icon: Icon(Icons.add_circle_sharp, color: Colors.white),
                label: Text("Nhập hàng",
                    style: TextStyle(fontSize: 16, color: Colors.white)),
                onPressed: () {
                  final selectedProduct =
                      productController.selectedProduct.value;
                  if (selectedProduct != null) {
                    purchaseController.selectedProduct.value = selectedProduct;
                    Get.toNamed('/purchase');
                  }
                },
              ),
            ),
            SizedBox(width: 12.0),

            // Delete Button
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                icon: Icon(Icons.delete, color: Colors.white),
                label: Text("Xóa",
                    style: TextStyle(fontSize: 16, color: Colors.white)),
                onPressed: () => _confirmDelete(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Align text properly
        children: [
          // Label on the left
          Expanded(
            flex: 3, // Adjust flex as needed
            child: Text(
              label,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54),
            ),
          ),
          SizedBox(width: 8), // Spacing between label and value

          // Value on the right, wrapping if needed
          Expanded(
            flex: 5, // Adjust flex for better alignment
            child: Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end, // Align text to the right
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Xóa sản phẩm", style: TextStyle(fontSize: 16)),
        content: Text("Bạn có chắc chắn muốn xóa sản phẩm này không?",
            style: TextStyle(fontSize: 14)),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: primaryColor, width: 1),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            onPressed: () => Navigator.pop(context),
            child: Text("Hủy",
                style: TextStyle(fontSize: 14, color: Colors.white)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
            ),
            onPressed: () {
              productController.deleteProduct();
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text("Xóa",
                style: TextStyle(fontSize: 14, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
