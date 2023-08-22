import 'package:hive/hive.dart';

part 'monthlySales.g.dart';

@HiveType(typeId: 5)
class MonthlySales extends HiveObject {
  @HiveField(0)
  String date;

  @HiveField(1)
  double tax;

  @HiveField(3)
  double totalAmount;

  @HiveField(4)
  double totalWithTax;
  MonthlySales(
      {required this.date,
      required this.tax,
      required this.totalAmount,
      required this.totalWithTax});
}
