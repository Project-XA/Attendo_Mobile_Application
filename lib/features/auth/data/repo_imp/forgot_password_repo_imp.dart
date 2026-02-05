import 'package:mobile_app/core/networking/api_error_handler.dart';
import 'package:mobile_app/core/networking/api_error_model.dart';
import 'package:mobile_app/core/networking/api_result.dart';
import 'package:mobile_app/features/auth/data/models/forgot_password_request_body.dart';
import 'package:mobile_app/features/auth/data/models/verify_reset_password_otp_request_body.dart';
import 'package:mobile_app/features/auth/data/remote_data_source/auth_remote_data_source.dart';
import 'package:mobile_app/features/auth/domain/repos/forgot_password_repo.dart';

class ForgotPasswordRepoImp implements ForgotPasswordRepo {
  final AuthRemoteDataSource remote;

  ForgotPasswordRepoImp({required this.remote});

  @override
  Future<ApiResult<String>> sendResetOtp({required String email}) async {
    try {
      final message = await remote.forgotPasswordSendOtp(
        ForgotPasswordRequestBody(email: email),
      );
      return ApiResult.success(message);
    } on ApiErrorModel catch (error) {
      return ApiResult.error(error);
    } catch (e) {
      final apiError = ApiErrorHandler.handle(e);
      return ApiResult.error(apiError);
    }
  }

  @override
  Future<ApiResult<String>> verifyOtpAndResetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      final message = await remote.verifyResetPasswordOtp(
        VerifyResetPasswordOtpRequestBody(
          email: email,
          otp: otp,
          newPassword: newPassword,
        ),
      );
      return ApiResult.success(message);
    } on ApiErrorModel catch (error) {
      return ApiResult.error(error);
    } catch (e) {
      final apiError = ApiErrorHandler.handle(e);
      return ApiResult.error(apiError);
    }
  }
}

