import 'package:mobile_app/feature/home/presentation/user/domain/entities/attendance_history.dart';
import 'package:mobile_app/feature/home/presentation/user/domain/entities/attendency_state.dart';

abstract class UserAttendanceRepository {
  Future<bool> checkIn({
    required String sessionId,
    required String baseUrl,
    required String userId,
    required String userName,
    String? location,
  });
  
  Future<List<AttendanceHistory>> getAttendanceHistory();
  Future<AttendanceStats> getAttendanceStats();
}