import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/attendance/data/services/discover_timer_service.dart';
import 'package:mobile_app/features/attendance/domain/entities/attendency_state.dart';
import 'package:mobile_app/features/attendance/domain/entities/nearby_session.dart';
import 'package:mobile_app/features/attendance/domain/use_cases/check_in_use_case.dart';
import 'package:mobile_app/features/attendance/domain/use_cases/discover_session_use_case.dart';
import 'package:mobile_app/features/attendance/domain/use_cases/get_attendence_history_use_case.dart';
import 'package:mobile_app/features/attendance/domain/use_cases/get_attendence_status_use_case.dart';
import 'package:mobile_app/features/attendance/domain/use_cases/start_discovery_use_case.dart';
import 'package:mobile_app/features/attendance/domain/use_cases/stop_discover_use_case.dart';
import 'package:mobile_app/features/attendance/presentation/logic/user_state.dart';

class UserCubit extends Cubit<UserState> {
  final StartDiscoveryUseCase startDiscoveryUseCase;
  final StopDiscoveryUseCase stopDiscoveryUseCase;
  final DiscoverSessionsUseCase discoverSessionsUseCase;
  final CheckInUseCase checkInUseCase;
  final GetAttendanceHistoryUseCase getAttendanceHistoryUseCase;
  final GetAttendanceStatsUseCase getAttendanceStatsUseCase;
  final DiscoveryTimerService _timerService;

  StreamSubscription<NearbySession>? _discoverySubscription;
  Duration searchTimeout = const Duration(seconds: 30);

  bool _sessionFound = false;
  AttendanceStats? _cachedStats;

  UserCubit({
    required this.startDiscoveryUseCase,
    required this.stopDiscoveryUseCase,
    required this.discoverSessionsUseCase,
    required this.checkInUseCase,
    required this.getAttendanceHistoryUseCase,
    required this.getAttendanceStatsUseCase,
    DiscoveryTimerService? timerService,
  }) : _timerService = timerService ?? DiscoveryTimerService(),
       super(const UserInitial());

  void setSearchTimeout(Duration duration) {
    searchTimeout = duration;
  }

  Future<void> loadStats() async {
    try {
      final cachedStats = await getAttendanceStatsUseCase.callFromCache();

      if (cachedStats != null) {
        _cachedStats = cachedStats;
        if (!isClosed) emit(UserIdle(stats: cachedStats, hasStatsError: false));
      } else {
        if (!isClosed) emit(const UserLoading());
      }

      final freshStats = await getAttendanceStatsUseCase.call();
      await getAttendanceStatsUseCase.saveToCache(freshStats);
      _cachedStats = freshStats;

      if (!isClosed) emit(UserIdle(stats: freshStats, hasStatsError: false));
    } catch (_) {
      if (!isClosed) {
        emit(
          UserIdle(
            stats:
                _cachedStats ??
                AttendanceStats(
                  totalSessions: 0,
                  attendedSessions: 0,
                  attendancePercentage: 0.0,
                ),
            hasStatsError: true,
          ),
        );
      }
    }
  }

  // Discovery

  Future<void> startSessionDiscovery() async {
    try {
      _sessionFound = false;

      emit(
        SessionDiscoveryActive(
          isSearching: true,
          stats: _currentStats,
          hasStatsError: _currentHasError,
        ),
      );

      await startDiscoveryUseCase.call();

      // Delegate timeout tracking to the service
      _timerService.startSearchTimeout(
        timeout: searchTimeout,
        onTimeout: _handleSearchTimeout,
      );

      // Delegate periodic refresh to the service
      _timerService.startSessionRefresh(onRefresh: _refreshSessions);

      _discoverySubscription?.cancel();
      _discoverySubscription = discoverSessionsUseCase.call().listen((session) {
        _sessionFound = true;
        _timerService.cancelSearchTimeout();
        _handleDiscoveredSession(session);
      }, onError: (_) {});
    } catch (_) {
      emit(UserIdle(stats: _currentStats, hasStatsError: _currentHasError));
    }
  }

  Future<void> stopSessionDiscovery() async {
    try {
      await _cancelDiscovery();
      await stopDiscoveryUseCase.call();

      if (!isClosed) {
        emit(UserIdle(stats: _currentStats, hasStatsError: _currentHasError));
      }
    } catch (_) {}
  }

  Future<void> refreshSessions() async {
    final currentState = state;
    if (currentState is SessionDiscoveryActive) {
      _sessionFound = false;
      emit(currentState.copyWith(isSearching: true, clearActiveSession: false));

      _timerService.startSearchTimeout(
        timeout: searchTimeout,
        onTimeout: _handleSearchTimeout,
      );
    } else {
      await startSessionDiscovery();
    }
  }

