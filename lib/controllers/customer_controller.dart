import 'package:get/get.dart';
import 'package:hosco_shop_2/models/customer.dart';
import 'package:hosco_shop_2/services/local_db_service.dart';

class CustomerController extends GetxController {
  // final DatabaseService databaseService = DatabaseService.instance;
  var customers = <Customer>[].obs;
  var suggestionCustomers = <Customer>[Customer(name: "Khách lẻ")].obs;
  var isShowSuggestion = false.obs;

  @override
  void onInit() {
    fetchCustomers();
    super.onInit();
  }

  void fetchCustomers() async {
    try {
      // final data = await databaseService.getAllCustomers();
      // customers.assignAll(data);
    } catch (e) {
      print('Error fetching customers');
    }
  }

  void toggleShowSuggestion() {
    isShowSuggestion.value = !isShowSuggestion.value;
  }

  void searchCustomers(String searchQuery) async {
    // final res = await databaseService.searchCustomers(searchQuery);
    // res.insert(0, Customer(name: "Khách lẻ"));
    // suggestionCustomers.assignAll(res);
    // res.clear();
  }

  void addCustomer(Customer customer) async {
    // await databaseService.addCustomer(customer);
    fetchCustomers();
  }

  void updateCustomer(Customer customer) async {
    // await databaseService.updateCustomer(customer);
    fetchCustomers();
  }

  void deleteCustomer(int id) async {
    print('Deleting customer with id: ${id}');
    // await databaseService.deleteCustomer(id);
    fetchCustomers();
  }
}
