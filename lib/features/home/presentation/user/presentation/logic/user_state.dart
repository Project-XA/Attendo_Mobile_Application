import 'package:mobile_app/features/home/presentation/user/domain/entities/attendance_history.dart';
import 'package:mobile_app/features/home/presentation/user/domain/entities/attendency_state.dart';
import 'package:mobile_app/features/home/presentation/user/domain/entities/nearby_session.dart';

sealed class UserState {
  const UserState();
}

final class UserInitial extends UserState {
  const UserInitial();
}

final class UserLoading extends UserState {
  const UserLoading();
}

final class UserError extends UserState {
  final String message;
  const UserError(this.message);
}

// ✅ شيل UserStateWithUser واعمل UserStateWithStats بدلها
sealed class UserStateWithStats extends UserState {
  const UserStateWithStats();
}

// ✅ شيل الـ user من هنا
final class UserIdle extends UserStateWithStats {
  final AttendanceStats? stats;
  
  const UserIdle({
    this.stats,
  });

  UserIdle copyWith({
    AttendanceStats? stats,
  }) {
    return UserIdle(
      stats: stats ?? this.stats,
    );
  }
}

// ✅ شيل الـ user من هنا
final class SessionDiscoveryActive extends UserStateWithStats {
  final NearbySession? activeSession;
  final List<NearbySession> discoveredSessions;
  final bool isSearching;
  final AttendanceStats? stats;

  const SessionDiscoveryActive({
    this.activeSession,
    this.discoveredSessions = const [],
    this.isSearching = false,
    this.stats,
  });

  SessionDiscoveryActive copyWith({
    NearbySession? activeSession,
    List<NearbySession>? discoveredSessions,
    bool? isSearching,
    AttendanceStats? stats,
    bool clearActiveSession = false,
  }) {
    return SessionDiscoveryActive(
      activeSession: clearActiveSession ? null : (activeSession ?? this.activeSession),
      discoveredSessions: discoveredSessions ?? this.discoveredSessions,
      isSearching: isSearching ?? this.isSearching,
      stats: stats ?? this.stats,
    );
  }
}

// ✅ شيل الـ user من هنا
final class CheckInState extends UserStateWithStats {
  final NearbySession session;
  final CheckInOperation operation;
  final String? errorMessage;
  final DateTime? checkInTime;
  final AttendanceStats? stats;

  const CheckInState({
    required this.session,
    required this.operation,
    this.errorMessage,
    this.checkInTime,
    this.stats,
  });

  bool get isLoading => operation == CheckInOperation.checkingIn;
  bool get isSuccess => operation == CheckInOperation.success;
  bool get isFailed => operation == CheckInOperation.failed;

  CheckInState copyWith({
    NearbySession? session,
    CheckInOperation? operation,
    String? errorMessage,
    DateTime? checkInTime,
    AttendanceStats? stats,
  }) {
    return CheckInState(
      session: session ?? this.session,
      operation: operation ?? this.operation,
      errorMessage: errorMessage ?? this.errorMessage,
      checkInTime: checkInTime ?? this.checkInTime,
      stats: stats ?? this.stats,
    );
  }
}

enum CheckInOperation { idle, checkingIn, success, failed }

// ✅ شيل الـ user من هنا
final class AttendanceHistoryState extends UserStateWithStats {
  final List<AttendanceHistory> history;
  final AttendanceStats stats;
  final bool isLoading;

  const AttendanceHistoryState({
    required this.history,
    required this.stats,
    this.isLoading = false,
  });

  AttendanceHistoryState copyWith({
    List<AttendanceHistory>? history,
    AttendanceStats? stats,
    bool? isLoading,
  }) {
    return AttendanceHistoryState(
      history: history ?? this.history,
      stats: stats ?? this.stats,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}