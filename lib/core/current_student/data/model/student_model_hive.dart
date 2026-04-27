import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobile_app/core/current_student/domain/entities/student.dart';

part 'student_model_hive.g.dart';

@JsonSerializable()
@HiveType(typeId: 2) 
class StudentModelHive extends HiveObject {
  @HiveField(0)
  int studentId;

  @HiveField(1)
  String appUserId;

  @HiveField(2)
  int organizationId;

  @HiveField(3)
  String organizationName;

  @HiveField(4)
  String fullName;

  @HiveField(5)
  String email;

  @HiveField(6)
  String rollNumber;

  @HiveField(7)
  DateTime createdAt;

  @HiveField(8)
  DateTime updatedAt;

  @HiveField(9)
  String? profileImage;

  StudentModelHive({
    required this.studentId,
    required this.appUserId,
    required this.organizationId,
    required this.organizationName,
    required this.fullName,
    required this.email,
    required this.rollNumber,
    required this.createdAt,
    required this.updatedAt,
    this.profileImage,
  });

  factory StudentModelHive.fromJson(Map<String, dynamic> json) =>
      _$StudentModelHiveFromJson(json);

  Map<String, dynamic> toJson() => _$StudentModelHiveToJson(this);

  factory StudentModelHive.fromEntity(Student student) {
    return StudentModelHive(
      studentId: student.studentId,
      appUserId: student.appUserId,
      organizationId: student.organizationId,
      organizationName: student.organizationName,
      fullName: student.fullName,
      email: student.email,
      rollNumber: student.rollNumber,
      createdAt: student.createdAt,
      updatedAt: student.updatedAt,
      profileImage: student.profileImage,
    );
  }

  Student toEntity() {
    return Student(
      studentId: studentId,
      appUserId: appUserId,
      organizationId: organizationId,
      organizationName: organizationName,
      fullName: fullName,
      email: email,
      rollNumber: rollNumber,
      createdAt: createdAt,
      updatedAt: updatedAt,
      profileImage: profileImage,
    );
  }

  StudentModelHive copyWith({
    int? studentId,
    String? appUserId,
    int? organizationId,
    String? organizationName,
    String? fullName,
    String? email,
    String? rollNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? profileImage,
  }) {
    return StudentModelHive(
      studentId: studentId ?? this.studentId,
      appUserId: appUserId ?? this.appUserId,
      organizationId: organizationId ?? this.organizationId,
      organizationName: organizationName ?? this.organizationName,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      rollNumber: rollNumber ?? this.rollNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}