import 'package:mobile_app/core/networking/api_result.dart';
import 'package:mobile_app/features/student_auth/data/model/register_student_request_body.dart';
import 'package:mobile_app/features/student_auth/domain/repo/auth_student_repo.dart';

class StudentRegisterUseCase {
  final AuthStudentRepo authRepo;
  StudentRegisterUseCase(this.authRepo);

  Future<ApiResult<void>> register(RegisterStudentRequestBody body) {
    return authRepo.register(body);
  }
}
