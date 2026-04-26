import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/student_auth/data/model/login_student_request_body.dart';
import 'package:mobile_app/features/student_auth/data/model/register_student_request_body.dart';
import 'package:mobile_app/features/student_auth/domain/use_case/student_login_use_case.dart';
import 'package:mobile_app/features/student_auth/domain/use_case/student_register_use_case.dart';
import 'package:mobile_app/features/student_auth/presentation/logic/student_auth_state.dart';

class AuthStudentCubit extends Cubit<AuthStudentState> {
  AuthStudentCubit({
    required this.studentLoginUseCase,
    required this.studentRegisterUseCase,
  }) : super(const AuthStudentState());

  final StudentLoginUseCase studentLoginUseCase;
  final StudentRegisterUseCase studentRegisterUseCase;
  Future<void> login(LoginStudentRequestBody loginRequest) async {
    emit(state.copyWith(status: AuthStudentStatus.loading, errorMessage: null));

    try {
      final result = await studentLoginUseCase(loginRequest);
      result.when(
        onSuccess: (_) =>
            emit(state.copyWith(status: AuthStudentStatus.loginSuccess)),
        onError: (error) => emit(
          state.copyWith(
            status: AuthStudentStatus.failure,
            errorMessage: error.message,
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStudentStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> register(RegisterStudentRequestBody requestBody) async {
    emit(state.copyWith(status: AuthStudentStatus.loading, errorMessage: null));

    final result = await studentRegisterUseCase.register(requestBody);
    result.when(
      onSuccess: (_) =>
          emit(state.copyWith(status: AuthStudentStatus.registerSuccess)),
      onError: (error) => emit(
        state.copyWith(
          status: AuthStudentStatus.failure,
          errorMessage: error.message,
        ),
      ),
    );
  }
}
