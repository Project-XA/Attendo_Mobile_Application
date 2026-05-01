import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/attendance/domain/entities/attendance_history.dart';
import 'package:mobile_app/features/attendance/domain/use_cases/get_attendence_history_use_case.dart';
import 'package:mobile_app/features/attendance/domain/use_cases/get_attendence_status_use_case.dart';
import 'package:mobile_app/features/user_analysis/presentation/logic/user_analysis_state.dart';

class UserAnalysisCubit extends Cubit<UserAnalysisState> {
  UserAnalysisCubit({
    required GetAttendanceStatsUseCase getAttendanceStatsUseCase,
    required GetAttendanceHistoryUseCase getAttendanceHistoryUseCase,
  })  : _useCase = getAttendanceStatsUseCase,
        _historyUseCase = getAttendanceHistoryUseCase,
        super(const UserAnalysisInitial());

  final GetAttendanceStatsUseCase _useCase;
  final GetAttendanceHistoryUseCase _historyUseCase;

  // ─── Page size for history pagination ────────────────────────────────────
  static const int _pageSize = 5;


  Future<void> loadStats() async {
    emit(const UserAnalysisLoading());

    final cached = await _useCase.callFromCache();
    if (cached != null) {
      emit(UserAnalysisCacheLoaded(stats: cached));
    }

    try {
      final fresh = await _useCase.call();
      await _useCase.saveToCache(fresh);

      // Preserve history data if we already had a loaded state
      final currentHistory = state is UserAnalysisLoaded
          ? (state as UserAnalysisLoaded).history
          : <AttendanceHistory>[];

      emit(UserAnalysisLoaded(
        stats: fresh,
        history: currentHistory,
        hasMoreHistory: currentHistory.isNotEmpty &&
            currentHistory.length >= _pageSize,
      ));
    } catch (e) {
      if (cached != null) {
        emit(UserAnalysisLoaded(stats: cached));
      } else {
        emit(UserAnalysisError(message: e.toString()));
      }
    }
  }

  Future<void> refresh() => loadStats();

  // ─── Appended: History logic ──────────────────────────────────────────────

  /// Loads the first [_pageSize] history records.
  /// Safe to call even if [loadStats] hasn't completed yet —
  /// it waits for a [UserAnalysisLoaded] state and patches it in-place.
  Future<void> loadHistory() async {
    final current = _requireLoaded();
    if (current == null) return;

    emit(current.copyWith(isHistoryLoading: true, clearHistoryError: true));

    try {
      final all = await _historyUseCase.call();
      final page = all.take(_pageSize).toList();

      emit(current.copyWith(
        isHistoryLoading: false,
        history: page,
        hasMoreHistory: all.length > _pageSize,
      ));
    } catch (e) {
      emit(current.copyWith(
        isHistoryLoading: false,
        historyError: e.toString(),
      ));
    }
  }

  /// Appends the next [_pageSize] records to the already-loaded list.
  Future<void> loadMoreHistory() async {
    final current = _requireLoaded();
    if (current == null) return;
    if (!current.hasMoreHistory || current.isHistoryLoading) return;

    emit(current.copyWith(isHistoryLoading: true, clearHistoryError: true));

    try {
      final all = await _historyUseCase.call();
      final nextEnd = current.history.length + _pageSize;
      final nextPage = all.take(nextEnd).toList();

      emit(current.copyWith(
        isHistoryLoading: false,
        history: nextPage,
        hasMoreHistory: all.length > nextEnd,
      ));
    } catch (e) {
      emit(current.copyWith(
        isHistoryLoading: false,
        historyError: e.toString(),
      ));
    }
  }

  // ─── Helper ──────────────────────────────────────────────────────────────

  UserAnalysisLoaded? _requireLoaded() {
    if (state is UserAnalysisLoaded) return state as UserAnalysisLoaded;
    return null;
  }
}