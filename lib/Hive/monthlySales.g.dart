// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthlySales.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MonthlySalesAdapter extends TypeAdapter<MonthlySales> {
  @override
  final int typeId = 5;

  @override
  MonthlySales read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MonthlySales(
      date: fields[0] as String,
      tax: fields[1] as double,
      totalAmount: fields[3] as double,
      totalWithTax: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, MonthlySales obj) {
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
      other is MonthlySalesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
