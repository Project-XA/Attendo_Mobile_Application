// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_student_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterStudentRequestBody _$RegisterStudentRequestBodyFromJson(
        Map<String, dynamic> json) =>
    RegisterStudentRequestBody(
      fullName: json['fullName'] as String,
      userName: json['userName'] as String,
      email: json['email'] as String,
      confirmEmail: json['confirmEmail'] as String,
      phoneNumber: json['phoneNumber'] as String,
      password: json['password'] as String,
      confirmPassword: json['confirmPassword'] as String,
    );

Map<String, dynamic> _$RegisterStudentRequestBodyToJson(
        RegisterStudentRequestBody instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'userName': instance.userName,
      'email': instance.email,
      'confirmEmail': instance.confirmEmail,
      'phoneNumber': instance.phoneNumber,
      'password': instance.password,
      'confirmPassword': instance.confirmPassword,
    };
