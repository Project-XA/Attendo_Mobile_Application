import 'package:mobile_app/core/current_student/domain/repo/current_student_repo.dart';
import 'package:mobile_app/core/current_student/domain/entities/student.dart';

class GetCurrentStudentUseCase {
  final CurrentStudentRepository _repository;

  GetCurrentStudentUseCase(this._repository);

  Future<Student> call() async => await _repository.getCurrentStudent();
}