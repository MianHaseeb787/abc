import 'package:hive/hive.dart';
import 'package:rms/Hive/customerOrder.dart';
import 'package:rms/Hive/dailySales.dart';
import 'package:rms/Hive/employee.dart';
import 'package:rms/Hive/monthlySales.dart';

import 'Hive/category.dart';
import 'Hive/menu.dart';

late Box<Menu> boxMenus;
late Box<DailySales> boxDailySales;
late Box<MonthlySales> boxMonthlySales;

late Box<CustomerOrder> boxOrders;

late Box<MenuCategory> boxCategorys;
late Box<Employee> boxEmployees;
