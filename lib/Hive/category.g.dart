// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MenuCategoryAdapter extends TypeAdapter<MenuCategory> {
  @override
  final int typeId = 6;

  @override
  MenuCategory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MenuCategory(
      name: fields[0] as String?,
      img: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MenuCategory obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.img);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MenuCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
