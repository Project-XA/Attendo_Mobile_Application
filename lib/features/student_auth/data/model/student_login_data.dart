
import 'package:json_annotation/json_annotation.dart';
import 'package:mobile_app/features/student_auth/data/model/student_model.dart';
part 'student_login_data.g.dart';
@JsonSerializable()
class StudentLoginData {
  final StudentModel student;
  final String loginToken;

  const StudentLoginData({
    required this.student,
    required this.loginToken,
  });

  factory StudentLoginData.fromJson(Map<String, dynamic> json) =>
      _$StudentLoginDataFromJson(json);

  Map<String, dynamic> toJson() => _$StudentLoginDataToJson(this);
}
