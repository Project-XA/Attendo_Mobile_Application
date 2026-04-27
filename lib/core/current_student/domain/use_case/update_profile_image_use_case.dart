import 'dart:io';
import 'package:mobile_app/core/current_student/domain/repo/current_student_repo.dart';
import 'package:mobile_app/core/current_student/domain/entities/student.dart';

class UpdateStudentProfileImageUseCase {
  final CurrentStudentRepository _repository;

  UpdateStudentProfileImageUseCase(this._repository);

  Future<void> call(Student student, {required File imageFile}) async {
    return await _repository.updateProfileImage(student, imageFile: imageFile);
  }
}