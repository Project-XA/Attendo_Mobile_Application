import 'package:mobile_app/core/networking/api_result.dart';
import 'package:mobile_app/features/student_auth/data/model/login_request_body.dart';
import 'package:mobile_app/features/student_auth/domain/repo/auth_student_repo.dart';


class LoginUseCase {
  final AuthStudentRepo authRepo;

  LoginUseCase({required this.authRepo});

  Future<ApiResult<void>> call(LoginRequestBody loginRequest) async {
    return await authRepo.login(loginRequest);
  }
}