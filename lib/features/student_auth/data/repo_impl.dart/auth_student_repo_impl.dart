import 'package:mobile_app/core/networking/api_error_handler.dart';
import 'package:mobile_app/core/networking/api_result.dart';
import 'package:mobile_app/features/student_auth/data/data_source/student_auth_remote_data_source.dart';
import 'package:mobile_app/features/student_auth/data/model/login_student_request_body.dart';
import 'package:mobile_app/features/student_auth/data/model/login_student_response_body.dart';
import 'package:mobile_app/features/student_auth/data/model/register_student_request_body.dart';
import 'package:mobile_app/features/student_auth/domain/repo/auth_student_repo.dart';

class AuthStudentRepoImpl extends AuthStudentRepo {
  final StudentAuthRemoteDataSource remoteDataSource;

  AuthStudentRepoImpl({required this.remoteDataSource});
  @override
  Future<ApiResult<LoginStudentResponseBody>> login(
    LoginStudentRequestBody requestBody,
  ) async {
    try {
      final response = await remoteDataSource.loginStudent(requestBody);

      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.error(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<void>> register(
    RegisterStudentRequestBody registerRequestBody,
  ) async {
    try {
      await remoteDataSource.registerStudent(registerRequestBody);
      return ApiResult.success(null);
    } catch (e) {
      return ApiResult.error(ApiErrorHandler.handle(e));
    }
  }
}
