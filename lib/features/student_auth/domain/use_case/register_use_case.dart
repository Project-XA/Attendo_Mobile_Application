import 'package:mobile_app/core/networking/api_result.dart';
import 'package:mobile_app/features/auth/data/models/register_request_body.dart';
import 'package:mobile_app/features/student_auth/domain/repo/auth_student_repo.dart';

class RegisterUseCase {
  final AuthStudentRepo authRepo;
  RegisterUseCase(this.authRepo);

  Future<ApiResult<void>> register(RegisterRequestBody body) {
    return authRepo.register(body);
  }
}
