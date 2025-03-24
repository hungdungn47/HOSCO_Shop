import 'package:hosco_shop_2/models/warehouse.dart';
import 'package:hosco_shop_2/networking/http_client.dart';

class WarehouseApiService {
  static final WarehouseApiService _instance = WarehouseApiService._internal();

  WarehouseApiService._internal();
  static WarehouseApiService get instance => _instance;
  WarehouseApiService();

  Future<List<Warehouse>> getAllWarehouses() async {
    final response = await HttpClient.get(endPoint: '/api/v1/warehouses');
    print(response?['warehouses']);
    return response?['warehouses']
        .map<Warehouse>((json) => Warehouse.fromJson(json))
        .toList();
    // return [];
  }

  Future<List<Map<String, dynamic>>> getWarehouseDetails(String warehouseId) async {
    final response = await HttpClient.get(endPoint: '/api/v1/warehouses/$warehouseId');
    print(response?['warehouse']);
    return response?['warehouse'];
    // return [];
  }
}
