import 'package:mobile_app/core/networking/api_const.dart';
import 'package:mobile_app/core/networking/network_service.dart';
import 'package:mobile_app/features/student_auth/data/model/login_student_request_body.dart';
import 'package:mobile_app/features/student_auth/data/model/login_student_response_body.dart';
import 'package:mobile_app/features/student_auth/data/model/register_student_request_body.dart';

abstract class StudentAuthRemoteDataSource {
  Future<LoginStudentResponseBody> loginStudent(
    LoginStudentRequestBody requestBody,
  );
  Future<void> registerStudent(RegisterStudentRequestBody registerRequestBody);
}

class StudentAuthRemoteDataSourceImpl implements StudentAuthRemoteDataSource {
  final NetworkService networkService;

  StudentAuthRemoteDataSourceImpl({required this.networkService});

  @override
  Future<LoginStudentResponseBody> loginStudent(
    LoginStudentRequestBody requestBody,
  ) async {
    final response = await networkService.post(
      ApiConst.studetnLogin,
      requestBody.toJson(),
    );

    return LoginStudentResponseBody.fromJson(response.data);
  }

  @override
  Future<void> registerStudent(
    RegisterStudentRequestBody registerRequestBody,
  ) async {
    await networkService.post(
      ApiConst.studentRegister,
      registerRequestBody.toJson(),
    );
  }
}
