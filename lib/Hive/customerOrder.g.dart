// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customerOrder.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomerOrderAdapter extends TypeAdapter<CustomerOrder> {
  @override
  final int typeId = 2;

  @override
  CustomerOrder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomerOrder(
      customerName: fields[0] as String?,
      VAT: fields[3] as double,
      orderDate: fields[2] as DateTime,
      orderItems: (fields[1] as List).cast<OrderItem>(),
      totalAmount: fields[4] as double,
      totalWithTax: fields[5] as double,
    );
  }

  @override
  void write(BinaryWriter writer, CustomerOrder obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.customerName)
      ..writeByte(1)
      ..write(obj.orderItems)
      ..writeByte(2)
      ..write(obj.orderDate)
      ..writeByte(3)
      ..write(obj.VAT)
      ..writeByte(4)
      ..write(obj.totalAmount)
      ..writeByte(5)
      ..write(obj.totalWithTax);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomerOrderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OrderItemAdapter extends TypeAdapter<OrderItem> {
  @override
  final int typeId = 3;

  @override
  OrderItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderItem(
      itemName: fields[0] as String,
      itemPrice: fields[1] as double,
      quantity: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, OrderItem obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.itemName)
      ..writeByte(1)
      ..write(obj.itemPrice)
      ..writeByte(2)
      ..write(obj.quantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
