import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/core/current_user/domain/entities/user.dart';
import 'package:mobile_app/core/current_user/domain/use_case/get_current_user_use_case.dart';
import 'package:mobile_app/core/current_user/domain/use_case/update_profile_image_use_case.dart';
import 'package:mobile_app/core/current_user/domain/use_case/update_user_use_case.dart';
import 'package:mobile_app/core/current_user/presentation/cubits/current_user_state.dart';

class CurrentUserCubit extends Cubit<CurrentUserState> {
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final UpdateProfileImageUseCase _updateProfileImageUseCase;
  final UpdateUserUseCase _updateUserUseCase;

  CurrentUserCubit({
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required UpdateProfileImageUseCase updateProfileImageUseCase,
    required UpdateUserUseCase updateUserUseCase,
  })  : _getCurrentUserUseCase = getCurrentUserUseCase,
        _updateProfileImageUseCase = updateProfileImageUseCase,
        _updateUserUseCase = updateUserUseCase,
        super(const CurrentUserState());


  Future<void> loadUser() async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final user = await _getCurrentUserUseCase();

      emit(
        state.copyWith(
          user: user,
          isLoading: false,
          error: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Failed to load user: $e',
        ),
      );
    }
  }


  Future<void> updateProfileImage(File imageFile) async {
    if (state.user == null) {
      emit(state.copyWith(error: 'No user loaded'));
      return;
    }

    emit(state.copyWith(isUpdatingImage: true, error: null));

    try {
      await _updateProfileImageUseCase(imageFile);

      final updatedUser = await _getCurrentUserUseCase();

      emit(
        state.copyWith(
          user: updatedUser,
          isUpdatingImage: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isUpdatingImage: false,
          error: 'Failed to update image: $e',
        ),
      );
    }
  }

  Future<void> updateUser({
    String? firstNameAr,
    String? lastNameAr,
    String? address,
    String? email,
  }) async {
    if (state.user == null) {
      emit(state.copyWith(error: 'No user loaded'));
      return;
    }

    emit(state.copyWith(isUpdating: true, error: null));

    try {
      final updatedUser = state.user!.copyWith(
        firstNameAr: firstNameAr,
        lastNameAr: lastNameAr,
        address: address,
        email: email,
      );

      await _updateUserUseCase(updatedUser);

      emit(
        state.copyWith(
          user: updatedUser,
          isUpdating: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isUpdating: false,
          error: 'Failed to update user: $e',
        ),
      );
    }
  }

 


  User? get currentUser => state.user;

  String? get role {
    final user = state.user;
    if (user == null ||
        user.organizations == null ||
        user.organizations!.isEmpty) {
      return null;
    }
    return user.organizations!.first.role;
  }

  bool get isAdmin => role?.toLowerCase() == 'admin';

  bool get isUser => role?.toLowerCase() == 'user';
}