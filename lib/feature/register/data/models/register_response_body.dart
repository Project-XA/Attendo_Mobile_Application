import 'package:json_annotation/json_annotation.dart';

part 'register_response_body.g.dart';

@JsonSerializable()
class RegisterResponseBody {
  final String id;
  final String fullName;
  final String userName;
  final String email;
  final String? phoneNumber;
  final String role;
  final String createdAt;
  final String updatedAt;

  RegisterResponseBody({
    required this.id,
    required this.fullName,
    required this.userName,
    required this.email,
    this.phoneNumber,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RegisterResponseBody.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseBodyFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterResponseBodyToJson(this);
}