import 'dart:io';

import 'package:mobile_app/feature/home/domain/entities/user.dart';

abstract class ProfileRepo {
  Future<User> getCurrentUser();
  Future<void> updateUser(User user);
  Future<void> updateProfileImage(File imageFile);
}
