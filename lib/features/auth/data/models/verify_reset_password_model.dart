import 'package:json_annotation/json_annotation.dart';

part 'verify_reset_password_model.g.dart';
@JsonSerializable()
class VerifyResetPasswordModel {
  final String email;
  final String otp;
  final String newPassword;

  VerifyResetPasswordModel({required this.email, required this.otp, required this.newPassword});
  factory VerifyResetPasswordModel.fromJson(Map<String, dynamic> json) => _$VerifyResetPasswordModelFromJson(json);
  Map<String, dynamic> toJson() => _$VerifyResetPasswordModelToJson(this);
}
