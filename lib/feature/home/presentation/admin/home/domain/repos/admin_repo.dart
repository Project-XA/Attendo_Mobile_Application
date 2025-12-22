
import 'package:mobile_app/feature/home/domain/entities/user.dart';

abstract class AdminRepository {
  Future<User> getCurrentUser();
}
