import 'package:hosco_shop_2/models/partner.dart';
import 'package:hosco_shop_2/networking/http_client.dart';

class PartnerApiService {
  static final PartnerApiService _instance = PartnerApiService._internal();

  PartnerApiService._internal();
  static PartnerApiService get instance => _instance;
  PartnerApiService();

  Future<List<Partner>> getAllSuppliers() async {
    final response = await HttpClient.get(
        endPoint: '/api/v1/partners', queryParams: {"role": "supplier"});
    print(response?['partners']);
    return response?['partners']
        .map<Partner>((json) => Partner.fromJson(json))
        .toList();
  }

  Future<List<Partner>> getAllPartners() async {
    final response = await HttpClient.get(endPoint: '/api/v1/partners');
    print(response?['partners']);
    return response?['partners']
        .map<Partner>((json) => Partner.fromJson(json))
        .toList();
  }

  Future<List<Partner>> getAllCustomers() async {
    final response = await getAllPartners();
    return response
        .where((p) =>
            p.role == 'wholesale_customer' || p.role == 'retail_customer')
        .toList();
  }

  Future<Partner> getPartnerById(int partnerId) async {
    final partners = await getAllPartners();
    return partners.firstWhere((p) => p.id == partnerId);
  }
}
