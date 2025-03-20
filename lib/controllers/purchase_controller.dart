import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hosco_shop_2/models/partner.dart';
// import 'package:hosco_shop_2/models/supplier.dart';
import 'package:hosco_shop_2/networking/api/index.dart';
import 'package:hosco_shop_2/networking/api/partner_api_service.dart';
import 'package:hosco_shop_2/networking/api/warehouse_api_service.dart';
import 'package:intl/intl.dart';
import '../models/product.dart';
import '../models/warehouse.dart';

class PurchaseController extends GetxController {
  var selectedProduct = Rxn<Product>();
  var selectedSupplier = Rxn<Partner>();
  var selectedWarehouse = Rxn<Warehouse>();

  var warehouseList = RxList<Warehouse>();
  var supplierList = RxList<Partner>();

  TextEditingController productNameController = TextEditingController();
  TextEditingController supplierIdController = TextEditingController();
  TextEditingController warehouseIdController = TextEditingController();
  TextEditingController purchasePriceController = TextEditingController();
  TextEditingController batchQuantityController = TextEditingController();
  TextEditingController vatController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController purchaseNoteController = TextEditingController();

  final ProductApiService apiService = ProductApiServiceImpl.instance;
  final WarehouseApiService warehouseApiService = WarehouseApiService.instance;
  final PartnerApiService partnerApiService = PartnerApiService.instance;
  var discountUnit = "VND".obs;
  var expiryDate = "".obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    selectedProduct.value = Get.arguments?['selectedProduct'];
    fetchAllData();
  }

  void fetchAllData() async {
    await fetchAllSuppliers();
    await fetchAllWarehouses();
  }

  Future<void> fetchAllSuppliers() async {
    supplierList.assignAll(await partnerApiService.getAllSuppliers());
    print(supplierList);
  }

  Future<void> fetchAllWarehouses() async {
    warehouseList.assignAll(await warehouseApiService.getAllWarehouses());
    print(warehouseList);
  }

  Future<List<Product>> getProductSuggestions(String query) async {
    List<Product> res =
        await apiService.getAllProducts(query: query, pageSize: '5');
    return res;
  }

  Future<List<Partner>> getSupplierSuggestions(String query) async {
    List<Partner> res = supplierList
        .where((s) => s.name.toLowerCase().contains(query))
        .toList();
    return res;
  }

  Future<List<Warehouse>> getWarehouseSuggestions(String query) async {
    List<Warehouse> res = warehouseList
        .where((s) => s.name.toLowerCase().contains(query))
        .toList();
    return res;
  }

  Future<void> pickExpiryDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );
    if (picked != null) {
      expiryDate.value = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  void submitPurchase() async {
    if (selectedProduct.value == null ||
        selectedSupplier.value == null ||
        selectedWarehouse.value == null) {
      Get.snackbar("Error", "Please select product, supplier, and warehouse",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    print("✅ Purchase submitted successfully!");
    print("Product: ${selectedProduct.value!.name}");
    print("Supplier: ${selectedSupplier.value!.name}");
    // print("Warehouse: ${selectedWarehouse.value!.name}");
    print("Price: ${purchasePriceController.text}");
    print("Batch Quantity: ${batchQuantityController.text}");
    print("VAT: ${vatController.text}%");
    print("Discount: ${discountController.text} ${discountUnit.value}");
    print("Expiry Date: ${expiryDate.value}");
    print("Note: ${purchaseNoteController.text}");
    try {
      await apiService.purchaseProduct({
        "productId": selectedProduct.value!.id,
        "supplierId": selectedSupplier.value!.id,
        "warehouseId": selectedWarehouse.value!.id,
        "expiryDate": expiryDate.value,
        "batchQuantity": int.parse(batchQuantityController.text),
        "purchasePrice": purchasePriceController.text != ""
            ? double.parse(purchasePriceController.text)
            : 0.0,
        "purchaseNote": purchaseNoteController.text != ""
            ? purchaseNoteController.text
            : "",
        "vat":
            vatController.text != "" ? double.parse(vatController.text) : 0.0,
        "discount": discountController.text != ""
            ? double.parse(discountController.text)
            : 0.0,
        "discountUnit": discountUnit.value == "VND" ? 'vnd' : 'percentage'
      });
      Get.back();
    } catch (error) {
      Get.snackbar("Error", error.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
