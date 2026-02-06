// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hall_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HallModelAdapter extends TypeAdapter<HallModel> {
  @override
  final int typeId = 4;

  @override
  HallModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HallModel(
      id: fields[0] as int,
      hallName: fields[1] as String,
      capacity: fields[2] as int,
      hallArea: fields[3] as double,
      organizationId: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HallModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.hallName)
      ..writeByte(2)
      ..write(obj.capacity)
      ..writeByte(3)
      ..write(obj.hallArea)
      ..writeByte(4)
      ..write(obj.organizationId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HallModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
