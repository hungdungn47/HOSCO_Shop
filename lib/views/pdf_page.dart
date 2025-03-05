import 'package:flutter/material.dart';
import 'package:hosco_shop_2/services/pdf_api.dart';
import 'package:hosco_shop_2/services/pdf_invoice_api.dart';
import 'package:hosco_shop_2/main.dart';
import 'package:hosco_shop_2/models/customer.dart';
import 'package:hosco_shop_2/models/invoice.dart';
import 'package:hosco_shop_2/models/supplier.dart';
import 'package:hosco_shop_2/utils/navigation_drawer.dart';
import 'package:pdf/pdf.dart';

import 'common_widgets/button_widget.dart';
import 'common_widgets/title_widget.dart';
// import 'package:generate_pdf_invoice_example/widget/button_widget.dart';
// import 'package:generate_pdf_invoice_example/widget/title_widget.dart';
import 'package:printing/printing.dart';

class PdfPage extends StatefulWidget {
  @override
  _PdfPageState createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    drawer: MyNavigationDrawer(),
    appBar: AppBar(
      title: Text("In hóa đơn"),
      centerTitle: true,
    ),
    body: Container(
      padding: EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TitleWidget(
              icon: Icons.picture_as_pdf,
              text: 'Generate Invoice',
            ),
            const SizedBox(height: 48),
            ButtonWidget(
              text: 'Invoice PDF',
              onClicked: () async {
                final date = DateTime.now();
                final dueDate = date.add(Duration(days: 7));

                final invoice = Invoice(
                  supplier: Supplier(
                    name: 'Sarah Field',
                    address: 'Sarah Street 9, Beijing, China',
                    paymentInfo: 'https://paypal.me/sarahfieldzz',
                  ),
                  customer: Customer(
                    name: 'Apple Inc.',
                    address: 'Apple Street, Cupertino, CA 95014',
                  ),
                  info: InvoiceInfo(
                    date: date,
                    dueDate: dueDate,
                    description: 'My description...',
                    number: '${DateTime.now().year}-9999',
                  ),
                  items: [
                    InvoiceItem(
                      description: 'Coffee',
                      date: DateTime.now(),
                      quantity: 3,
                      vat: 0.19,
                      unitPrice: 5.99,
                    ),
                    InvoiceItem(
                      description: 'Water',
                      date: DateTime.now(),
                      quantity: 8,
                      vat: 0.19,
                      unitPrice: 0.99,
                    ),
                    InvoiceItem(
                      description: 'Orange',
                      date: DateTime.now(),
                      quantity: 3,
                      vat: 0.19,
                      unitPrice: 2.99,
                    ),
                    InvoiceItem(
                      description: 'Apple',
                      date: DateTime.now(),
                      quantity: 8,
                      vat: 0.19,
                      unitPrice: 3.99,
                    ),
                    InvoiceItem(
                      description: 'Mango',
                      date: DateTime.now(),
                      quantity: 1,
                      vat: 0.19,
                      unitPrice: 1.59,
                    ),
                    InvoiceItem(
                      description: 'Blue Berries',
                      date: DateTime.now(),
                      quantity: 5,
                      vat: 0.19,
                      unitPrice: 0.99,
                    ),
                    InvoiceItem(
                      description: 'Lemon',
                      date: DateTime.now(),
                      quantity: 4,
                      vat: 0.19,
                      unitPrice: 1.29,
                    ),
                  ],
                );

                final pdfDocument = await PdfInvoiceApi.generate(invoice);

                await Printing.layoutPdf(
                    onLayout: (PdfPageFormat format) async => pdfDocument.save());
              },
            ),
          ],
        ),
      ),
    ),
  );
}