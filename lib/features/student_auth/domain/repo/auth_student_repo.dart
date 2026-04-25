import 'package:mobile_app/core/networking/api_result.dart';
import 'package:mobile_app/features/auth/data/models/register_request_body.dart';
import 'package:mobile_app/features/student_auth/data/model/login_request_body.dart';

abstract class AuthStudentRepo {
  Future<ApiResult<void>> register(RegisterRequestBody registerRequestBody);
  Future<ApiResult<void>> login(LoginRequestBody loginRequest);
}
