// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_history_cache_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AttendanceHistoryCacheModelAdapter
    extends TypeAdapter<AttendanceHistoryCacheModel> {
  @override
  final int typeId = 12;

  @override
  AttendanceHistoryCacheModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AttendanceHistoryCacheModel(
      records: (fields[0] as List).cast<AttendanceHistoryModel>(),
      cachedAt: fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, AttendanceHistoryCacheModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.records)
      ..writeByte(1)
      ..write(obj.cachedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttendanceHistoryCacheModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
