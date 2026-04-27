// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_model_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudentModelHiveAdapter extends TypeAdapter<StudentModelHive> {
  @override
  final int typeId = 2;

  @override
  StudentModelHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudentModelHive(
      studentId: fields[0] as int,
      appUserId: fields[1] as String,
      organizationId: fields[2] as int,
      organizationName: fields[3] as String,
      fullName: fields[4] as String,
      email: fields[5] as String,
      rollNumber: fields[6] as String,
      createdAt: fields[7] as DateTime,
      updatedAt: fields[8] as DateTime,
      profileImage: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, StudentModelHive obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.studentId)
      ..writeByte(1)
      ..write(obj.appUserId)
      ..writeByte(2)
      ..write(obj.organizationId)
      ..writeByte(3)
      ..write(obj.organizationName)
      ..writeByte(4)
      ..write(obj.fullName)
      ..writeByte(5)
      ..write(obj.email)
      ..writeByte(6)
      ..write(obj.rollNumber)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.updatedAt)
      ..writeByte(9)
      ..write(obj.profileImage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentModelHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentModelHive _$StudentModelHiveFromJson(Map<String, dynamic> json) =>
    StudentModelHive(
      studentId: (json['studentId'] as num).toInt(),
      appUserId: json['appUserId'] as String,
      organizationId: (json['organizationId'] as num).toInt(),
      organizationName: json['organizationName'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      rollNumber: json['rollNumber'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      profileImage: json['profileImage'] as String?,
    );

Map<String, dynamic> _$StudentModelHiveToJson(StudentModelHive instance) =>
    <String, dynamic>{
      'studentId': instance.studentId,
      'appUserId': instance.appUserId,
      'organizationId': instance.organizationId,
      'organizationName': instance.organizationName,
      'fullName': instance.fullName,
      'email': instance.email,
      'rollNumber': instance.rollNumber,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'profileImage': instance.profileImage,
    };
