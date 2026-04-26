// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_student_response_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginStudentResponseBody _$LoginStudentResponseBodyFromJson(
        Map<String, dynamic> json) =>
    LoginStudentResponseBody(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: StudentLoginData.fromJson(json['data'] as Map<String, dynamic>),
      errors: json['errors'] as List<dynamic>,
    );

Map<String, dynamic> _$LoginStudentResponseBodyToJson(
        LoginStudentResponseBody instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
      'errors': instance.errors,
    };
