
import 'package:mobile_app/core/networking/api_result.dart';
import 'package:mobile_app/features/privacy_and_security/domain/repo/privacy_security_repo.dart';

class DeactivateAccountUseCase {
  final PrivacySecurityRepo repo;

  DeactivateAccountUseCase(this.repo);

  Future<ApiResult<void>> call(String password) async {
    return await repo.deactivateAccount(password);
  }
}
