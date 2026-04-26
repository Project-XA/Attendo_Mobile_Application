// login_student_response_body.dart

import 'package:json_annotation/json_annotation.dart';
import 'package:mobile_app/features/student_auth/data/model/student_login_data.dart';

part 'login_student_response_body.g.dart';

@JsonSerializable()
class LoginStudentResponseBody {
  final bool success;
  final String message;
  final StudentLoginData data;
  final List<dynamic> errors;

  const LoginStudentResponseBody({
    required this.success,
    required this.message,
    required this.data,
    required this.errors,
  });

  factory LoginStudentResponseBody.fromJson(Map<String, dynamic> json) =>
      _$LoginStudentResponseBodyFromJson(json);

  Map<String, dynamic> toJson() => _$LoginStudentResponseBodyToJson(this);
}
