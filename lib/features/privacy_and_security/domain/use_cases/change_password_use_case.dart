
import 'package:mobile_app/core/networking/api_result.dart';
import 'package:mobile_app/features/privacy_and_security/domain/repo/privacy_security_repo.dart';

class ChangePasswordUseCase {
  final PrivacySecurityRepo privacySecurityRepo;

  ChangePasswordUseCase({required this.privacySecurityRepo});
  
  Future<ApiResult<void>>call(String currentPassword, String newPassword) {
    return privacySecurityRepo.changePassword(currentPassword, newPassword);
  }
}
