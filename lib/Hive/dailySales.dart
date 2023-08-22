import 'package:hive/hive.dart';

part 'dailySales.g.dart';

@HiveType(typeId: 4)
class DailySales extends HiveObject {
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  double tax;

  @HiveField(3)
  double totalAmount;

  @HiveField(4)
  double totalWithTax;
  DailySales(
      {required this.date,
      required this.tax,
      required this.totalAmount,
      required this.totalWithTax});
}
