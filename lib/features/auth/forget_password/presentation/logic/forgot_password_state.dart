import 'package:mobile_app/core/networking/api_error_model.dart';

abstract class ForgotPasswordState {}

class ForgotPasswordInitialState extends ForgotPasswordState {}

class ForgotPasswordSendOtpLoadingState extends ForgotPasswordState {}

class ForgotPasswordOtpSentState extends ForgotPasswordState {
  final String message;
  ForgotPasswordOtpSentState({required this.message});
}

class ForgotPasswordVerifyLoadingState extends ForgotPasswordState {}

class ForgotPasswordResetSuccessState extends ForgotPasswordState {
  final String message;
  ForgotPasswordResetSuccessState({required this.message});
}

class ForgotPasswordFailureState extends ForgotPasswordState {
  final ApiErrorModel error;
  ForgotPasswordFailureState({required this.error});
}

