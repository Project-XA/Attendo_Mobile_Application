import 'package:mobile_app/core/current_user/data/models/user_model.dart';
import 'package:mobile_app/core/networking/api_result.dart';
import 'package:mobile_app/features/auth/data/models/verify_reset_password_model.dart';
import 'package:mobile_app/features/auth/data/models/register_request_body.dart';

abstract class AuthRepo {
  Future<ApiResult<UserModel>> registerUser({
    required RegisterRequestBody request,

  });

  Future<ApiResult<String>> sendResetOtp({required String email});

  Future<ApiResult<String>> verifyOtpAndResetPassword({
    required VerifyResetPasswordModel verifyRequest,
  });
}
