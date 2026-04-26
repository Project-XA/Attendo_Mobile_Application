// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentModel _$StudentModelFromJson(Map<String, dynamic> json) => StudentModel(
      studentId: (json['studentId'] as num).toInt(),
      appUserId: json['appUserId'] as String,
      organizationId: (json['organizationId'] as num).toInt(),
      organizationName: json['organizationName'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      rollNumber: json['rollNumber'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$StudentModelToJson(StudentModel instance) =>
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
    };
