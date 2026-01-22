import 'package:mobile_app/features/session_mangement/data/models/server_info.dart';
import 'package:mobile_app/features/session_mangement/domain/entities/attendency_record.dart';
import 'package:mobile_app/features/session_mangement/domain/entities/session.dart';

abstract class SessionRepository {
  Future<Session> createSession({
    required String name,
    required String location,
    required String connectionMethod,
    required DateTime startTime,
    required int durationMinutes,
  });

  Future<ServerInfo> startSessionServer(String sessionId);
  Future<void> endSession(String sessionId);
  Stream<AttendanceRecord> getAttendanceStream();
  Future<Session?> getCurrentActiveSession();
}