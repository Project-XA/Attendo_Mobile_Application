// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_history_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AttendanceHistoryModelAdapter
    extends TypeAdapter<AttendanceHistoryModel> {
  @override
  final int typeId = 10;

  @override
  AttendanceHistoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AttendanceHistoryModel(
      id: fields[0] as String,
      sessionId: fields[1] as String,
      sessionName: fields[2] as String,
      location: fields[3] as String,
      checkInTime: fields[4] as DateTime,
      status: fields[5] as AttendanceStatus,
      lastUpdated: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, AttendanceHistoryModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.sessionId)
      ..writeByte(2)
      ..write(obj.sessionName)
      ..writeByte(3)
      ..write(obj.location)
      ..writeByte(4)
      ..write(obj.checkInTime)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttendanceHistoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendanceHistoryModel _$AttendanceHistoryModelFromJson(
        Map<String, dynamic> json) =>
    AttendanceHistoryModel(
      id: json['id'] as String,
      sessionId: json['sessionId'] as String,
      sessionName: json['sessionName'] as String,
      location: json['location'] as String,
      checkInTime: DateTime.parse(json['checkInTime'] as String),
      status: $enumDecode(_$AttendanceStatusEnumMap, json['status']),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$AttendanceHistoryModelToJson(
        AttendanceHistoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sessionId': instance.sessionId,
      'sessionName': instance.sessionName,
      'location': instance.location,
      'checkInTime': instance.checkInTime.toIso8601String(),
      'status': _$AttendanceStatusEnumMap[instance.status]!,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };

const _$AttendanceStatusEnumMap = {
  AttendanceStatus.present: 'present',
  AttendanceStatus.late: 'late',
  AttendanceStatus.absent: 'absent',
};
