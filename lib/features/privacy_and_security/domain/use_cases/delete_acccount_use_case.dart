
import 'package:mobile_app/core/networking/api_result.dart';
import 'package:mobile_app/features/privacy_and_security/domain/repo/privacy_security_repo.dart';

class DeleteAccountUseCase {
  final PrivacySecurityRepo privacySecurityRepo;

  DeleteAccountUseCase({required this.privacySecurityRepo});
  Future<ApiResult<void>> call(String password) {
    return privacySecurityRepo.deleteAccount(password);
  }
}
