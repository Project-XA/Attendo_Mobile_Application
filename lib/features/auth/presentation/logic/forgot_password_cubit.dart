import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/auth/domain/use_cases/forgot_password_use_case.dart';
import 'package:mobile_app/features/auth/presentation/logic/forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final ForgotPasswordUseCase useCase;

  ForgotPasswordCubit(this.useCase) : super(ForgotPasswordInitialState());

  Future<void> sendResetOtp({required String email}) async {
    emit(ForgotPasswordSendOtpLoadingState());

    final result = await useCase.sendResetOtp(email: email);
    result.when(
      onSuccess: (message) {
        emit(ForgotPasswordOtpSentState(message: message));
      },
      onError: (error) {
        emit(ForgotPasswordFailureState(error: error));
      },
    );
  }

  Future<void> verifyOtpAndResetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    emit(ForgotPasswordVerifyLoadingState());

    final result = await useCase.verifyOtpAndResetPassword(
      email: email,
      otp: otp,
      newPassword: newPassword,
    );
    result.when(
      onSuccess: (message) {
        emit(ForgotPasswordResetSuccessState(message: message));
      },
      onError: (error) {
        emit(ForgotPasswordFailureState(error: error));
      },
    );
  }
}

