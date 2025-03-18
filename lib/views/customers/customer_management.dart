import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hosco_shop_2/controllers/customer_controller.dart';
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
              }),
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
                        Get.to(() => AddCustomerScreen(
                              customer: customer,
                            ));
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
}
