import 'dart:io';

import 'package:mobile_app/core/current_user/data/local_data_soruce/user_local_data_source.dart';
import 'package:mobile_app/core/current_user/domain/repo/current_user_repo.dart';
import 'package:mobile_app/core/current_user/data/models/user_model.dart';
import 'package:mobile_app/core/current_user/domain/entities/user.dart';

class CurrentUserRepositoryImpl implements CurrentUserRepository {
  final UserLocalDataSource _localDataSource;
  
  CurrentUserRepositoryImpl({required UserLocalDataSource localDataSource})
      : _localDataSource = localDataSource;

  @override
  Future<User> getCurrentUser() async {
    final userModel = await _localDataSource.getCurrentUser();
    return userModel.toEntity();
  }

 
  @override
Future<void> updateUser(User user, {File? imageFile}) async {
  String? newImagePath;

  if (imageFile != null) {
    newImagePath = await _localDataSource.saveImageLocally(imageFile);
  }

  final userModel = UserModel.fromEntity(
    newImagePath != null ? user.copyWith(profileImage: newImagePath) : user,
  );

  await _localDataSource.updateUser(userModel);

  if (newImagePath != null && user.profileImage != null) {
    await _localDataSource.deleteOldProfileImage(user.profileImage!);
  }
}
}