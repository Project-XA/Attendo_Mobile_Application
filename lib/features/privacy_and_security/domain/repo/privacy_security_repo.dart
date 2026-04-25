
import 'package:mobile_app/core/networking/api_result.dart';

abstract class PrivacySecurityRepo {

  Future<ApiResult<void>> changePassword(String currentPassword, String newPassword);
}
