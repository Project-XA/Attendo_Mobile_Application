import 'package:mobile_app/core/current_user/data/models/user_model.dart';
import 'package:mobile_app/core/networking/api_error_model.dart';

sealed class RegisterState {}

final class RegisterInitialState extends RegisterState {}

final class RegisterLoadingState extends RegisterState {}

final class RegisterLoadedState extends RegisterState {
  final UserModel user;
  RegisterLoadedState({required this.user});
}

final class RegisterFailureState extends RegisterState {
  final ApiErrorModel error;
  RegisterFailureState({required this.error});
}
