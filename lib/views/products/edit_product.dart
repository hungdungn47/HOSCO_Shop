// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:hosco_shop_2/controllers/product_controller.dart';
// import 'package:hosco_shop_2/utils/constants.dart';
// import '../../models/product.dart';
//
// class EditProductScreen extends StatelessWidget {
//   final ProductController productController = Get.find<ProductController>();
//
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController priceController = TextEditingController();
//   final TextEditingController stockController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//
//   EditProductScreen({Key? key}) : super(key: key) {
//     final product = productController.selectedProduct.value!;
//     nameController.text = product.name;
//     priceController.text = product.price.toString();
//     stockController.text = product.stockQuantity.toString();
//     descriptionController.text = product.description;
//   }
//
//   void _saveChanges() {
//     final updatedProduct = Product(
//       id: productController.selectedProduct.value!.id,
//       name: nameController.text,
//       category: productController.selectedProduct.value!.category,
//       price: double.tryParse(priceController.text) ?? productController.selectedProduct.value!.price,
//       stockQuantity: int.tryParse(stockController.text) ?? productController.selectedProduct.value!.stockQuantity,
//       supplier: productController.selectedProduct.value!.supplier,
//       receivingDate: productController.selectedProduct.value!.receivingDate,
//       imageUrl: productController.selectedProduct.value!.imageUrl,
//       description: descriptionController.text,
//       isAvailable: (int.tryParse(stockController.text) ?? productController.selectedProduct.value!.stockQuantity) > 0,
//     );
//
//     productController.updateProduct(updatedProduct);
//     Get.back();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(title: Text("Cập nhật sản phẩm")),
//       resizeToAvoidBottomInset: true, // ✅ Prevents keyboard overflow
//       body: SingleChildScrollView( // ✅ Makes the UI scrollable when keyboard appears
//         child: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Center(
//                 child: Obx(() {
//                   final product = productController.selectedProduct.value!;
//                   return Image.network(
//                     product.imageUrl,
//                     height: size.height * 0.35,
//                     width: double.infinity,
//                     fit: BoxFit.contain,
//                     errorBuilder: (context, error, stackTrace) =>
//                         Icon(Icons.image_not_supported, size: 100, color: Colors.grey),
//                   );
//                 }),
//               ),
//               SizedBox(height: 20),
//               Text(productController.selectedProduct.value!.name,
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold
//                 )
//               ),
//               // TextField(
//               //   controller: nameController,
//               //   decoration: InputDecoration(labelText: "Tên sản phẩm"),
//               // ),
//               TextField(
//                 controller: priceController,
//                 decoration: InputDecoration(labelText: "Giá"),
//                 keyboardType: TextInputType.number,
//               ),
//               TextField(
//                 controller: stockController,
//                 decoration: InputDecoration(labelText: "Số lượng"),
//                 keyboardType: TextInputType.number,
//               ),
//               const SizedBox(height: 15),
//               TextField(
//                 controller: descriptionController,
//                 decoration: InputDecoration(
//                   labelText: "Mô tả",
//                   border: OutlineInputBorder(), // ✅ Adds a border to look more like a text area
//                 ),
//                 maxLines: 3, // ✅ Allows multiple lines
//                 keyboardType: TextInputType.multiline, // ✅ Enables multiline input
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _saveChanges,
//                 style: ElevatedButton.styleFrom(
//                   shape: RoundedRectangleBorder(
//                     side: BorderSide(color: primaryColor, width: 1.5),
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                 ),
//                 child: Text(
//                   'Lưu thay đổi',
//                 ),
//               ),
//               SizedBox(height: 20), // ✅ Adds extra space to prevent bottom overflow
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
