// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dailySales.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailySalesAdapter extends TypeAdapter<DailySales> {
  @override
  final int typeId = 4;

  @override
  DailySales read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailySales(
      date: fields[0] as DateTime,
      tax: fields[1] as double,
      totalAmount: fields[3] as double,
      totalWithTax: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, DailySales obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.tax)
      ..writeByte(3)
      ..write(obj.totalAmount)
      ..writeByte(4)
      ..write(obj.totalWithTax);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailySalesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
