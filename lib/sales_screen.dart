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

  final List<double> totalAmountWTList = [];
  final List<double> vatList = [];

  double totalAmountWT = 0;
  double totalAmount = 0;
  double vat = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getData();
    print(totalAmountWT);
  }

  void getData() {
    totalAmountWT = 0;
    totalAmount = 0;
    vat = 0;
    // vat = 0;
    for (int i = 0; i < totalAmountWTList.length; i++) {
      totalAmountWT = totalAmountWT + totalAmountWTList[i];
      totalAmount = (totalAmountWT) / (1 + 0.05);
      vat = totalAmountWT - totalAmount;

      print('total amount $totalAmount');
      print('total amount with tax $totalAmountWT');
      print('Vat $vat');
    }

    print("TT $totalAmountWTList");
  }

  void addToBill(Menu selectedItem) {
    quantityList.add(1);

    eachitempriceList.add(selectedItem.price!);

    final double itemPrice = selectedItem.price! * 1;
    // final double amt =
    // ((selectedItem.price! * 1) * 0.05) + (1 * selectedItem.price!);
    // final double eachTax = ((selectedItem.price! * 1) * 0.05);

    // print("total amount$totalAmount");

    totalAmountWTList.add(itemPrice);
    // vatList.add(eachTax);

    // AMTList.add(amt);
    quantityControllerList.add(TextEditingController(text: '1'));
    priceControllerList.add(
        TextEditingController(text: selectedItem.price!.toStringAsFixed(2)));
    getData();

    // print("total amount$totalAmount");
    print(AMTList);

    setState(() {});
  }

  void updateBill(int index, int quantity, double price) {
    // print(index);
    // print("price $price");
    quantityList[index] = quantity;
    // print(quantityList[index]);

    final double itemPrice = price * quantity;
    print("this is item price $itemPrice");

    eachitempriceList[index] = price;
    print("each item list$eachitempriceList");

    // final double amt = ((price * 1) * 0.05) + (1 * price);

    // AMTList[index] = amt;

    // final double eachTax = ((price * quantity) * 0.05);

    totalAmountWTList[index] = itemPrice;
    // print('totamount list $totalAmountList');
    // print("total amount$totalAmount");

    // vatList[index] = eachTax;
    // print('vat list : $vatList');

    getData();
    // print("total amount$totalAmount");

    setState(() {});
  }

  void deleteSelectedItem(int index) {
    quantityList.removeAt(index);
    selectedItems.removeAt(index);
    AMTList.removeAt(index);
    totalAmountWTList.removeAt(index);
    vatList.removeAt(index);
    eachitempriceList.removeAt(index);

    getData();
    setState(() {});
  }

  void saveOrderdetail() {
    for (int i = 0; i < selectedItems.length; i++) {
      orderItemList.add(OrderItem(
          itemName: selectedItems[i].name!,
          itemPrice: eachitempriceList[i],
          quantity: quantityList[i]));
    }

    boxOrders.put(
        'key_${DateTime.now()}',
        CustomerOrder(
            customerName: '',
            VAT: vat,
            orderItems: orderItemList,
            totalAmount: totalAmountWT,
            totalWithTax: (totalAmountWT + vat),
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
                          color: Color.fromARGB(255, 240, 240, 240),
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
                                  itemExtent: 120,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 0),
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
                                            10, // Adjust the elevation (shadow) of the Card
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Image.file(File(cat!.img!),
                                                  fit: BoxFit.cover),
                                            ),
                                            // SizedBox(
                                            //   width: 5,
                                            // ),
                                            Expanded(
                                              flex: 2,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(18.0),
                                                child: Text(
                                                  cat.name!,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    // fontWeight:
                                                    //     FontWeight.bold
                                                  ),
                                                ),
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
                          color: Color.fromARGB(255, 174, 174, 174),
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
                      color: Color.fromARGB(255, 255, 255, 255),
                      child: Row(
                        children: [
                          // selected items screen
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 10),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 149, 149, 149),
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
                                  Divider(
                                    thickness: 2,
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
                                                (index + 1).toString(),
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
                                color: Color.fromARGB(255, 149, 149, 149),
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
                                                // color: Colors.black
                                              ),
                                            ),
                                            Text(
                                              ((totalAmountWT) / (1 + 0.05))
                                                  .toStringAsFixed(2),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25,
                                                // color: Colors.black
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
                                                // color: Colors.black
                                              ),
                                            ),
                                            Text(
                                              (totalAmountWT -
                                                      ((totalAmountWT) /
                                                          (1 + 0.05)))
                                                  .toStringAsFixed(2),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25,
                                                // color: Colors.black
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
                                              'Total with Tax :   ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 20,
                                                // color: Colors.black
                                              ),
                                            ),
                                            Text(
                                              (totalAmountWT)
                                                  .toStringAsFixed(2),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25,
                                                // color: Colors.black
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.black,
                                                  fixedSize: Size(150, 30)),
                                              onPressed: () {
                                                saveOrderdetail();
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          PrintingScreen(
                                                              eachItemPriceList:
                                                                  eachitempriceList,
                                                              vatList: vatList,
                                                              totalAmountList:
                                                                  totalAmountWTList,
                                                              selecteditems:
                                                                  selectedItems,
                                                              amtList: AMTList,
                                                              quantityList:
                                                                  quantityList,
                                                              totalAmountWT:
                                                                  totalAmountWT,
                                                              vat: vat)),
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
