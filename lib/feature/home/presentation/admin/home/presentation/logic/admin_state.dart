import 'package:mobile_app/feature/home/presentation/admin/home/data/models/server_info.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/domain/entities/attendency_record.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/domain/entities/session.dart';

sealed class AdminState {
  const AdminState();
}

// Initial & Loading States
final class AdminInitial extends AdminState {
  const AdminInitial();
}

final class AdminLoading extends AdminState {
  const AdminLoading();
}

final class AdminError extends AdminState {
  final String message;
  const AdminError(this.message);
}

// ✅ شيل الـ user من هنا - بس خلي selectedTabIndex
sealed class AdminStateWithTab extends AdminState {
  final int selectedTabIndex;
  
  const AdminStateWithTab({
    this.selectedTabIndex = 0,
  });
}

// ✅ شيل الـ user
final class AdminIdle extends AdminStateWithTab {
  const AdminIdle({
    super.selectedTabIndex,
  });

  AdminIdle copyWith({
    int? selectedTabIndex,
  }) {
    return AdminIdle(
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
    );
  }
}

// Session operation states
enum SessionOperation { creating, starting, active, ending, ended }

extension SessionOperationX on SessionOperation {
  String get message {
    switch (this) {
      case SessionOperation.creating:
        return 'Creating session...';
      case SessionOperation.starting:
        return 'Starting server...';
      case SessionOperation.ending:
        return 'Ending session...';
      case SessionOperation.ended:
        return 'Session ended successfully';
      case SessionOperation.active:
        return 'Session is active';
    }
  }
}

// ✅ شيل الـ user
final class SessionState extends AdminStateWithTab {
  final Session session;
  final SessionOperation operation;
  final ServerInfo? serverInfo;
  final AttendanceRecord? latestRecord;

  const SessionState({
    required this.session,
    required this.operation,
    this.serverInfo,
    this.latestRecord,
    super.selectedTabIndex,
  });

  bool get isLoading =>
      operation == SessionOperation.creating ||
      operation == SessionOperation.starting ||
      operation == SessionOperation.ending;

  bool get isActive => operation == SessionOperation.active;

  SessionState copyWith({
    Session? session,
    SessionOperation? operation,
    ServerInfo? serverInfo,
    AttendanceRecord? latestRecord,
    int? selectedTabIndex,
    bool clearLatestRecord = false,
  }) {
    return SessionState(
      session: session ?? this.session,
      operation: operation ?? this.operation,
      serverInfo: serverInfo ?? this.serverInfo,
      latestRecord: clearLatestRecord ? null : (latestRecord ?? this.latestRecord),
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
    );
  }
}

// ✅ شيل الـ user
final class SessionError extends AdminStateWithTab {
  final String message;
  final Session? session;

  const SessionError({
    required this.message,
    this.session,
    super.selectedTabIndex,
  });
}