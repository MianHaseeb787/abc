import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'menu.g.dart';

@HiveType(typeId: 1)
class Menu {
  Menu(
      {required this.name,
      required this.price,
      required this.category,
      this.size,
      this.img = ''});
  @HiveField(0)
  late String? name;

  @HiveField(1)
  late double? price;

  @HiveField(2)
  late String? category;

  @HiveField(3)
  late String? size = 'N';

  @HiveField(4)
  late String? img;
}
