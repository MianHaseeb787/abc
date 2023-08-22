import 'package:flutter/material.dart';
import 'package:rms/Hive/dailySales.dart'; // Import the correct path for DailySales
import 'package:rms/Hive/monthlySales.dart';
import 'package:rms/boxes.dart'; // Import the correct path for boxes

class MonthlySalesScreen extends StatefulWidget {
  const MonthlySalesScreen({super.key});

  @override
  State<MonthlySalesScreen> createState() => _MonthlySalesScreenState();
}

class _MonthlySalesScreenState extends State<MonthlySalesScreen> {
  @override
  Widget build(BuildContext context) {
    List<DataRow> dataRows = []; // List to store DataRow widgets
    for (int index = 0; index < boxMonthlySales.length; index++) {
      MonthlySales? sales = boxMonthlySales.getAt(index);
      dataRows.add(DataRow(
        cells: [
          DataCell(Text(
            sales!.date,
          )),
          DataCell(Text(sales.totalAmount.toStringAsFixed(2))),
          DataCell(Text(sales.tax.toStringAsFixed(2))),
          DataCell(Text(sales.totalWithTax.toStringAsFixed(2))),
        ],
      ));
    }

    return Scaffold(
      appBar: AppBar(title: Text('Monthly sales')),
      body: ListView(
        children: [
          DataTable(
            columns: [
              DataColumn(label: Text('Date')),
              DataColumn(label: Text('Total Amount')),
              DataColumn(label: Text('TAX')),
              DataColumn(label: Text('Total With TAX')),
            ],
            rows: dataRows, // Use the list of DataRow widgets here
          ),
        ],
      ),
    );
  }
}
