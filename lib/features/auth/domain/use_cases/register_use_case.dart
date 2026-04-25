import 'package:mobile_app/core/networking/api_result.dart';
import 'package:mobile_app/core/current_user/data/models/user_model.dart';
import 'package:mobile_app/features/auth/data/models/register_request_body.dart';
import 'package:mobile_app/features/auth/domain/repo/auth_repo.dart';

class RegisterUseCase {
  final AuthRepo repo;

  RegisterUseCase(this.repo);

  Future<ApiResult<UserModel>> call({
    required String orgId,
    required String email,
    required String password,
    required UserModel localUserData,
  }) {
    final result = repo.registerUser(
      request: RegisterRequestBody(
        organizationCode: int.parse(orgId),
        email: email,
        password: password,
      ),
      localUserData: localUserData,
    );

    return result;
  }
}
