// import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 6)
class MenuCategory {
  MenuCategory({required this.name, this.img});
  @HiveField(0)
  late String? name;

  @HiveField(2)
  late String? img;
}