  // Check In

  Future<void> checkIn(
    NearbySession session, {
    required String userId,
    required String userName,
  }) async {
    try {
      emit(
        CheckInState(
          session: session,
          operation: CheckInOperation.checkingIn,
          stats: _currentStats,
        ),
      );

      final response = await checkInUseCase.call(
        sessionId: session.sessionId,
        baseUrl: session.baseUrl,
        userId: userId,
        userName: userName,
        location: session.location,
      );

      if (response.success) {
        final freshStats = await getAttendanceStatsUseCase.call();
        await getAttendanceStatsUseCase.saveToCache(freshStats);
        _cachedStats = freshStats;

        if (!isClosed) {
          emit(
            CheckInState(
              session: session,
              operation: CheckInOperation.success,
              checkInTime: DateTime.now(),
              stats: freshStats,
            ),
          );
        }

        await Future.delayed(const Duration(seconds: 2));
        if (!isClosed) await stopSessionDiscovery();
      } else {
        if (!isClosed) {
          emit(
            CheckInState(
              session: session,
              operation: CheckInOperation.failed,
              errorMessage: response.message,
              stats: _currentStats,
            ),
          );
        }

        await Future.delayed(const Duration(seconds: 2));
        if (!isClosed) await _restartDiscovery();
      }
    } catch (e) {
      if (!isClosed) {
        emit(
          CheckInState(
            session: session,
            operation: CheckInOperation.failed,
            errorMessage: e.toString(),
            stats: _currentStats,
          ),
        );
      }

      await Future.delayed(const Duration(seconds: 2));
      if (!isClosed) await _restartDiscovery();
    }
  }

  // History

  Future<void> loadAttendanceHistory() async {
    try {
      if (!isClosed) {
        emit(
          AttendanceHistoryState(
            history: const [],
            stats:
                _currentStats ??
                AttendanceStats(
                  totalSessions: 0,
                  attendedSessions: 0,
                  attendancePercentage: 0,
                ),
            isLoading: true,
          ),
        );
      }

      final history = await getAttendanceHistoryUseCase.call();
      final stats = await getAttendanceStatsUseCase.call();

      await getAttendanceStatsUseCase.saveToCache(stats);
      _cachedStats = stats;

      if (!isClosed) {
        emit(
          AttendanceHistoryState(
            history: history,
            stats: stats,
            isLoading: false,
          ),
        );
      }
    } catch (e) {
      if (!isClosed) emit(UserError('Failed to load history: $e'));
    }
  }

  // Private helpers

  void _handleSearchTimeout() {
    final currentState = state;
    if (currentState is! SessionDiscoveryActive) return;

    emit(
      currentState.copyWith(
        isSearching: false,
        clearActiveSession: currentState.discoveredSessions.isEmpty,
      ),
    );
  }

  void _handleDiscoveredSession(NearbySession session) {
    final currentState = state;
    if (currentState is! SessionDiscoveryActive) return;

    final alreadyExists = currentState.discoveredSessions.any(
      (s) => s.sessionId == session.sessionId,
    );
    if (alreadyExists) return;

    emit(
      currentState.copyWith(
        discoveredSessions: [...currentState.discoveredSessions, session],
        activeSession: currentState.activeSession ?? session,
        isSearching: false,
      ),
    );
  }

  void _refreshSessions() {
    final currentState = state;
    if (currentState is! SessionDiscoveryActive) return;

    final now = DateTime.now();
    final activeSessions = currentState.discoveredSessions
        .where((s) => s.endTime.isAfter(now))
        .toList();

    if (activeSessions.length == currentState.discoveredSessions.length) return;

    emit(currentState.copyWith(discoveredSessions: activeSessions));

    if (activeSessions.isEmpty) {
      emit(currentState.copyWith(clearActiveSession: true, isSearching: false));
    }
  }

  Future<void> _restartDiscovery() async {
    await _cancelDiscovery();
    try {
      await stopDiscoveryUseCase.call();
    } catch (_) {}
    if (!isClosed) await startSessionDiscovery();
  }

  Future<void> stopSearch() async {
    await stopSessionDiscovery();
  }

  Future<void> _cancelDiscovery() async {
    await _discoverySubscription?.cancel();
    _discoverySubscription = null;
    _sessionFound = false;
    _timerService.cancel();
  }

  AttendanceStats? get _currentStats {
    return state is UserStateWithStats
        ? (state as UserStateWithStats).stats
        : _cachedStats;
  }

  bool get _currentHasError {
    return state is UserStateWithStats
        ? (state as UserStateWithStats).hasStatsError
        : false;
  }

  @override
  Future<void> close() {
    _timerService.dispose();
    _discoverySubscription?.cancel();
    return super.close();
  }
}
