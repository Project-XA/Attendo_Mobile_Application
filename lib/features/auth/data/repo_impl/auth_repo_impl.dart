import 'package:mobile_app/core/current_user/data/local_data_soruce/user_local_data_source.dart';
import 'package:mobile_app/core/current_user/data/models/user_model.dart';
import 'package:mobile_app/core/helpers/auth_session_helper.dart';
import 'package:mobile_app/core/helpers/user_model_mapper.dart';
import 'package:mobile_app/core/networking/api_error_handler.dart';
import 'package:mobile_app/core/networking/api_error_model.dart';
import 'package:mobile_app/core/networking/api_result.dart';
import 'package:mobile_app/core/services/auth/onboarding_service.dart';
import 'package:mobile_app/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:mobile_app/features/auth/data/models/register_request_body.dart';
import 'package:mobile_app/features/auth/data/models/verify_reset_password_model.dart';
import 'package:mobile_app/features/auth/domain/repo/auth_repo.dart';

class AuthRepoImpl extends AuthRepo {
  final AuthRemoteDataSource authRemoteDataSource;
  final UserLocalDataSource localDataSource;
  final OnboardingService onboardingService;
  AuthRepoImpl({
    required this.authRemoteDataSource,
    required this.localDataSource,
    required this.onboardingService,
  });

  @override
  Future<ApiResult<UserModel>> registerUser({
    required RegisterRequestBody request,
  }) async {
    try {
      final apiResponse = await authRemoteDataSource.registerUser(
        request: RegisterRequestBody(
          organizationCode: request.organizationCode,
          email: request.email,
          password: request.password,
        ),
      );

      final completeUserData = UserModelMapper.fromRegistration(
        apiResponse: apiResponse,
      );

      await localDataSource.saveUserLogin(completeUserData);

      await AuthSessionHelper.persistSession(
        token: apiResponse.loginToken,
        role: apiResponse.userResponse.role,
        onboardingService: onboardingService,
      );

      return ApiResult.success(completeUserData);
    } on ApiErrorModel catch (error) {
      return ApiResult.error(error);
    } catch (e) {
      return ApiResult.error(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<String>> sendResetOtp({required String email}) async {
    try {
      final message = await authRemoteDataSource.forgotPasswordSendOtp(email);
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
    required VerifyResetPasswordModel verifyRequest,
  }) async {
    try {
      final message = await authRemoteDataSource.verifyResetPasswordOtp(
        verifyRequest,
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
