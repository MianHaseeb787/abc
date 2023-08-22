import 'dart:io';
// import 'dart:js_util';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:rms/Hive/category.dart';
import 'package:rms/boxes.dart';
import 'package:rms/printing_screen.dart';

import 'Hive/customerOrder.dart';
import 'Hive/menu.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  List<TextEditingController> quantityControllerList = [];
  List<TextEditingController> priceControllerList = [];

  String? selCat;
  List<Menu> filteredMenuItems = [];
  final List<Menu> selectedItems = [];

  final List<Menu> menuItems = [];
  // final List<Menu> selectedItems = [];
  final List<int> quantityList = [];
  final List<double> eachitempriceList = [];
  final List<double> AMTList = [];
  final List<OrderItem> orderItemList = [];

  final List<double> totalAmountList = [];
  final List<double> vatList = [];

  double totalAmount = 0;
  double vat = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getData();
    print(totalAmount);
  }

  void getData() {
    totalAmount = 0;
    vat = 0;
    for (int i = 0; i < totalAmountList.length; i++) {
      totalAmount = totalAmount + totalAmountList[i];
      vat += vatList[i];
    }

    print(totalAmountList);
  }

  void addToBill(Menu selectedItem) {
    quantityList.add(1);

    eachitempriceList.add(selectedItem.price!);

    final double itemPrice = selectedItem.price! * 1;
    final double amt =
        ((selectedItem.price! * 1) * 0.05) + (1 * selectedItem.price!);
    final double eachTax = ((selectedItem.price! * 1) * 0.05);

    print("total amount$totalAmount");

    totalAmountList.add(itemPrice);
    vatList.add(eachTax);

    AMTList.add(amt);
    quantityControllerList.add(TextEditingController(text: '1'));
    priceControllerList
        .add(TextEditingController(text: selectedItem.price.toString()));
    getData();

    print("total amount$totalAmount");

    setState(() {});
  }

  void updateBill(int index, int quantity, double price) {
    print(index);
    print(price);
    quantityList[index] = quantity;
    print(quantityList[index]);

    final double itemPrice = price * quantity;
    print(itemPrice);

    final double amt = ((price * quantity) * 0.05) + (quantity * price);
    AMTList[index] = amt;

    final double eachTax = ((price * quantity) * 0.05);

    totalAmountList[index] = itemPrice;
    print("total amount$totalAmount");

    vatList[index] = eachTax;

    getData();
    print("total amount$totalAmount");

    setState(() {});
  }

  void deleteSelectedItem(int index) {
    quantityList.removeAt(index);
    selectedItems.removeAt(index);
    AMTList.removeAt(index);
    totalAmountList.removeAt(index);
    vatList.removeAt(index);

    getData();
    setState(() {});
  }

  void saveOrderdetail() {
    for (int i = 0; i < selectedItems.length; i++) {
      orderItemList.add(OrderItem(
          itemName: selectedItems[i].name!, quantity: quantityList[i]));
    }

    boxOrders.put(
        'key_${DateTime.now()}',
        CustomerOrder(
            customerName: '',
            VAT: vat,
            orderItems: orderItemList,
            totalAmount: totalAmount,
            totalWithTax: (totalAmount + vat),
            orderDate: DateTime.now()));

    print('added to cache');

    for (int i = 0; i < orderItemList.length; i++) {
      print(orderItemList[i].itemName);
    }

    // boxMenus.put('key', Menu(name: name, price: price, category: category))
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales'),
      ),
      body: Container(
        color: Color.fromARGB(255, 255, 255, 255),
        child: Row(
          children: [
            // category column starts here
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                        width: double.infinity,
                        // height: double.infinity,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 62, 62, 62),
                          border: Border.all(
                            color: Color.fromARGB(
                                255, 255, 255, 255), // Border color
                            width: 2.0, // Border width
                          ),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                  // gridDelegate:
                                  //     SliverGridDelegateWithFixedCrossAxisCount(
                                  //         crossAxisCount:
                                  //             1, // Adjust the number of columns as needed
                                  //         // crossAxisSpacing:
                                  //         //     15.0, // Set the spacing between columns
                                  //         // mainAxisSpacing:
                                  //         //     15.0, // Set the spacing between rows

                                  //         childAspectRatio: 2.5),
                                  itemCount: boxCategorys.length,
                                  itemBuilder: (context, index) {
                                    MenuCategory? cat =
                                        boxCategorys.getAt(index);
                                    return GestureDetector(
                                      onDoubleTap: () {
                                        setState(() {
                                          boxCategorys.deleteAt(index);
                                        });
                                      },
                                      onTap: () {
                                        setState(() {
                                          selCat = cat!.name!;

                                          filteredMenuItems = boxMenus.values
                                              .where(
                                                (menu) =>
                                                    menu.category == selCat,
                                              )
                                              .toList();
                                        });
                                      },
                                      child: Card(
                                        elevation:
                                            4, // Adjust the elevation (shadow) of the Card
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                                width: 120,
                                                height: 70,
                                                child: Image.file(
                                                  File(cat!.img!),
                                                  fit: BoxFit.cover,
                                                )),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              child: Text(
                                                cat.name!,
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            )
                          ],
                        )),
                  )
                ],
              ),
            ),

            //  category column ends here

            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    // selected Category screen
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 106, 106, 106),
                          border: Border.all(
                            color: Color.fromARGB(
                                255, 255, 255, 255), // Border color
                            width: 1.0, // Border width
                          ),
                        ),
                        child: GridView.builder(
                          scrollDirection: Axis.vertical,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisExtent: 120,
                            mainAxisSpacing: 2, // Adjust spacing between rows
                            crossAxisSpacing:
                                8, // Adjust spacing between columns
                          ),
                          itemCount: filteredMenuItems.length,
                          itemBuilder: (context, index) {
                            final e = filteredMenuItems[index];
                            return GestureDetector(
                              onTap: () {
                                print(e.name);
                                setState(() {
                                  selectedItems.add(e);
                                  addToBill(e);
                                });
                              },
                              child: Card(
                                margin: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 0),
                                elevation: 6,
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Image.file(
                                        File(e!.img!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            e.name!,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            e.price.toString(),
                                            textAlign: TextAlign.start,
                                          ),
                                          Text(
                                            e.size!,
                                            textAlign: TextAlign.start,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )),
                  ),
                  Expanded(
                    child: Container(
                      color: Color.fromARGB(255, 62, 62, 62),
                      child: Row(
                        children: [
                          // selected items screen
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 10),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 62, 62, 62),
                                border: Border.all(
                                  color: Color.fromARGB(
                                      255, 255, 255, 255), // Border color
                                  width: 2.0, // Border width
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "#",
                                        textAlign: TextAlign.start,
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                          flex: 2,
                                          child: Text(
                                            "Product name",
                                            textAlign: TextAlign.start,
                                          )),
                                      Expanded(
                                        child: Text(
                                          "Price",
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      Expanded(
                                          child: Text(
                                        "Quantity",
                                        textAlign: TextAlign.start,
                                      )),
                                      Expanded(
                                          child: Text(
                                        "Size",
                                        textAlign: TextAlign.center,
                                      )),
                                    ],
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: selectedItems.length,
                                      itemBuilder: (context, index) {
                                        final menuItem = selectedItems[index];
                                        return GestureDetector(
                                          onDoubleTap: () {
                                            deleteSelectedItem(index);
                                          },
                                          onTap: () {
                                            print(menuItem.name);
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                index.toString(),
                                                textAlign: TextAlign.start,
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    menuItem.name!,
                                                    textAlign: TextAlign.start,
                                                  )),
                                              Expanded(
                                                // width: 80,
                                                child: TextFormField(
                                                  textAlign: TextAlign.start,
                                                  onEditingComplete: () {
                                                    updateBill(
                                                        index,
                                                        int.parse(
                                                            quantityControllerList[
                                                                    index]
                                                                .text),
                                                        double.parse(
                                                            priceControllerList[
                                                                    index]
                                                                .text));
                                                  },
                                                  controller:
                                                      priceControllerList[
                                                          index],
                                                  // initialValue: menuItem
                                                  //     .price
                                                  //     .toString(),
                                                  onChanged: (value) {
                                                    // Handle price changes here
                                                    // You can update the menuItem.price with the new value
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: TextFormField(
                                                  textAlign: TextAlign.start,
                                                  // enabled: false,
                                                  onEditingComplete: () {
                                                    print(
                                                        quantityControllerList[
                                                                index]
                                                            .text);

                                                    updateBill(
                                                        index,
                                                        int.parse(
                                                            quantityControllerList[
                                                                    index]
                                                                .text),
                                                        double.parse(
                                                            priceControllerList[
                                                                    index]
                                                                .text));
                                                  },
                                                  controller:
                                                      quantityControllerList[
                                                          index],
                                                  // initialValue:
                                                  //     '1', // Initial quantity value
                                                  onChanged: (value) {
                                                    // Handle quantity changes here
                                                    // You can update the quantity value
                                                  },
                                                ),
                                              ),
                                              Expanded(
                                                  child: Text(
                                                'N',
                                                textAlign: TextAlign.center,
                                              )),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Detail adding screen
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 62, 62, 62),
                                border: Border.all(
                                  color: Color.fromARGB(
                                      255, 255, 255, 255), // Border color
                                  width: 2.0, // Border width
                                ),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              'Total Amount :   ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 20,
                                              ),
                                            ),
                                            Text(
                                              totalAmount.toStringAsFixed(2),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 50,
                                            ),
                                            Text(
                                              'VAT :   ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 20,
                                              ),
                                            ),
                                            Text(
                                              vat.toStringAsFixed(2),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Divider(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              'Total with tax :   ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 20,
                                              ),
                                            ),
                                            Text(
                                              (totalAmount + vat)
                                                  .toStringAsFixed(2),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  fixedSize: Size(150, 30)),
                                              onPressed: () {
                                                saveOrderdetail();
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          PrintingScreen(
                                                              selectedItems)),
                                                );
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text("Print"),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Icon(Icons.print),
                                                ],
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  // Expanded(
                  //   // flex: 2,
                  //   child: Container(
                  //     width: double.infinity,
                  //     // height: double.infinity,
                  //     decoration:
                  //         BoxDecoration(color: Color.fromARGB(255, 98, 89, 62)),
                  //     child: Text('abc'),
                  //   ),
                  // )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
