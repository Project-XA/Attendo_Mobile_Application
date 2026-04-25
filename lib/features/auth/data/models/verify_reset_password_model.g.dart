// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_reset_password_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyResetPasswordModel _$VerifyResetPasswordModelFromJson(
        Map<String, dynamic> json) =>
    VerifyResetPasswordModel(
      email: json['email'] as String,
      otp: json['otp'] as String,
      newPassword: json['newPassword'] as String,
    );

Map<String, dynamic> _$VerifyResetPasswordModelToJson(
        VerifyResetPasswordModel instance) =>
    <String, dynamic>{
      'email': instance.email,
      'otp': instance.otp,
      'newPassword': instance.newPassword,
    };
