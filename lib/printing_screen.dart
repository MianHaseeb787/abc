// ignore_for_file: public_member_api_docs

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:rms/Home_screen.dart';
import 'package:rms/Menu_screen.dart';
import 'package:rms/generateBill_Screen.dart';

import 'Hive/menu.dart';

class PrintingScreen extends StatefulWidget {
  PrintingScreen(this.selecteditems, {Key? key}) : super(key: key);

  List<Menu> selecteditems;

  @override
  State<PrintingScreen> createState() => _PrintingScreenState();
}

class _PrintingScreenState extends State<PrintingScreen> {
  // final String title;
  @override
  void initState() {
    super.initState();

    // print(selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // backgroundColor: Colors.amber,
        appBar: AppBar(
            backgroundColor: Colors.black,
            // automaticallyImplyLeading: false,
            leading: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.arrow_back)),
            title: Text('Customer Bill')),
        body: PdfPreview(
          build: (format) => _generatePdf('customer bill'),
        ),
      ),
    );
  }

  Future<Uint8List> _generatePdf(String title) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font = await PdfGoogleFonts.nunitoExtraLight();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(
                'PAK JINNAH SWEETS & REST',
                style: pw.TextStyle(
                  fontSize: 10,
                  //  font: font, fontWeight: pw.FontWeight.bold
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                'Binary Tower, Shop G-12, DUBAI',
                style: pw.TextStyle(
                  fontSize: 4,
                ),
              ),

              pw.Text(
                'TEL: 04-589 4589',
                style: pw.TextStyle(
                  fontSize: 4,
                ),
              ),
              pw.Text(
                'Mobile: 055-8144018 whatsapp',
                style: pw.TextStyle(
                  fontSize: 4,
                ),
              ),
              pw.Text(
                'Email: pakjinnahbussinessbay@gmail.com',
                style: pw.TextStyle(
                  fontSize: 4,
                ),
              ),
              pw.Text(
                'Website: www.pakjinnah.com',
                style: pw.TextStyle(
                  fontSize: 4,
                ),
              ),
              pw.Text(
                'TRN: 100575280100003',
                style: pw.TextStyle(
                  fontSize: 4,
                ),
              ),

              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  // crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Column(children: [
                      pw.Text(
                          'Date ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                          style: pw.TextStyle(fontSize: 4)),
                      pw.Text(
                          'Time ${DateTime.now().hour}:${DateTime.now().minute}::${DateTime.now().second}',
                          style: pw.TextStyle(fontSize: 4)),
                    ])
                  ]),

              pw.Divider(),

              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Expanded(
                      flex: 2,
                      child: pw.Text('Item Name',
                          style: pw.TextStyle(fontSize: 5)),
                    ),
                    pw.Expanded(
                      child: pw.Text('Price',
                          style: pw.TextStyle(fontSize: 5),
                          textAlign: pw.TextAlign.center),
                    ),
                    pw.Expanded(
                      child: pw.Text('Qty',
                          style: pw.TextStyle(fontSize: 5),
                          textAlign: pw.TextAlign.center),
                    ),
                    pw.Expanded(
                      child: pw.Text('AMT',
                          style: pw.TextStyle(fontSize: 5),
                          textAlign: pw.TextAlign.center),
                    ),
                  ]),

              pw.Divider(),

              for (var item in widget.selecteditems)
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      pw.Expanded(
                        flex: 2,
                        child: pw.Text(item.name!,
                            style: pw.TextStyle(fontSize: 5)),
                      ),
                      pw.Expanded(
                        child: pw.Text('Price',
                            style: pw.TextStyle(fontSize: 5),
                            textAlign: pw.TextAlign.center),
                      ),
                      pw.Expanded(
                        child: pw.Text('Qty',
                            style: pw.TextStyle(fontSize: 5),
                            textAlign: pw.TextAlign.center),
                      ),
                      pw.Expanded(
                        child: pw.Text('AMT',
                            style: pw.TextStyle(fontSize: 5),
                            textAlign: pw.TextAlign.center),
                      ),
                    ]),

              pw.Divider(),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Total Amount',
                      style: pw.TextStyle(fontSize: 5),
                    ),
                    pw.Text(
                      '60.95',
                      style: pw.TextStyle(fontSize: 5),
                    ),
                  ]),

              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'VAT 5.00%',
                      style: pw.TextStyle(fontSize: 5),
                    ),
                    pw.Text(
                      '3.05',
                      style: pw.TextStyle(fontSize: 5),
                    ),
                  ]),

              pw.Divider(),

              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Total with Tax',
                      style: pw.TextStyle(fontSize: 5),
                    ),
                    pw.Text(
                      '3.05',
                      style: pw.TextStyle(fontSize: 5),
                    ),
                  ]),

              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Cash Received',
                      style: pw.TextStyle(fontSize: 5),
                    ),
                    pw.Text(
                      '3.05',
                      style: pw.TextStyle(fontSize: 5),
                    ),
                  ]),

              pw.SizedBox(height: 10),

              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('No. of Items: 4',
                        style: pw.TextStyle(fontSize: 8)),
                  ]),

              pw.Divider(),
              pw.Text('THANK YOU FOR VISITING',
                  style: pw.TextStyle(fontSize: 8)),

              // pw.SizedBox(
              //   width: double.infinity,
              //   child: pw.FittedBox(
              //     child: pw.Text(title,
              //         style: pw.TextStyle(font: font, fontSize: 10)),
              //   ),
              // ),

              // pw.Flexible(child: pw.FlutterLogo())
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}
