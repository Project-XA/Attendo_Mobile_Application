
import 'package:mobile_app/feature/home/domain/entities/user.dart';
import 'package:mobile_app/feature/home/presentation/user/domain/repos/user_repo.dart';

class GetCurrentUserUseCase {
  final UserRepo repository;
  GetCurrentUserUseCase(this.repository);
  Future<User> call() async {
    return await repository.getCurrentUser();
  }
}