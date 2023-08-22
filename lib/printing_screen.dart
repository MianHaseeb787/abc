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
        appBar: AppBar(
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
            children: [
              pw.Text(
                'Customer Bill',
                style: pw.TextStyle(fontSize: 10),
              ),

              for (var item in widget.selecteditems)
                pw.Text(
                  item.name!,
                  style: pw.TextStyle(fontSize: 6),
                ),

              // pw.SizedBox(
              //   width: double.infinity,
              //   child: pw.FittedBox(
              //     child: pw.Text(title,
              //         style: pw.TextStyle(font: font, fontSize: 10)),
              //   ),
              // ),

              pw.SizedBox(height: 10),
              // pw.Flexible(child: pw.FlutterLogo())
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}
