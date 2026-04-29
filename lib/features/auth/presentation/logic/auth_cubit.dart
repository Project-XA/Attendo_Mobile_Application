import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/core/current_user/data/models/user_model.dart';
import 'package:mobile_app/features/auth/domain/use_cases/register_use_case.dart';
import 'package:mobile_app/features/auth/domain/use_cases/forgot_password_use_case.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final RegisterUseCase registerUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;

  AuthCubit({
    required this.registerUseCase,
    required this.forgotPasswordUseCase,
  }) : super(const AuthState());

  Future<void> register({
    required String orgId,
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading, error: null));

    final result = await registerUseCase(
      orgId: orgId,
      email: email,
      password: password,
    );

    result.when(
      onSuccess: (user) => emit(state.copyWith(
        status: AuthStatus.registerSuccess,
        user: user,
      )),
      onError: (error) => emit(state.copyWith(
        status: AuthStatus.failure,
        error: error,
      )),
    );
  }

  Future<void> sendResetOtp({required String email}) async {
    emit(state.copyWith(status: AuthStatus.loading, error: null));

    final result = await forgotPasswordUseCase.sendResetOtp(email: email);

    result.when(
      onSuccess: (message) => emit(state.copyWith(
        status: AuthStatus.otpSent,
        email: email,    
        message: message,
      )),
      onError: (error) => emit(state.copyWith(
        status: AuthStatus.failure,
        error: error,
      )),
    );
  }

  Future<void> verifyOtpAndResetPassword({
    required String otp,
    required String newPassword,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading, error: null));

    final result = await forgotPasswordUseCase.verifyOtpAndResetPassword(
      email: state.email ?? '', 
      otp: otp,
      newPassword: newPassword,
    );

    result.when(
      onSuccess: (message) => emit(state.copyWith(
        status: AuthStatus.resetPasswordSuccess,
        message: message,
      )),
      onError: (error) => emit(state.copyWith(
        status: AuthStatus.failure,
        error: error,
      )),
    );
  }

  void resetState() => emit(const AuthState());
}