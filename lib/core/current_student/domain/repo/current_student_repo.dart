import 'dart:io';
import 'package:mobile_app/core/current_student/domain/entities/student.dart';

abstract class CurrentStudentRepository {
  Future<Student> getCurrentStudent();
  Future<void> updateProfileImage(Student student, {required File imageFile});
}
