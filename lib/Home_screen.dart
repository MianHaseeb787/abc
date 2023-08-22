// import 'package:authentication/menu_screen.dart';
import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart' as path_provider;
// import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:hive/hive.dart';
import 'package:printing/printing.dart';
import 'package:rms/Hive/category.dart';
import 'package:rms/Hive/monthlySales.dart';
import 'package:rms/MonthlySales_screen.dart';
import 'package:rms/Record_screen.dart';
import 'package:rms/dailySales_screen.dart';
import 'package:rms/employee_screen.dart';
import 'package:rms/generateBill_Screen.dart';
import 'package:rms/sales_screen.dart';

import 'Hive/customerOrder.dart';
import 'Hive/dailySales.dart';
import 'Menu_screen.dart';
import 'boxes.dart';
import 'package:intl/intl.dart';

import 'posprinting_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double dailySalesTotalAmount = 0.0;
  double dailySalesTotalAmountWithTax = 0.0;
  double dailySalesTax = 0.0;

  double monthlySalesTotalAmount = 0.0;
  double monthlySalesTotalAmountWithTax = 0.0;
  double monthlySalesTax = 0.0;

  @override
  void initState() {
    super.initState();

    Timer.periodic(Duration(seconds: 1), (Timer timer) {
      // Call your function here
      calculateAndSaveDailySales();
      calculateMonthlySales();
    });
  }

  void calculateAndSaveDailySales() {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);

    double tamount = 0.0;
    double ttax = 0.0;
    double twtax = 0.0;

    for (int i = 0; i < boxOrders.length; i++) {
      CustomerOrder? order = boxOrders.getAt(i);
      if (order != null &&
          order.orderDate.day == today.day &&
          order.orderDate.month == today.month &&
          order.orderDate.day == today.day) {
        twtax += order.totalWithTax;
        ttax += order.VAT;
        tamount += order.totalAmount;
        // print(twtax);
      }
    }

    setState(() {
      dailySalesTax = ttax;
      dailySalesTotalAmount = tamount;
      dailySalesTotalAmountWithTax = twtax;
    });

    // // Save daily sales to Hive with the current date
    // final dailySalesBox = Hive.box<DailySales>('dailySalesBox');
    boxDailySales.put(
        'daily_sales_${today.millisecondsSinceEpoch}',
        DailySales(
            date: today,
            tax: dailySalesTax,
            totalAmount: dailySalesTotalAmount,
            totalWithTax: dailySalesTotalAmountWithTax));
  }

