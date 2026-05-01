import 'package:equatable/equatable.dart';
import 'package:mobile_app/features/attendance/domain/entities/attendency_state.dart';
import 'package:mobile_app/features/attendance/domain/entities/attendance_history.dart';

sealed class UserAnalysisState extends Equatable {
  const UserAnalysisState();

  @override
  List<Object?> get props => [];
}


final class UserAnalysisInitial extends UserAnalysisState {
  const UserAnalysisInitial();
}

final class UserAnalysisLoading extends UserAnalysisState {
  const UserAnalysisLoading();
}

final class UserAnalysisCacheLoaded extends UserAnalysisState {
  final AttendanceStats stats;
  const UserAnalysisCacheLoaded({required this.stats});

  @override
  List<Object?> get props => [stats];
}

final class UserAnalysisLoaded extends UserAnalysisState {
  final AttendanceStats stats;

  final List<AttendanceHistory> history;
  final bool hasMoreHistory;
  final bool isHistoryLoading;
  final String? historyError;

  const UserAnalysisLoaded({
    required this.stats,
    this.history = const [],
    this.hasMoreHistory = false,
    this.isHistoryLoading = false,
    this.historyError,
  });

  UserAnalysisLoaded copyWith({
    AttendanceStats? stats,
    List<AttendanceHistory>? history,
    bool? hasMoreHistory,
    bool? isHistoryLoading,
    String? historyError,
    bool clearHistoryError = false,
  }) {
    return UserAnalysisLoaded(
      stats: stats ?? this.stats,
      history: history ?? this.history,
      hasMoreHistory: hasMoreHistory ?? this.hasMoreHistory,
      isHistoryLoading: isHistoryLoading ?? this.isHistoryLoading,
      historyError: clearHistoryError ? null : (historyError ?? this.historyError),
    );
  }

  @override
  List<Object?> get props => [
        stats,
        history,
        hasMoreHistory,
        isHistoryLoading,
        historyError,
      ];
}

final class UserAnalysisError extends UserAnalysisState {
  final String message;
  const UserAnalysisError({required this.message});

  @override
  List<Object?> get props => [message];
}