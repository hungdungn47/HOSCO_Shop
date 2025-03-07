import 'package:get/get.dart';
import 'package:hosco_shop_2/models/customer.dart';
import 'package:hosco_shop_2/services/local_db_service.dart';

class CustomerController extends GetxController {
  final DatabaseService databaseService = DatabaseService.instance;
  var customers = <Customer>[].obs;

  @override
  void onInit() {
    fetchCustomers();
    super.onInit();
  }

  void fetchCustomers() async {
    final data = await databaseService.getAllCustomers();
    customers.assignAll(data.map((c) => Customer.fromMap(c)));
  }

  void addCustomer(Customer customer) async {
    await databaseService.addCustomer(customer);
    fetchCustomers();
  }

  void updateCustomer(Customer customer) async {
    await databaseService.updateCustomer(customer);
    fetchCustomers();
  }

  void deleteCustomer(int id) async {
    print('Deleting customer with id: ${id}');
    await databaseService.deleteCustomer(id);
    fetchCustomers();
  }
}
