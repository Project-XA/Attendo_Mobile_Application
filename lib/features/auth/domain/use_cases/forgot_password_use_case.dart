import 'package:mobile_app/core/networking/api_result.dart';
import 'package:mobile_app/features/auth/data/models/verify_reset_password_model.dart';
import 'package:mobile_app/features/auth/domain/repo/auth_repo.dart';

class ForgotPasswordUseCase {
  final AuthRepo repo;

  ForgotPasswordUseCase(this.repo);

  Future<ApiResult<String>> sendResetOtp({required String email}) {
    return repo.sendResetOtp(email: email);
  }

  Future<ApiResult<String>> verifyOtpAndResetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) {
    return repo.verifyOtpAndResetPassword(
      verifyRequest: VerifyResetPasswordModel(
        email: email,
        otp: otp,
        newPassword: newPassword,
      ),
    );
  }
}

