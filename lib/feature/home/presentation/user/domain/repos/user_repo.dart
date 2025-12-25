import 'package:mobile_app/feature/home/domain/entities/user.dart';

abstract class UserRepo {
  Future<User> getCurrentUser();
}
