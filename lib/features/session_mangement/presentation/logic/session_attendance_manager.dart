import 'dart:async';
import 'package:mobile_app/features/session_mangement/data/models/attendency_record.dart';
import 'package:mobile_app/features/session_mangement/domain/use_cases/listen_attendence_use_case.dart';

/// Manages the real-time attendance stream for an active session.
///
/// Responsibilities:
/// - Subscribes to the attendance stream via [ListenAttendanceUseCase].
/// - Notifies the caller of each new [AttendanceRecord] via [onNewRecord].
/// - Cancels the subscription cleanly on [dispose].
class SessionAttendanceManager {
  final ListenAttendanceUseCase _listenAttendanceUseCase;

  StreamSubscription<AttendanceRecord>? _subscription;

  SessionAttendanceManager(this._listenAttendanceUseCase);

  /// Starts listening. Cancels any previous subscription first.
  /// [onNewRecord] is called for every incoming attendance record.
  void startListening({required void Function(AttendanceRecord) onNewRecord}) {
    _subscription?.cancel();
    _subscription = _listenAttendanceUseCase().listen(
      onNewRecord,
      onError: (_) {}, // errors are silently ignored; session stays active
    );
  }

  /// Cancels the attendance stream subscription.
  Future<void> cancel() async {
    await _subscription?.cancel();
    _subscription = null;
  }

  void dispose() {
    _subscription?.cancel();
  }
}