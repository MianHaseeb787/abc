import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rms/Hive/category.dart';
import 'package:rms/Hive/customerOrder.dart';
import 'package:rms/Hive/dailySales.dart';
import 'package:rms/Hive/employee.dart';
import 'package:rms/Hive/menu.dart';
import 'package:rms/Hive/monthlySales.dart';
import 'package:rms/Home_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'boxes.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(MenuAdapter());
  Hive.registerAdapter(CustomerOrderAdapter());
  Hive.registerAdapter(OrderItemAdapter());
  Hive.registerAdapter(DailySalesAdapter());
  Hive.registerAdapter(MonthlySalesAdapter());
  Hive.registerAdapter(MenuCategoryAdapter());
  Hive.registerAdapter(EmployeeAdapter());

  boxMenus = await Hive.openBox<Menu>('menuBox');
  boxOrders = await Hive.openBox<CustomerOrder>('orderBox');
  boxDailySales = await Hive.openBox<DailySales>('dailySales');
  boxMonthlySales = await Hive.openBox<MonthlySales>('montlySalesBox');
  boxCategorys = await Hive.openBox<MenuCategory>('menuCategoryBox');
  boxEmployees = await Hive.openBox<Employee>('employeeBox');

  print("kjasndjaksndD");

  // // Get the application documents directory
  // Directory appDocumentsDir = await getApplicationDocumentsDirectory();

  // // // Concatenate the Hive box name to the document directory path
  // String boxPath = appDocumentsDir.path;

  // print('Path of the menu box: $boxPath');

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(brightness: Brightness.dark),
    home: HomeScreen(),
  ));
}
