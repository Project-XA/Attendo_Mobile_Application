import 'package:freezed_annotation/freezed_annotation.dart';
part 'register_student_request_body.g.dart';

@JsonSerializable()
class RegisterStudentRequestBody {
  final int organizationCode;
  final String fullname;
  final String email;
  final String confirmEmail;
  final String rollNumber;
  final String password;
  final String confirmPassword;

  RegisterStudentRequestBody({
    required this.organizationCode,
    required this.fullname,
    required this.email,
    required this.confirmEmail,
    required this.rollNumber,
    required this.password,
    required this.confirmPassword,
  });

  factory RegisterStudentRequestBody.fromJson(Map<String, dynamic> json) =>
      _$RegisterStudentRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterStudentRequestBodyToJson(this);
}
