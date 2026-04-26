// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_login_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentLoginData _$StudentLoginDataFromJson(Map<String, dynamic> json) =>
    StudentLoginData(
      student: StudentModel.fromJson(json['student'] as Map<String, dynamic>),
      loginToken: json['loginToken'] as String,
    );

Map<String, dynamic> _$StudentLoginDataToJson(StudentLoginData instance) =>
    <String, dynamic>{
      'student': instance.student,
      'loginToken': instance.loginToken,
    };
