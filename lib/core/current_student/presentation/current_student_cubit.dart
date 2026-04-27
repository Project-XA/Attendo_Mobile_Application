import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/core/current_student/domain/use_case/get_current_student_use_case.dart';
import 'package:mobile_app/core/current_student/domain/use_case/update_profile_image_use_case.dart';
import 'package:mobile_app/core/current_student/presentation/current_student_state.dart';

class CurrentStudentCubit extends Cubit<CurrentStudentState> {
  final GetCurrentStudentUseCase _getCurrentStudentUseCase;
  final UpdateStudentProfileImageUseCase _updateProfileImageUseCase;

  CurrentStudentCubit({
    required GetCurrentStudentUseCase getCurrentStudentUseCase,
    required UpdateStudentProfileImageUseCase updateProfileImageUseCase,
  }) : _getCurrentStudentUseCase = getCurrentStudentUseCase,
       _updateProfileImageUseCase = updateProfileImageUseCase,
       super(const CurrentStudentState());

  Future<void> loadStudent() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final student = await _getCurrentStudentUseCase();
      emit(state.copyWith(student: student, isLoading: false, error: null));
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, error: 'Failed to load student: $e'),
      );
    }
  }

  Future<void> updateProfileImage(File imageFile) async {
    if (state.student == null) {
      emit(state.copyWith(error: 'No student loaded'));
      return;
    }

    emit(state.copyWith(isUpdatingImage: true, error: null));
    try {
      await _updateProfileImageUseCase(state.student!, imageFile: imageFile);
      final updatedStudent = await _getCurrentStudentUseCase();
      emit(state.copyWith(student: updatedStudent, isUpdatingImage: false));
    } catch (e) {
      emit(
        state.copyWith(
          isUpdatingImage: false,
          error: 'Failed to update image: $e',
        ),
      );
    }
  }

  // Getters
  bool get isStudentLoaded => state.student != null;
}
