import 'package:mobile_app/features/session_mangement/data/models/attendency_record.dart';
import 'package:mobile_app/features/session_mangement/domain/entities/session.dart';

class SessionStateManager {
  Session? _currentSession;
  double? _latitude;
  double? _longitude;
  double? _allowedRadius;

  // ─── Getters ─────────────────────────────────────────────

  Session? get currentSession => _currentSession;
  double? get latitude => _latitude;
  double? get longitude => _longitude;
  double? get allowedRadius => _allowedRadius;

  bool hasSession(int sessionId) => _currentSession?.id == sessionId;

  // ─── Setters ─────────────────────────────────────────────

  void setSession(
    Session session, {
    required double latitude,
    required double longitude,
    required double allowedRadius,
  }) {
    _currentSession = session;
    _latitude = latitude;
    _longitude = longitude;
    _allowedRadius = allowedRadius;
  }

  void updateStatus(SessionStatus status) {
    _currentSession = _currentSession?.copyWith(status: status);
  }

  void updateAttendance(List<AttendanceRecord> attendanceList) {
    _currentSession = _currentSession?.copyWith(
      attendanceList: attendanceList,
      connectedClients: attendanceList.length,
    );
  }

  void clear() {
    _currentSession = null;
    _latitude = null;
    _longitude = null;
    _allowedRadius = null;
  }
}