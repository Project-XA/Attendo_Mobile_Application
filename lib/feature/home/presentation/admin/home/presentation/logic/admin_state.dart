// feature/home/presentation/admin/home/presentation/logic/admin_state.dart

import 'package:mobile_app/feature/home/domain/entities/user.dart';

sealed class AdminState {}

final class AdminInitial extends AdminState {}

final class AdminLoading extends AdminState {} 

final class AdminUserLoaded extends AdminState {
  final User user;
  AdminUserLoaded(this.user);
}

final class AdminError extends AdminState {
  final String message;
  AdminError(this.message);
}

final class ToggleTabChanged extends AdminState {
  final int selectedIndex;
  final User? user; // ✅ Add user to keep it available
  ToggleTabChanged(this.selectedIndex, this.user);
}