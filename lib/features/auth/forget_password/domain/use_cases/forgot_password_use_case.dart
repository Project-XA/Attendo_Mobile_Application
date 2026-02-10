import 'package:mobile_app/core/networking/api_result.dart';
import 'package:mobile_app/features/auth/forget_password/domain/repos/forgot_password_repo.dart';

class ForgotPasswordUseCase {
  final ForgotPasswordRepo repo;

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
      email: email,
      otp: otp,
      newPassword: newPassword,
    );
  }
}

