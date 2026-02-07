// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_stats_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AttendanceStatsModelAdapter extends TypeAdapter<AttendanceStatsModel> {
  @override
  final int typeId = 6;

  @override
  AttendanceStatsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AttendanceStatsModel(
      totalSessions: fields[0] as int,
      attendedSessions: fields[1] as int,
      attendancePercentage: fields[2] as double,
      lastUpdated: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, AttendanceStatsModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.totalSessions)
      ..writeByte(1)
      ..write(obj.attendedSessions)
      ..writeByte(2)
      ..write(obj.attendancePercentage)
      ..writeByte(3)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttendanceStatsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
