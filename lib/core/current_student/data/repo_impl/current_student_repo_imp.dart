import 'dart:io';
import 'package:mobile_app/core/current_student/data/data_source/student_local_data_source.dart';
import 'package:mobile_app/core/current_student/data/model/student_model_hive.dart';
import 'package:mobile_app/core/current_student/domain/repo/current_student_repo.dart';
import 'package:mobile_app/core/current_student/domain/entities/student.dart';

class CurrentStudentRepositoryImpl implements CurrentStudentRepository {
  final StudentLocalDataSource _localDataSource;

  CurrentStudentRepositoryImpl({
    required StudentLocalDataSource localDataSource,
  }) : _localDataSource = localDataSource;

  @override
  Future<Student> getCurrentStudent() async {
    final studentModel = await _localDataSource.getCurrentStudent();
    return studentModel.toEntity();
  }

  @override
  Future<void> updateProfileImage(
    Student student, {
    required File imageFile,
  }) async {
    final newImagePath = await _localDataSource.saveImageLocally(imageFile);

    final studentModel = StudentModelHive.fromEntity(
      student.copyWith(profileImage: newImagePath),
    );

    await _localDataSource.updateStudent(studentModel);

    if (student.profileImage != null && student.profileImage!.isNotEmpty) {
      await _localDataSource.deleteOldProfileImage(student.profileImage!);
    }
  }
}
