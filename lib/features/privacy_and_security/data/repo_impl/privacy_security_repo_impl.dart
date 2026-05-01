
import 'package:mobile_app/core/networking/api_result.dart';
import 'package:mobile_app/features/privacy_and_security/data/data_source/ps_remote_data_source.dart';
import 'package:mobile_app/features/privacy_and_security/domain/repo/privacy_security_repo.dart';

class PrivacySecurityRepoImpl extends PrivacySecurityRepo {
  final PsRemoteDataSource psRemoteDataSource;

  PrivacySecurityRepoImpl({required this.psRemoteDataSource});
  @override
  Future<ApiResult<void>> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    return await psRemoteDataSource.changePassword(
      currentPassword,
      newPassword,
    );
  }

  @override
  Future<ApiResult<void>> deactivateAccount(String password) async {
    return await psRemoteDataSource.deactivateAccount(password);
  }

  @override
  Future<ApiResult<void>> deleteAccount(String password) async {
    return await psRemoteDataSource.deleteAccount(password);
  }
}
