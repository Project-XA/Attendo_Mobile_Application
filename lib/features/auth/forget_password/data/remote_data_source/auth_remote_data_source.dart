import 'package:mobile_app/core/networking/api_const.dart';
import 'package:mobile_app/core/networking/api_error_handler.dart';
import 'package:mobile_app/core/networking/network_service.dart';
import 'package:mobile_app/features/auth/forget_password/data/models/forgot_password_request_body.dart';
import 'package:mobile_app/features/auth/forget_password/data/models/verify_reset_password_otp_request_body.dart';

abstract class AuthRemoteDataSource {
  Future<String> forgotPasswordSendOtp(ForgotPasswordRequestBody request);
  Future<String> verifyResetPasswordOtp(VerifyResetPasswordOtpRequestBody request);
}

class AuthRemoteDataSourceImp implements AuthRemoteDataSource {
  final NetworkService networkService;

  AuthRemoteDataSourceImp(this.networkService);

  @override
  Future<String> forgotPasswordSendOtp(ForgotPasswordRequestBody request) async {
    try {
      final response = await networkService.post(
        ApiConst.forgotPassword,
        request.toJson(),
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return (data['message']?.toString()) ??
            'If your email exists, an OTP will be sent.';
      }
      return 'If your email exists, an OTP will be sent.';
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  @override
  Future<String> verifyResetPasswordOtp(
    VerifyResetPasswordOtpRequestBody request,
  ) async {
    try {
      final response = await networkService.post(
        ApiConst.verifyResetPasswordOtp,
        request.toJson(),
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return (data['message']?.toString()) ?? 'Password Reset Successfully';
      }
      return 'Password Reset Successfully';
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }
}

