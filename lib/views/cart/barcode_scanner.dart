import 'package:flutter/material.dart';
import 'package:hosco_shop_2/utils/navigation_drawer.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class BarcodeScanner extends StatefulWidget {
  const BarcodeScanner({super.key});
  @override
  State<BarcodeScanner> createState() => _BarcodeScannerState();
}

class _BarcodeScannerState extends State<BarcodeScanner> {
  String result = "Result";
  List<String> barcodeList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: MyNavigationDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1)
              ),

              child: SimpleBarcodeScanner(
                scaleHeight: 200,
                scaleWidth: 400,
                onScanned: (code) {
                  print(code);
                  setState(() {
                    barcodeList.add(code);
                  });
                },
                continuous: true,
                onBarcodeViewCreated: (BarcodeViewController controller) {
                  controller = controller;
                },
              )
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: barcodeList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(barcodeList[index]),
                  );
                },
              ),
            )
          ],
        ),
      )
    );
  }
}
