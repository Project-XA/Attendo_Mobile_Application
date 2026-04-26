// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_student_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterStudentRequestBody _$RegisterStudentRequestBodyFromJson(
        Map<String, dynamic> json) =>
    RegisterStudentRequestBody(
      organizationCode: (json['organizationCode'] as num).toInt(),
      fullname: json['fullname'] as String,
      email: json['email'] as String,
      confirmEmail: json['confirmEmail'] as String,
      rollNumber: json['rollNumber'] as String,
      password: json['password'] as String,
      confirmPassword: json['confirmPassword'] as String,
    );

Map<String, dynamic> _$RegisterStudentRequestBodyToJson(
        RegisterStudentRequestBody instance) =>
    <String, dynamic>{
      'organizationCode': instance.organizationCode,
      'fullname': instance.fullname,
      'email': instance.email,
      'confirmEmail': instance.confirmEmail,
      'rollNumber': instance.rollNumber,
      'password': instance.password,
      'confirmPassword': instance.confirmPassword,
    };
