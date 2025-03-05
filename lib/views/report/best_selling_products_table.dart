import 'package:flutter/material.dart';

class BestSellingProductsTable extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  BestSellingProductsTable({required this.products});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columnSpacing: 20,
      border: TableBorder.all(color: Colors.grey.shade300),
      columns: [
        DataColumn(label: Text('')),
        DataColumn(label: Text('Hình ảnh', style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text('Sản phẩm', style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text('Đã bán', style: TextStyle(fontWeight: FontWeight.bold))),
      ],
      rows: products.asMap().entries.map((entry) {
        int index = entry.key + 1; // Số thứ tự bắt đầu từ 1
        var product = entry.value;

        return DataRow(cells: [
          DataCell(Text('$index')), // Số thứ tự
          DataCell(
            Image.network(
              product['imageUrl'],
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 50, color: Colors.grey),
            ),
          ),
          DataCell(Text(product['name'])),
          DataCell(
            Align(
              alignment: Alignment.center, // Center the text
              child: Text(
                "${product['totalSold']}",
                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ]);
      }).toList(),
    );
  }
}
