// // import 'dart:typed_data';

// import 'package:autocomplete_textfield/autocomplete_textfield.dart';
// // import 'package:esc_pos_utils/esc_pos_utils.dart';
// import 'package:flutter/material.dart';
// // import 'package:hive/hive.dart';
// // import 'package:hive_flutter/hive_flutter.dart';
// // import 'package:rms/Hive/customerOrder.dart';
// import 'Hive/customerOrder.dart';
// import 'boxes.dart';
// // import 'package:rms/boxes.dart';
// // import 'dart:io';
// // import 'package:path_provider/path_provider.dart';

// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import 'package:rms/printing_screen.dart';

// import 'Hive/menu.dart';

// class BillScreen extends StatefulWidget {
//   @override
//   _BillScreenState createState() => _BillScreenState();
// }

// class _BillScreenState extends State<BillScreen> {
//   final GlobalKey<AutoCompleteTextFieldState<Menu>> autoCompleteKey =
//       GlobalKey();

//   final TextEditingController itemController = TextEditingController();
//   final TextEditingController quantityController = TextEditingController();
//   final List<Menu> menuItems = [];
//   final List<Menu> selectedItems = [];
//   final List<int> quantityList = [];
//   final List<double> eachitempriceList = [];
//   final List<double> AMTList = [];
//   final List<OrderItem> orderItemList = [];

//   double totalAmount = 0;
//   double VAT = 0;

//   @override
//   void initState() {
//     super.initState();
//     getMenuItems();
//   }

//   @override
//   void dispose() {
//     itemController.dispose();
//     quantityController.dispose();
//     super.dispose();
//   }

//   void getMenuItems() {
//     // final box = Hive.box('menu');
//     for (var i = 0; i < boxMenus.length; i++) {
//       Menu? menu = boxMenus.getAt(i);
//       menuItems.add(menu!);
//     }
//   }

//   void addToBill() {
//     final String itemName = itemController.text;
//     final int quantity = int.tryParse(quantityController.text) ?? 0;

//     quantityList.add(quantity);

//     Menu? menuItem = menuItems.firstWhere(
//       (item) => item.name == itemName,
//       //  orElse: () => null
//     );

//     if (menuItem != null) {
//       eachitempriceList.add(menuItem.price!);
//       // ((quantity x price) x tax) + (quantity x price)

//       final double itemPrice = menuItem.price! * quantity;
//       final double amt =
//           ((menuItem.price! * quantity) * 0.05) + (quantity * menuItem.price!);
//       final double eachTax = ((menuItem.price! * quantity) * 0.05);
//       totalAmount += itemPrice;
//       VAT += eachTax;

//       AMTList.add(amt);

//       final selectedMenuItem = menuItem;
//       selectedItems.add(selectedMenuItem);
//     }

//     // Clear the text fields
//     itemController.clear();
//     quantityController.clear();

//     setState(() {});
//   }

//   void saveOrderdetail() {
//     for (int i = 0; i < selectedItems.length; i++) {
//       orderItemList.add(OrderItem(
//           itemName: selectedItems[i].name!, quantity: quantityList[i]));
//     }

//     boxOrders.put(
//         'key_${DateTime.now()}',
//         CustomerOrder(
//             customerName: '',
//             VAT: VAT,
//             orderItems: orderItemList,
//             totalAmount: totalAmount,
//             totalWithTax: (totalAmount + VAT),
//             orderDate: DateTime.now()));

//     print('added to cache');

//     for (int i = 0; i < orderItemList.length; i++) {
//       print(orderItemList[i].itemName);
//     }

//     // boxMenus.put('key', Menu(name: name, price: price, category: category))
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Customer Bill'),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           SizedBox(height: 20),
//           Row(
//             children: [
//               Expanded(
//                 flex: 3,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: AutoCompleteTextField<Menu>(
//                     controller: itemController,
//                     decoration: InputDecoration(
//                       labelStyle:
//                           TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                       labelText: 'Item',
//                     ),
//                     itemSubmitted: (item) {
//                       setState(() {
//                         itemController.text = item.name!;
//                       });
//                     },
//                     key:
//                         autoCompleteKey, // You can specify a GlobalKey if needed
//                     suggestions: menuItems,
//                     itemBuilder: (context, item) => ListTile(
//                       title: Text(item.name!),
//                     ),
//                     itemSorter: (item1, item2) =>
//                         item1.name!.compareTo(item2.name!),
//                     itemFilter: (item, query) => item.name!
//                         .toLowerCase()
//                         .startsWith(query.toLowerCase()),
//                     clearOnSubmit: false,
//                     // textSubmitted:  (item) {
//                     //   itemController.text = item.name;
//                     // },
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: TextField(
//                     controller: quantityController,
//                     keyboardType: TextInputType.number,
//                     decoration: InputDecoration(
//                       labelStyle:
//                           TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                       labelText: 'Quantity',
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(fixedSize: Size(150, 30)),
//                     onPressed: addToBill,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text("Add item"),
//                         SizedBox(
//                           width: 10,
//                         ),
//                         Icon(Icons.add),
//                       ],
//                     )),
//               ),
//             ],
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: selectedItems.length,
//               itemBuilder: (context, index) {
//                 final menuItem = selectedItems[index];
//                 return ListTile(
//                   title: Text(
//                     selectedItems[index].name!,
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   subtitle: quantityList.isNotEmpty
//                       ? Text(
//                           'x${quantityList[index].toString()}, ${eachitempriceList[index].toString()}',
//                           style: TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.normal),
//                         )
//                       : Text('no data'),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Text(
//                       'Total Amount :   ',
//                       style: TextStyle(
//                         fontWeight: FontWeight.normal,
//                         fontSize: 20,
//                       ),
//                     ),
//                     Text(
//                       totalAmount.toStringAsFixed(2),
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 25,
//                       ),
//                     ),
//                     SizedBox(
//                       width: 50,
//                     ),
//                     Text(
//                       'VAT :   ',
//                       style: TextStyle(
//                         fontWeight: FontWeight.normal,
//                         fontSize: 20,
//                       ),
//                     ),
//                     Text(
//                       VAT.toStringAsFixed(2),
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 25,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Divider(),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Text(
//                       'Total with tax :   ',
//                       style: TextStyle(
//                         fontWeight: FontWeight.normal,
//                         fontSize: 20,
//                       ),
//                     ),
//                     Text(
//                       (totalAmount + VAT).toStringAsFixed(2),
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 25,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(fixedSize: Size(150, 30)),
//                 onPressed: () {
//                   saveOrderdetail();
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => PrintingScreen(selectedItems)),
//                   );
//                 },
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text("Print"),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     Icon(Icons.print),
//                   ],
//                 )),
//           ),
//         ],
//       ),
//     );
//   }
// }
