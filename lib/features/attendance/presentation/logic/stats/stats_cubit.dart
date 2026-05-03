import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/attendance/domain/entities/attendency_state.dart';
import 'package:mobile_app/features/attendance/domain/use_cases/get_attendence_status_use_case.dart';
import 'package:mobile_app/features/attendance/presentation/logic/stats/stats_state.dart';

class StatsCubit extends Cubit<StatsState> {
  final GetAttendanceStatsUseCase _getAttendanceStatsUseCase;
  AttendanceStats? _cachedStats;

  StatsCubit({required GetAttendanceStatsUseCase getAttendanceStatsUseCase})
    : _getAttendanceStatsUseCase = getAttendanceStatsUseCase,
      super(const StatsInitial());

  AttendanceStats? get cachedStats => _cachedStats;

  Future<void> loadStats() async {
    try {
      final cachedStats = await _getAttendanceStatsUseCase.callFromCache();

      if (cachedStats != null) {
        _cachedStats = cachedStats;
      
        if (!isClosed) {
          emit(StatsLoaded(stats: cachedStats));
        }
      } else {
        if (!isClosed) emit(const StatsLoading());
      }

      final freshStats = await _getAttendanceStatsUseCase.call();
      await _getAttendanceStatsUseCase.saveToCache(freshStats);
      _cachedStats = freshStats;

      if (!isClosed) {
        emit(StatsLoaded(stats: freshStats));
      }
    } catch (_) {
      if (!isClosed && _cachedStats == null) {
        emit(
          StatsLoaded(
            stats: AttendanceStats(
              totalSessions: 0,
              attendedSessions: 0,
              attendancePercentage: 0.0,
            ),
            hasError: true,
          ),
        );
      }
    }
  }

  Future<void> refreshStats() async {
    try {
      final freshStats = await _getAttendanceStatsUseCase.call();
      await _getAttendanceStatsUseCase.saveToCache(freshStats);
      _cachedStats = freshStats;

      if (!isClosed) {
        emit(StatsLoaded(stats: freshStats));
      }
    } catch (_) {
      if (!isClosed && _cachedStats != null) {
        emit(StatsLoaded(stats: _cachedStats!, hasError: true));
      }
    }
  }
}
