
import 'package:json_annotation/json_annotation.dart';
part 'student_model.g.dart';
@JsonSerializable()
class StudentModel {
  final int studentId;
  final String appUserId;
  final int organizationId;
  final String organizationName;
  final String fullName;
  final String email;
  final String rollNumber;
  final DateTime createdAt;
  final DateTime updatedAt;

  const StudentModel({
    required this.studentId,
    required this.appUserId,
    required this.organizationId,
    required this.organizationName,
    required this.fullName,
    required this.email,
    required this.rollNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) =>
      _$StudentModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudentModelToJson(this);
}