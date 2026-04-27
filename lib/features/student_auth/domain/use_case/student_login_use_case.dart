import 'package:mobile_app/core/networking/api_result.dart';
import 'package:mobile_app/features/student_auth/data/model/login_student_request_body.dart';
import 'package:mobile_app/features/student_auth/data/model/login_student_response_body.dart';
import 'package:mobile_app/features/student_auth/domain/repo/auth_student_repo.dart';


class StudentLoginUseCase {
  final AuthStudentRepo authRepo;

  StudentLoginUseCase({required this.authRepo});

  Future<ApiResult<LoginStudentResponseBody>> call(LoginStudentRequestBody loginRequest) async {
    return await authRepo.login(loginRequest);
  }
}