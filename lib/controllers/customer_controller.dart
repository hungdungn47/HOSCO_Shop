import 'package:get/get.dart';
import 'package:hosco_shop_2/models/customer.dart';
import 'package:hosco_shop_2/models/partner.dart';
import 'package:hosco_shop_2/networking/api/partner_api_service.dart';
// import 'package:hosco_shop_2/services/local_db_service.dart';

class CustomerController extends GetxController {
  // final DatabaseService databaseService = DatabaseService.instance;
  final PartnerApiService partnerApiService = PartnerApiService.instance;
  var customers = <Partner>[].obs;
  var suggestionCustomers = <Partner>[
    Partner(
        name: "Khách lẻ",
        phone: '039392',
        email: '123@gmail.com',
        role: 'retail_customer',
        address: 'Quynh Coi')
  ].obs;
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
      final data = await partnerApiService.getAllCustomers();
      customers.assignAll(data);
    } catch (e) {
      print('Error fetching customers');
    }
  }

  void toggleShowSuggestion() {
    isShowSuggestion.value = !isShowSuggestion.value;
  }

  void searchCustomers(String searchQuery) async {
    final res = await partnerApiService.searchCustomers(searchQuery);
    res.insert(
        0,
        Partner(
            name: "Khách lẻ",
            phone: '039392',
            email: '123@gmail.com',
            role: 'retail_customer',
            address: 'Quynh Coi'));
    suggestionCustomers.assignAll(res);
    res.clear();
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
