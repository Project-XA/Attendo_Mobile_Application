import 'package:mobile_app/core/networking/api_const.dart';
import 'package:mobile_app/core/networking/api_error_handler.dart';
import 'package:mobile_app/core/networking/network_service.dart';
import 'package:mobile_app/features/auth/data/models/register_request_body.dart';
import 'package:mobile_app/features/auth/data/models/register_response_body.dart';
import 'package:mobile_app/features/auth/data/models/verify_reset_password_model.dart';

abstract class AuthRemoteDataSource {
  Future<RegisterResponseBody> registerUser({
    required RegisterRequestBody request,
  });
  Future<String> forgotPasswordSendOtp(String email);
  Future<String> verifyResetPasswordOtp(VerifyResetPasswordModel request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final NetworkService networkService;

  AuthRemoteDataSourceImpl(this.networkService);

  @override
  Future<RegisterResponseBody> registerUser({
    required RegisterRequestBody request,
  }) async {
    try {
      final response = await networkService.post(
        ApiConst.register,
        request.toJson(),
      );
      final data = response.data['data'] as Map<String, dynamic>;
      return RegisterResponseBody.fromJson(data);
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  @override
  Future<String> forgotPasswordSendOtp(String email) async {
    try {
      final response = await networkService.post(ApiConst.forgotPassword, {
        'email': email,
      });

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
    VerifyResetPasswordModel request,
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