// Import the intl package for date formatting

  void calculateMonthlySales() {
    final DateTime now = DateTime.now();
    final DateFormat formatter =
        DateFormat('MM-yyyy'); // Format to extract month and year

    // Get the current month and year as a formatted string
    final String currentMonthYear = formatter.format(now);

    // double totalSales = 0;
    double tamount = 0.0;
    double ttax = 0.0;
    double twtax = 0.0;

    for (int i = 0; i < boxOrders.length; i++) {
      CustomerOrder? order = boxOrders.getAt(i);

      // Extract the month and year from the order date
      final String orderMonthYear = formatter.format(order!.orderDate);

      if (orderMonthYear == currentMonthYear) {
        twtax += order.totalWithTax;
        ttax += order.VAT;
        tamount += order.totalAmount;
      }
    }

    setState(() {
      monthlySalesTax = ttax;
      monthlySalesTotalAmount = tamount;
      monthlySalesTotalAmountWithTax = twtax;
    });

    boxMonthlySales.put(
        'daily_sales_${currentMonthYear}}',
        MonthlySales(
            date: currentMonthYear,
            tax: monthlySalesTax,
            totalAmount: monthlySalesTotalAmount,
            totalWithTax: monthlySalesTotalAmountWithTax));
  }

  // Future<void> _showMyDialog() async {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: true, // user must tap button!
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Add new Category'),
  //         content: SingleChildScrollView(
  //           child: ListBody(
  //             children: <Widget>[
  //               TextField(
  //                 controller: nameController,
  //                 decoration: InputDecoration(hintText: 'Name'),
  //               ),
  //               TextField(
  //                 onTap: () async {
  //                   final imagePath = await pickAndSaveImage();
  //                   imgController.text = imagePath!;
  //                 },
  //                 controller: imgController,
  //                 decoration: InputDecoration(
  //                   hintText: 'Browse Image',
  //                   prefixIcon:
  //                       Icon(Icons.image_rounded), // Add the leading icon here
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text('cancel'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           TextButton(
  //             child: const Text('Save'),
  //             onPressed: () {
  //               setState(() {
  //                 boxCategorys.put(
  //                     'key_${nameController}',
  //                     MenuCategory(
  //                         name: nameController.text, img: imgController.text));
  //               });

  //               print('category added');

  //               nameController.clear();

  //               imgController.clear();

  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Future<String?> pickAndSaveImage() async {
    final typeGroup = XTypeGroup(label: 'images', extensions: ['jpg', 'png']);
    final file = await openFile(acceptedTypeGroups: [typeGroup]);

    if (file != null) {
      final fileName = file.name;
      final appDir = await path_provider.getApplicationDocumentsDirectory();
      final savedImagePath = '${appDir.path}/$fileName';

      final imageFile = File(savedImagePath);
      await imageFile.writeAsBytes(await file.readAsBytes());

      return imageFile.path;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                    child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DailySalesScreen()),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      padding: EdgeInsets.only(right: 40),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromARGB(255, 55, 55, 54),
                      ),
                      height: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // 1
                          Container(
                            // padding: EdgeInsets.all(10),
                            // decoration: BoxDecoration(color: Colors.amber),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10)),
                                      color:
                                          Color.fromARGB(255, 238, 235, 221)),
                                  child: Text(
                                    'Total',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10)),
                                      color: Color.fromARGB(255, 206, 18, 18)),
                                  child: Text(
                                    '${dailySalesTotalAmount.toStringAsFixed(2)}',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(
                            height: 10,
                          ),

                          // 2
                          Container(
                            // padding: EdgeInsets.all(10),
                            // decoration: BoxDecoration(color: Colors.amber),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10)),
                                      color:
                                          Color.fromARGB(255, 238, 235, 221)),
                                  child: Text(
                                    'TAX',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                                    color: Color.fromARGB(255, 206, 18, 18),
                                  ),
                                  child: Text(
                                    '${dailySalesTax.toStringAsFixed(2)}',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),

                          // 3

                          Container(
                            // padding: EdgeInsets.all(10),
                            // decoration: BoxDecoration(color: Colors.amber),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 25),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          bottomLeft: Radius.circular(20)),
                                      color:
                                          Color.fromARGB(255, 238, 235, 221)),
                                  child: Text(
                                    'Daily sale',
                                    style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          bottomRight: Radius.circular(20)),
                                      color: Color.fromARGB(255, 206, 18, 18)),
                                  child: Text(
                                    '${dailySalesTotalAmountWithTax.toStringAsFixed(2)}',
                                    style: TextStyle(fontSize: 25),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),

                // montly sales
                Expanded(
                    child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MonthlySalesScreen()),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      padding: EdgeInsets.only(right: 40),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromARGB(255, 55, 55, 54),
                      ),
                      height: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // 1
                          Container(
                            // padding: EdgeInsets.all(10),
                            // decoration: BoxDecoration(color: Colors.amber),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10)),
                                      color:
                                          Color.fromARGB(255, 238, 235, 221)),
                                  child: Text(
                                    'Total',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10)),
                                      color: Color.fromARGB(255, 36, 116, 243)),
                                  child: Text(
                                    '${monthlySalesTotalAmount.toStringAsFixed(2)}',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(
                            height: 10,
                          ),

                          // 2
                          Container(
                            // padding: EdgeInsets.all(10),
                            // decoration: BoxDecoration(color: Colors.amber),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10)),
                                      color:
                                          Color.fromARGB(255, 238, 235, 221)),
                                  child: Text(
                                    'TAX',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                                    color: Color.fromARGB(255, 36, 116, 243),
                                  ),
                                  child: Text(
                                    '${monthlySalesTax.toStringAsFixed(2)}',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),

                          // 3

                          Container(
                            // padding: EdgeInsets.all(10),
                            // decoration: BoxDecoration(color: Colors.amber),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 25),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          bottomLeft: Radius.circular(20)),
                                      color:
                                          Color.fromARGB(255, 238, 235, 221)),
                                  child: Text(
                                    'Monthly Sales',
                                    style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          bottomRight: Radius.circular(20)),
                                      color: Color.fromARGB(255, 36, 116, 243)),
                                  child: Text(
                                    '${monthlySalesTotalAmountWithTax.toStringAsFixed(2)}',
                                    style: TextStyle(fontSize: 25),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
                Expanded(
                    // flex: 1,
                    child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SalesScreen()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromARGB(255, 99, 105, 103),
                      ),
                      height: double.infinity,
                      // color: Color.fromARGB(255, 254, 106, 0),
                      child: Row(
                        // mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 50),
                            child: Text(
                              'Generate Bill',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                // letterSpacing: 1.2
                              ),
                            ),
                          ),
                          Image.asset(
                            './assets/images/receipt.png',
                            width: 250,
                            height: 300,
                          )
                        ],
                      ),
                    ),
                  ),
                )),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MenuScreen()),
                  );
                },
                child: Row(
                  children: [
                    Expanded(
                      // fle sx: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromARGB(255, 208, 207, 207),
                          ),
                          width: double.infinity,
                          height: double.infinity,
                          // color: Color.fromARGB(255, 255, 7, 7),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      'Menu',
                                      style: TextStyle(
                                        fontSize: 34,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Image.asset(
                                    './assets/images/menu.png',
                                    width: 150,
                                    height: 150,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Expanded(
                    //   child: Container(
                    //       decoration: BoxDecoration(
                    //         // borderRadius: BorderRadius.circular(10),
                    //         color: Color.fromARGB(255, 214, 213, 211),
                    //       ),
                    //       width: double.infinity,
                    //       clipBehavior: Clip.hardEdge,
                    //       height: double.infinity,
                    //       // color: Color.fromARGB(255, 255, 7, 7),
                    //       child: Image.asset(
                    //         'assets/images/kheer.jpeg',
                    //         fit: BoxFit.cover,
                    //       )),
                    // ),
                    Expanded(
                      // flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          // padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromARGB(255, 208, 207, 207),
                          ),
                          width: double.infinity,
                          height: double.infinity,
                          // color: Color.fromARGB(255, 255, 7, 7),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      'Inventory',
                                      style: TextStyle(
                                        fontSize: 34,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    ),
                                  ),
                                  Image.asset(
                                    './assets/images/inventory.png',
                                    width: 150,
                                    height: 150,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  // flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RecordScreen()),
                        );
                      },
                      child: Container(
                        // padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromARGB(255, 208, 207, 207),
                        ),
                        width: double.infinity,
                        height: double.infinity,
                        // color: Color.fromARGB(255, 255, 7, 7),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    'Records',
                                    style: TextStyle(
                                      fontSize: 34,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ),
                                ),
                                Image.asset(
                                  './assets/images/records.png',
                                  width: 150,
                                  height: 150,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  // flex: 3,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyApp()),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        // padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromARGB(255, 208, 207, 207),
                        ),
                        width: double.infinity,
                        height: double.infinity,
                        // color: Color.fromARGB(255, 255, 7, 7),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    'Employe Data',
                                    style: TextStyle(
                                      fontSize: 34,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ),
                                ),
                                Image.asset(
                                  './assets/images/employee.png',
                                  width: 150,
                                  height: 150,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        width: 200,
        child: FloatingActionButton(
            backgroundColor: Colors.blue,
            isExtended: true,
            // mouseCursor: Icons(Icons.add),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            onPressed: () {
              // _showMyDialog();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Settings'),
                SizedBox(
                  width: 20,
                ),
                Icon(Icons.settings),
              ],
            )),
      ),
    );
  }
}
