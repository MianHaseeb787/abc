import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rms/Hive/customerOrder.dart';
import 'boxes.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({Key? key}) : super(key: key);

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  DateTime? previousDate;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Records'),
      ),
      body: ListView.builder(
        reverse: true,
        itemCount: boxOrders.length,
        itemBuilder: (context, index) {
          CustomerOrder? order = boxOrders.getAt(index);
          // int month = order!.orderDate.month;
          // Check if it's the start of a new month
          bool isNewMonth = previousDate == null ||
              order?.orderDate.month != previousDate?.month ||
              order?.orderDate.year != previousDate?.year;

          // Update previousDate for the next iteration
          previousDate = order?.orderDate;
          return Column(
            children: [
              // if (isNewMonth)
              //   Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Text(
              //       DateFormat('MMMM yyyy').format(order!.orderDate),
              //       style: TextStyle(
              //         fontSize: 20,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //   ),
              Divider(),
              ExpansionTile(
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // if (isNewMonth)
                  ],
                ),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order Number: ${index + 1}'),
                    Text(
                        'Date: ${order?.orderDate.day}-${order?.orderDate.month}-${order?.orderDate.year}   & Time : ${order?.orderDate.hour}:${order?.orderDate.minute}:${order?.orderDate.second}'),
                    // Text('Time: ${order.orderTim.toString()}'),
                    Text(
                        'Total with Tax: ${order!.totalWithTax.toStringAsFixed(2)}'),
                  ],
                ),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Ordered Items & quantity',
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          DataTable(
                            columns: [
                              DataColumn(label: Text('Item Name')),
                              DataColumn(label: Text('Item Price')),
                              DataColumn(label: Text('Quantity')),
                            ],
                            rows: order!.orderItems.map((orderItem) {
                              return DataRow(cells: [
                                DataCell(Text(orderItem.itemName)),
                                DataCell(Text(orderItem.itemPrice.toString())),
                                DataCell(Text(orderItem.quantity.toString())),
                              ]);
                            }).toList(),
                          ),
                        ],
                      ),

                      // Money table

                      DataTable(columns: [
                        DataColumn(label: Text('VAT')),
                        DataColumn(label: Text('Total Amount')),
                        DataColumn(label: Text('Total with Tax')),
                      ], rows: [
                        DataRow(cells: [
                          DataCell(Text(order.VAT.toStringAsFixed(2))),
                          DataCell(Text(order.totalAmount.toStringAsFixed(2))),
                          DataCell(Text(order.totalWithTax.toStringAsFixed(2))),
                        ])
                      ]),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
