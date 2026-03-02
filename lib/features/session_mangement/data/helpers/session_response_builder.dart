import 'package:mobile_app/features/session_mangement/domain/entities/session.dart';

class SessionResponseBuilder {
  static Map<String, dynamic> health({
    required int? sessionId,
    required Session? session,
  }) => {
    'status': 'active',
    'sessionId': sessionId?.toString(),
    'timestamp': DateTime.now().toIso8601String(),
    'name': session?.name ?? 'Active Session',
    'location': session?.location ?? 'Unknown',
  };

  static Map<String, dynamic> sessionInfo(Session session) => {
    'sessionId': session.id.toString(),
    'name': session.name,
    'location': session.location,
    'connectionMethod': session.connectionMethod,
    'startTime': session.startTime.toIso8601String(),
    'durationMinutes': session.durationMinutes,
    'status': _statusToString(session.status),
    'attendeeCount': session.attendanceList.length,
    'connectedClients': session.connectedClients,
    'timestamp': DateTime.now().toIso8601String(),
    'organizationId': session.organizationId,
  };

  static Map<String, dynamic> success(int? sessionId) => {
    'status': 'success',
    'message': 'Attendance recorded successfully',
    'time': DateTime.now().toIso8601String(),
    'sessionId': sessionId?.toString(),
  };

  static Map<String, dynamic> error(String message, {String? code}) => {
    'status': 'error',
    'message': message,
    if (code != null) 'code': code,
  };

  static String _statusToString(SessionStatus status) {
    switch (status) {
      case SessionStatus.active: return 'active';
      case SessionStatus.inactive: return 'inactive';
      case SessionStatus.ended: return 'ended';
    }
  }
}