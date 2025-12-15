import 'package:mobile_app/core/networking/api_result.dart';
import 'package:mobile_app/feature/home/data/models/user_model.dart';
import 'package:mobile_app/feature/register/domain/repos/register_repo.dart';

class RegisterUseCase {
  final RegisterRepo repo;

  RegisterUseCase(this.repo);

  Future<ApiResult<UserModel>> call({
    required String orgId,
    required String email,
    required String password,
    required UserModel localUserData,
  }) {
    print('🔷 [RegisterUseCase] call() started');
    print('📧 Email: $email');
    print('🏢 OrgId: $orgId');
    print('🔐 Password length: ${password.length}');

    final result = repo.registerUser(
      orgId: orgId,
      email: email,
      password: password,
      localUserData: localUserData,
    );

    print('🔷 [RegisterUseCase] Calling repo.registerUser()');

    return result;
  }
}
