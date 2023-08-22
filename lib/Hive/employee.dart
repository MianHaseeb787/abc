import 'package:hive/hive.dart';

part 'employee.g.dart';

@HiveType(typeId: 7)
class Employee {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late double totalSalary;

  @HiveField(2)
  late double paidSalary = 0.0;

  // @HiveField(3)
  // late double remainingSalary = 0.0

  @HiveField(3)
  late String month = DateTime.now().month.toString();

  @HiveField(4)
  late int year = DateTime.now().year;

  Employee({
    required this.name,
    required this.totalSalary,
    // this.paidSalary,
  });

  // Method to update the paidSalary
  void updatePaidSalary(double newPaidSalary) {
    paidSalary = newPaidSalary;
  }
}
