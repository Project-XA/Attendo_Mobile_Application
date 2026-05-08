import 'package:flutter/material.dart';
import 'package:mobile_app/features/session_mangement/data/models/remote_models/create_session_target.dart';
import 'package:mobile_app/features/session_mangement/domain/entities/session.dart';
import 'package:mobile_app/features/session_mangement/domain/use_cases/create_session_use_case.dart';
import 'package:mobile_app/features/session_mangement/domain/use_cases/end_session_use_case.dart';
import 'package:mobile_app/features/session_mangement/domain/use_cases/start_session_server_use_case.dart';
import 'package:mobile_app/features/session_mangement/domain/use_cases/delete_current_session_use_case.dart';
import 'package:mobile_app/features/session_mangement/domain/entities/server_info.dart';

/// Handles the core session lifecycle API calls:
/// create → start server → end → delete.
///
/// This class contains no state or UI logic — it only wraps use cases
/// and returns results or throws errors for the cubit to handle.
class SessionLifecycleHandler {
  final CreateSessionUseCase _createSession;
  final StartSessionServerUseCase _startServer;
  final EndSessionUseCase _endSession;
  final DeleteCurrentSessionUseCase _deleteSession;

  const SessionLifecycleHandler({
    required CreateSessionUseCase createSession,
    required StartSessionServerUseCase startServer,
    required EndSessionUseCase endSession,
    required DeleteCurrentSessionUseCase deleteSession,
  })  : _createSession = createSession,
        _startServer = startServer,
        _endSession = endSession,
        _deleteSession = deleteSession;

  /// Creates a session on the backend and returns the created [Session].
  Future<Session> create({
    required String name,
    required String location,
    required String connectionMethod,
    required TimeOfDay startTime,
    required int durationMinutes,
    required double allowedRadius,
    required CreateSessionTarget target,
  }) async {
    final now = DateTime.now();
    final sessionStartTime = DateTime(
      now.year, now.month, now.day,
      startTime.hour, startTime.minute,
    );

    return _createSession(
      name: name,
      location: location,
      connectionMethod: connectionMethod,
      startTime: sessionStartTime,
      durationMinutes: durationMinutes,
      allowedRadius: allowedRadius,
      target: target,
    );
  }

  /// Starts the session server and returns [ServerInfo] with connection details.
  Future<ServerInfo> startServer(int sessionId) {
    return _startServer(sessionId);
  }

  /// Ends the session on the backend.
  Future<void> end(int sessionId, Session session) {
    return _endSession(sessionId, session);
  }

  /// Deletes the current session on the backend.
  Future<void> delete() {
    return _deleteSession();
  }
}