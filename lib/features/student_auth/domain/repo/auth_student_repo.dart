import 'package:mobile_app/core/networking/api_result.dart';
import 'package:mobile_app/features/student_auth/data/model/login_student_request_body.dart';
import 'package:mobile_app/features/student_auth/data/model/register_student_request_body.dart';

abstract class AuthStudentRepo {
  Future<ApiResult<void>> register(RegisterStudentRequestBody registerRequestBody);
  Future<ApiResult<void>> login(LoginStudentRequestBody loginRequest);
}
