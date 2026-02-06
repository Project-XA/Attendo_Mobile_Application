// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_halls_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CacheHallsDataAdapter extends TypeAdapter<CacheHallsData> {
  @override
  final int typeId = 5;

  @override
  CacheHallsData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CacheHallsData(
      lastFetchTime: fields[1] as DateTime,
      isValid: fields[2] as bool,
      halls: (fields[0] as List).cast<HallModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, CacheHallsData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.halls)
      ..writeByte(1)
      ..write(obj.lastFetchTime)
      ..writeByte(2)
      ..write(obj.isValid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CacheHallsDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
