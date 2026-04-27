import 'package:equatable/equatable.dart';
import 'package:mobile_app/core/current_student/domain/entities/student.dart';

class CurrentStudentState extends Equatable {
  final Student? student;
  final bool isLoading;
  final bool isUpdatingImage;
  final String? error;

  const CurrentStudentState({
    this.student,
    this.isLoading = false,
    this.isUpdatingImage = false,
    this.error,
  });

  CurrentStudentState copyWith({
    Student? student,
    bool? isLoading,
    bool? isUpdatingImage,
    String? error,
  }) {
    return CurrentStudentState(
      student: student ?? this.student,
      isLoading: isLoading ?? this.isLoading,
      isUpdatingImage: isUpdatingImage ?? this.isUpdatingImage,
      error: error,
    );
  }

  @override
  List<Object?> get props => [student, isLoading, isUpdatingImage, error];
}