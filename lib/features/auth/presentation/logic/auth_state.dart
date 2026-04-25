import 'package:equatable/equatable.dart';
import 'package:mobile_app/core/current_user/data/models/user_model.dart';
import 'package:mobile_app/core/networking/api_error_model.dart';

enum AuthStatus {
  initial,
  loading,
  registerSuccess,
  otpSent,
  resetPasswordSuccess,
  failure,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final ApiErrorModel? error;
  final UserModel? user;
  final String? email;     
  final String? message;

  const AuthState({
    this.status = AuthStatus.initial,
    this.error,
    this.user,
    this.email,
    this.message,
  });

  AuthState copyWith({
    AuthStatus? status,
    ApiErrorModel? error,
    UserModel? user,
    String? email,
    String? message,
  }) {
    return AuthState(
      status: status ?? this.status,
      error: error ?? this.error,
      user: user ?? this.user,
      email: email ?? this.email,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, error, user, email, message];
}