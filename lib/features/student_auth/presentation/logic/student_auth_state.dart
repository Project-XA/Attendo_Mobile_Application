import 'package:equatable/equatable.dart';

enum AuthStudentStatus {
  initial,
  loading,
  loginSuccess,
  registerSuccess,
  failure,
}

class AuthStudentState extends Equatable {
  final AuthStudentStatus status;
  final String? errorMessage;
  final String? userEmail;

  const AuthStudentState({
    this.status = AuthStudentStatus.initial,
    this.errorMessage,
    this.userEmail,
  });

  AuthStudentState copyWith({
    AuthStudentStatus? status,
    String? errorMessage,
    String? userEmail,
  }) {
    return AuthStudentState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      userEmail: userEmail ?? this.userEmail,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, userEmail];
}
