import 'package:mobile_app/feature/home/domain/entities/user.dart';
import 'package:mobile_app/feature/home/presentation/user/domain/entities/attendance_history.dart';
import 'package:mobile_app/feature/home/presentation/user/domain/entities/attendency_state.dart';
import 'package:mobile_app/feature/home/presentation/user/domain/entities/nearby_session.dart';

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

sealed class UserStateWithUser extends UserState {
  final User user;
  const UserStateWithUser({required this.user});
}

final class UserIdle extends UserStateWithUser {
  final AttendanceStats? stats;
  
  const UserIdle({
    required super.user,
    this.stats,
  });

  UserIdle copyWith({
    User? user,
    AttendanceStats? stats,
  }) {
    return UserIdle(
      user: user ?? this.user,
      stats: stats ?? this.stats,
    );
  }
}

// Session discovery states
final class SessionDiscoveryActive extends UserStateWithUser {
  final NearbySession? activeSession;
  final List<NearbySession> discoveredSessions;
  final bool isSearching;
  final AttendanceStats? stats;
  
  const SessionDiscoveryActive({
    required super.user,
    this.activeSession,
    this.discoveredSessions = const [],
    this.isSearching = false,
    this.stats,
  });

  SessionDiscoveryActive copyWith({
    User? user,
    NearbySession? activeSession,
    List<NearbySession>? discoveredSessions,
    bool? isSearching,
    AttendanceStats? stats,
    bool clearActiveSession = false,
  }) {
    return SessionDiscoveryActive(
      user: user ?? this.user,
      activeSession: clearActiveSession ? null : (activeSession ?? this.activeSession),
      discoveredSessions: discoveredSessions ?? this.discoveredSessions,
      isSearching: isSearching ?? this.isSearching,
      stats: stats ?? this.stats,
    );
  }
}

// Check-in operation states
enum CheckInOperation { idle, checkingIn, success, failed }

final class CheckInState extends UserStateWithUser {
  final NearbySession session;
  final CheckInOperation operation;
  final String? errorMessage;
  final DateTime? checkInTime;
  final AttendanceStats? stats;

  const CheckInState({
    required super.user,
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
    User? user,
    NearbySession? session,
    CheckInOperation? operation,
    String? errorMessage,
    DateTime? checkInTime,
    AttendanceStats? stats,
  }) {
    return CheckInState(
      user: user ?? this.user,
      session: session ?? this.session,
      operation: operation ?? this.operation,
      errorMessage: errorMessage ?? this.errorMessage,
      checkInTime: checkInTime ?? this.checkInTime,
      stats: stats ?? this.stats,
    );
  }
}

// Attendance history view state
final class AttendanceHistoryState extends UserStateWithUser {
  final List<AttendanceHistory> history;
  final AttendanceStats stats;
  final bool isLoading;

  const AttendanceHistoryState({
    required super.user,
    required this.history,
    required this.stats,
    this.isLoading = false,
  });

  AttendanceHistoryState copyWith({
    User? user,
    List<AttendanceHistory>? history,
    AttendanceStats? stats,
    bool? isLoading,
  }) {
    return AttendanceHistoryState(
      user: user ?? this.user,
      history: history ?? this.history,
      stats: stats ?? this.stats,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}