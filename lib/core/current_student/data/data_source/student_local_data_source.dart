import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile_app/core/current_student/data/model/student_model_hive.dart';
import 'package:mobile_app/core/current_user/data/local_data_soruce/cache_exception.dart';
import 'package:mobile_app/core/services/auth/secure_storage_service.dart';
import 'package:path_provider/path_provider.dart';

abstract class StudentLocalDataSource {
  Future<StudentModelHive> getCurrentStudent();
  Future<void> saveStudentLogin(StudentModelHive student);
  Future<void> updateStudent(StudentModelHive student);
  Future<void> updateProfileImage(String imagePath);
  Future<String> saveImageLocally(File imageFile);
  Future<void> deleteOldProfileImage(String imagePath);
  Future<bool> hasCurrentStudent();
  Future<void> logout();
  Future<bool> hasValidToken();
}

class StudentLocalDataSourceImp extends StudentLocalDataSource {
  final Box<StudentModelHive> studentBox;
  static const String _currentStudentKey = 'current_student';

  StudentLocalDataSourceImp({required this.studentBox});

  @override
  Future<StudentModelHive> getCurrentStudent() async {
    try {
      final student = studentBox.get(_currentStudentKey);
      if (student == null) {
        throw CacheException('No student found in local storage');
      }
      return student.copyWith();
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException('Failed to read student data: $e');
    }
  }

  @override
  Future<bool> hasCurrentStudent() async {
    try {
      return studentBox.containsKey(_currentStudentKey);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> hasValidToken() async {
    try {
      await SecureStorageService.hasValidToken();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<String> saveImageLocally(File imageFile) async {
    try {
      if (!await imageFile.exists()) {
        throw CacheException('Selected file does not exist');
      }

      final appDir = await getApplicationDocumentsDirectory();
      final localPath = '${appDir.path}/profile_images';
      final directory = Directory(localPath);

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'profile_$timestamp.png';
      final targetPath = '$localPath/$fileName';

      final savedImage = await imageFile.copy(targetPath);

      if (!await savedImage.exists()) {
        throw CacheException('Failed to save image');
      }

      return savedImage.path;
    } on CacheException {
      rethrow;
    } catch (e) {
      throw CacheException('Failed to save image locally: $e');
    }
  }

  @override
  Future<void> deleteOldProfileImage(String imagePath) async {
    try {
      if (imagePath.isEmpty) return;
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      throw CacheException('Failed to delete old profile image: $e');
    }
  }

  @override
  Future<void> saveStudentLogin(StudentModelHive student) async {
    try {
      await studentBox.put(_currentStudentKey, student);
      await studentBox.flush();
    } catch (e) {
      throw CacheException('Failed to save student login data: $e');
    }
  }

  @override
  Future<void> updateStudent(StudentModelHive student) async {
    try {
      await studentBox.put(_currentStudentKey, student);
      await studentBox.flush();
    } catch (e) {
      throw CacheException('Failed to update student data: $e');
    }
  }

  @override
  Future<void> updateProfileImage(String imagePath) async {
    try {
      final student = await getCurrentStudent();
      final oldImagePath = student.profileImage;

      student.profileImage = imagePath;

      await studentBox.put(_currentStudentKey, student);
      await studentBox.flush();

      if (oldImagePath != null && oldImagePath.isNotEmpty) {
        await deleteOldProfileImage(oldImagePath);
      }
    } catch (e) {
      throw CacheException('Failed to update profile image: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await SecureStorageService.deleteToken();
      await studentBox.delete(_currentStudentKey);
      await studentBox.flush();
    } catch (e) {
      throw CacheException('Failed to logout: $e');
    }
  }
}