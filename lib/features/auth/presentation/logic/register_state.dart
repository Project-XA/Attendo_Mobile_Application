import 'package:mobile_app/features/home/data/models/user_model.dart';

sealed class RegisterState {}

final class RegisterInitialState extends RegisterState {}

final class RegisterLoadingState extends RegisterState {}

final class RegisterLoadedState extends RegisterState {
  final UserModel user;
  RegisterLoadedState({required this.user});
}

final class RegisterFailureState extends RegisterState {
  final String message;
  RegisterFailureState({required this.message});
}
