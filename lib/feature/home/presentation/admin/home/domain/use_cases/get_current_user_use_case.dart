// domain/usecases/get_current_user.dart
import 'package:mobile_app/feature/home/domain/entities/user.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/domain/repos/admin_repo.dart';

class GetCurrentUserUseCase {
  final AdminRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<User> call() async {
    return await repository.getCurrentUser();
  }
}
