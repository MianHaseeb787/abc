import 'package:flutter/material.dart';
import 'package:rms/Hive/dailySales.dart'; // Import the correct path for DailySales
import 'package:rms/boxes.dart'; // Import the correct path for boxes

class DailySalesScreen extends StatefulWidget {
  const DailySalesScreen({super.key});

  @override
  State<DailySalesScreen> createState() => _DailySalesScreenState();
}

class _DailySalesScreenState extends State<DailySalesScreen> {
  @override
  Widget build(BuildContext context) {
    List<DataRow> dataRows = []; // List to store DataRow widgets
    for (int index = 0; index < boxDailySales.length; index++) {
      DailySales? sales = boxDailySales.getAt(index);
      dataRows.add(DataRow(
        cells: [
          DataCell(Text(
            '${sales!.date.day.toString()}-${sales.date.month.toString()}-${sales.date.year.toString()}',
          )),
          DataCell(Text(sales.totalAmount.toStringAsFixed(2))),
          DataCell(Text(sales.tax.toStringAsFixed(2))),
          DataCell(Text(sales.totalWithTax.toStringAsFixed(2))),
        ],
      ));
    }

    return Scaffold(
      appBar: AppBar(title: Text('Daily sales')),
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
