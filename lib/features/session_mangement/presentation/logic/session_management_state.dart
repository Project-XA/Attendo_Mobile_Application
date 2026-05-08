import 'package:mobile_app/core/networking/api_error_model.dart';
import 'package:mobile_app/features/session_mangement/data/models/remote_models/get_all_halls/get_all_halls_response.dart';
import 'package:mobile_app/features/session_mangement/data/models/remote_models/get_all_sections/get_all_sections_response.dart';
import 'package:mobile_app/features/session_mangement/domain/entities/server_info.dart';
import 'package:mobile_app/features/session_mangement/data/models/attendency_record.dart';
import 'package:mobile_app/features/session_mangement/domain/entities/session.dart';

sealed class SessionManagementState {
  const SessionManagementState();
}

final class SessionManagementInitial extends SessionManagementState {
  const SessionManagementInitial();
}

// SessionManagementLoading removed — loading is now handled
// via isLoadingHalls / isLoadingSections flags inside SessionManagementIdle.

sealed class SessionManagementStateWithTab extends SessionManagementState {
  final int selectedTabIndex;
  const SessionManagementStateWithTab({this.selectedTabIndex = 0});
}

final class SessionManagementIdle extends SessionManagementStateWithTab {
  final List<HallInfo>? halls;
  final bool isLoadingHalls;
  final List<SectionInfo>? sections;
  final bool isLoadingSections;

  const SessionManagementIdle({
    super.selectedTabIndex,
    this.halls,
    this.isLoadingHalls = false,
    this.sections,
    this.isLoadingSections = false,
  });

  SessionManagementIdle copyWith({
    int? selectedTabIndex,
    List<HallInfo>? halls,
    bool? isLoadingHalls,
    List<SectionInfo>? sections,
    bool? isLoadingSections,
  }) {
    return SessionManagementIdle(
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      halls: halls ?? this.halls,
      isLoadingHalls: isLoadingHalls ?? this.isLoadingHalls,
      sections: sections ?? this.sections,
      isLoadingSections: isLoadingSections ?? this.isLoadingSections,
    );
  }
}

enum SessionOperation {
  creating,
  starting,
  active,
  ending,
  ended,
  deleting,
  deleted,
}

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
      case SessionOperation.deleting:
        return 'Deleting session...';
      case SessionOperation.deleted:
        return 'Session deleted successfully';
    }
  }
}

final class SessionState extends SessionManagementStateWithTab {
  final Session session;
  final SessionOperation operation;
  final ServerInfo? serverInfo;
  final AttendanceRecord? latestRecord;
  final bool showWarning;
  final bool showNetworkError;

  const SessionState({
    required this.session,
    required this.operation,
    this.serverInfo,
    this.latestRecord,
    this.showWarning = false,
    this.showNetworkError = false,
    super.selectedTabIndex,
  });

  bool get isLoading =>
      operation == SessionOperation.creating ||
      operation == SessionOperation.starting ||
      operation == SessionOperation.ending ||
      operation == SessionOperation.deleting;

  bool get isActive => operation == SessionOperation.active;
  bool get isDeleted => operation == SessionOperation.deleted;

  SessionState copyWith({
    Session? session,
    SessionOperation? operation,
    ServerInfo? serverInfo,
    AttendanceRecord? latestRecord,
    int? selectedTabIndex,
    bool clearLatestRecord = false,
    bool? showWarning,
    bool? showNetworkError,
  }) {
    return SessionState(
      session: session ?? this.session,
      operation: operation ?? this.operation,
      serverInfo: serverInfo ?? this.serverInfo,
      latestRecord: clearLatestRecord ? null : (latestRecord ?? this.latestRecord),
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      showWarning: showWarning ?? this.showWarning,
      showNetworkError: showNetworkError ?? this.showNetworkError,
    );
  }
}

final class SessionError extends SessionManagementStateWithTab {
  final ApiErrorModel error;
  final Session? session;

  const SessionError({
    required this.error,
    this.session,
    super.selectedTabIndex,
  });

  String get message => error.message;
  bool get isNetworkError => error.isNetworkError;

  SessionError copyWith({
    ApiErrorModel? error,
    Session? session,
    int? selectedTabIndex,
  }) {
    return SessionError(
      error: error ?? this.error,
      session: session ?? this.session,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
    );
  }
}