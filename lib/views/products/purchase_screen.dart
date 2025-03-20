import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hosco_shop_2/models/partner.dart';
import '../../controllers/purchase_controller.dart';
import '../../models/product.dart';
import '../../models/warehouse.dart';

class PurchasingProductScreen extends StatelessWidget {
  final PurchaseController purchaseController = Get.put(PurchaseController());

  @override
  Widget build(BuildContext context) {
    print('Product name: ${purchaseController.selectedProduct.value?.name}');
    return Scaffold(
      appBar: AppBar(title: Text("Purchase Product")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAutocompleteField<Product>(
                label: "Product",
                hint: "Choose product",
                suggestionsCallback: purchaseController.getProductSuggestions,
                displayStringForOption: (product) => product.name,
                onSelected: (product) =>
                    purchaseController.selectedProduct.value = product,
              ),
              _buildAutocompleteField<Partner>(
                label: "Supplier",
                hint: "Choose supplier",
                suggestionsCallback: purchaseController.getSupplierSuggestions,
                displayStringForOption: (supplier) => supplier.name,
                onSelected: (supplier) =>
                    purchaseController.selectedSupplier.value = supplier,
              ),
              _buildAutocompleteField<Warehouse>(
                label: "Warehouse",
                hint: "Choose warehouse",
                suggestionsCallback: purchaseController.getWarehouseSuggestions,
                displayStringForOption: (warehouse) => warehouse.name,
                onSelected: (warehouse) =>
                    purchaseController.selectedWarehouse.value = warehouse,
              ),
              _buildTextField(
                  "Purchase Price", purchaseController.purchasePriceController),
              _buildTextField(
                  "Batch Quantity", purchaseController.batchQuantityController),
              _buildTextField("VAT (%)", purchaseController.vatController),
              _buildTextField(
                  "Discount", purchaseController.discountController),
              Obx(() => _buildDropdownField(
                    label: "Discount Unit",
                    items: ["%", "VND"],
                    selectedValue: purchaseController.discountUnit.value,
                    onChanged: (value) =>
                        purchaseController.discountUnit.value = value!,
                  )),
              Obx(() => _buildDateField(
                    label: "Expiry Date",
                    value: purchaseController.expiryDate.value,
                    onTap: () => purchaseController.pickExpiryDate(context),
                  )),
              _buildTextField(
                  "Purchase Note", purchaseController.purchaseNoteController,
                  keyboardType: TextInputType.text, maxLines: 3),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: purchaseController.submitPurchase,
                child: Text("Submit Purchase"),
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.0)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAutocompleteField<T extends Object>({
    required String label,
    required String hint,
    required Future<List<T>> Function(String) suggestionsCallback,
    required String Function(T) displayStringForOption,
    required void Function(T) onSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Obx(() {
        final controller = TextEditingController();
        if (T == Product && purchaseController.selectedProduct.value != null) {
          controller.text = purchaseController.selectedProduct.value!.id;
        }
        if (T == Warehouse &&
            purchaseController.selectedWarehouse.value != null) {
          controller.text = purchaseController.selectedWarehouse.value!.name;
        }
        if (T == Partner && purchaseController.selectedSupplier.value != null) {
          controller.text = purchaseController.selectedSupplier.value!.name;
        }

        return Autocomplete<T>(
          optionsBuilder: (TextEditingValue textEditingValue) async {
            return await suggestionsCallback(textEditingValue.text);
          },
          displayStringForOption: displayStringForOption,
          fieldViewBuilder:
              (context, textEditingController, focusNode, onFieldSubmitted) {
            textEditingController.text = controller.text; // Ensure it's updated
            return TextField(
              controller: textEditingController,
              focusNode: focusNode,
              decoration: InputDecoration(
                  labelText: label,
                  hintText: hint,
                  border: OutlineInputBorder()),
            );
          },
          onSelected: (value) {
            onSelected(value);
          },
        );
      }),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.number, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration:
            InputDecoration(labelText: label, border: OutlineInputBorder()),
        maxLines: maxLines,
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required List<String> items,
    required String selectedValue,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration:
            InputDecoration(labelText: label, border: OutlineInputBorder()),
        value: selectedValue,
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDateField(
      {required String label,
      required String value,
      required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        readOnly: true,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.calendar_today),
        ),
        controller: TextEditingController(text: value),
      ),
    );
  }
}
