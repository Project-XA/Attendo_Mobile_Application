import 'package:mobile_app/core/networking/api_result.dart';

abstract class ForgotPasswordRepo {
  Future<ApiResult<String>> sendResetOtp({required String email});

  Future<ApiResult<String>> verifyOtpAndResetPassword({
    required String email,
    required String otp,
    required String newPassword,
  });
}

