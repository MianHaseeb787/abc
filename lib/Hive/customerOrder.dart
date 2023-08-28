import 'package:hive/hive.dart';
import 'package:rms/Hive/menu.dart';

part 'customerOrder.g.dart';

@HiveType(typeId: 2)
class CustomerOrder extends HiveObject {
  CustomerOrder(
      {required this.customerName,
      required this.VAT,
      required this.orderDate,
      required this.orderItems,
      required this.totalAmount,
      required this.totalWithTax});
  @HiveField(0)
  late String? customerName;

  @HiveField(1)
  late List<OrderItem> orderItems;

  @HiveField(2)
  late DateTime orderDate;

  @HiveField(3)
  late double VAT;

  @HiveField(4)
  late double totalAmount;

  @HiveField(5)
  late double totalWithTax;
}

@HiveType(typeId: 3)
class OrderItem extends HiveObject {
  OrderItem(
      {required this.itemName,
      required this.itemPrice,
      required this.quantity});
  @HiveField(0)
  late String itemName;

  @HiveField(1)
  late double itemPrice;

  @HiveField(2)
  late int quantity;
}
