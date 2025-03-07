import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hosco_shop_2/controllers/customer_controller.dart';
import 'package:hosco_shop_2/models/customer.dart';
import 'package:hosco_shop_2/utils/constants.dart';
import 'package:hosco_shop_2/utils/navigation_drawer.dart';
import 'package:hosco_shop_2/views/customers/add_customer.dart';

class CustomerManagementScreen extends StatelessWidget {
  final CustomerController customerController = Get.put(CustomerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: MyNavigationDrawer(),
      appBar: AppBar(
        title: Text("Khách hàng"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Get.to(() => AddCustomerScreen());
            }
          ),
        ],
      ),
      body: Obx(() {
        if (customerController.customers.isEmpty) {
          return Center(child: Text("No customers found."));
        }
        return ListView.builder(
          itemCount: customerController.customers.length,
          itemBuilder: (context, index) {
            final customer = customerController.customers[index];
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: primaryColor, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                title: Text(customer.name),
                subtitle: Text(customer.phone ?? "No phone"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        // _showCustomerDialog(context, customer)
                        Get.to(() => AddCustomerScreen(customer: customer,));
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.warning,
                          animType: AnimType.rightSlide,
                          title: "Xóa tất cả",
                          desc: 'Bạn có chắc chắn muốn xóa khách hàng này?',
                          btnCancelText: 'Hủy',
                          btnCancelOnPress: () {},
                          btnOkText: 'Xóa',
                          btnOkOnPress: () {
                            customerController.deleteCustomer(customer.id!);
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.success,
                              title: "Thành công",
                              desc: "Xóa giỏ hàng thành công!",
                            ).show();
                          },
                        ).show();
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  void _showCustomerDialog(BuildContext context, [Customer? customer]) {
    final _formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: customer?.name ?? '');
    final phoneController = TextEditingController(text: customer?.phone ?? '');
    final emailController = TextEditingController(text: customer?.email ?? '');
    final addressController = TextEditingController(text: customer?.address ?? '');

    Get.defaultDialog(
      title: customer == null ? "Add Customer" : "Edit Customer",
      content: Container(
        width: Get.width * 0.8,
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField("Name", nameController, (value) {
                if (value == null || value.isEmpty) return "Name is required";
                return null;
              }),
              _buildTextField("Phone", phoneController, (value) {
                if (value == null || value.isEmpty) return "Phone is required";
                if (!RegExp(r'^\d{10,11}$').hasMatch(value)) return "Invalid phone number";
                return null;
              }),
              _buildTextField("Email", emailController, (value) {
                if (value == null || value.isEmpty) return "Email is required";
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return "Invalid email";
                return null;
              }),
              _buildTextField("Address", addressController, (value) {
                if (value == null || value.isEmpty) return "Address is required";
                return null;
              }),
            ],
          ),
        ),
      ),
      textConfirm: "Save",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      onConfirm: () {
        if (_formKey.currentState!.validate()) {
          final newCustomer = Customer(
            id: customer?.id,
            name: nameController.text,
            phone: phoneController.text,
            email: emailController.text,
            address: addressController.text,
            createdAt: customer?.createdAt ?? DateTime.now(),
          );

          if (customer == null) {
            customerController.addCustomer(newCustomer);
          } else {
            customerController.updateCustomer(newCustomer);
          }
          Get.back();
        }
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String? Function(String?) validator) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
