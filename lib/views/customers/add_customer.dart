import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hosco_shop_2/controllers/customer_controller.dart';
import 'package:hosco_shop_2/models/customer.dart';

class AddCustomerScreen extends StatefulWidget {
  final Customer? customer;

  AddCustomerScreen({this.customer});

  @override
  _AddCustomerScreenState createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final CustomerController customerController = Get.find<CustomerController>();

  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController addressController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.customer?.name ?? '');
    phoneController = TextEditingController(text: widget.customer?.phone ?? '');
    emailController = TextEditingController(text: widget.customer?.email ?? '');
    addressController = TextEditingController(text: widget.customer?.address ?? '');
  }

  void _saveCustomer() {
    if (nameController.text.isEmpty || phoneController.text.isEmpty) {
      Get.snackbar("Lỗi", "Vui lòng nhập đầy đủ thông tin", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final newCustomer = Customer(
      id: widget.customer?.id,
      name: nameController.text,
      phone: phoneController.text,
      email: emailController.text,
      address: addressController.text,
      createdAt: widget.customer?.createdAt ?? DateTime.now(),
    );

    if (widget.customer == null) {
      customerController.addCustomer(newCustomer);
    } else {
      customerController.updateCustomer(newCustomer);
    }

    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.customer == null ? "Thêm khách hàng" : "Chỉnh sửa khách hàng")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Tên khách hàng"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: "Số điện thoại"),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 10),
            TextField(
              controller: addressController,
              decoration: InputDecoration(labelText: "Địa chỉ"),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _saveCustomer,
                child: Text(widget.customer == null ? "Lưu khách hàng" : "Cập nhật khách hàng"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
