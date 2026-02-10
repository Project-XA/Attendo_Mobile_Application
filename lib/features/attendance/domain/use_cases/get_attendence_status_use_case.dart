import 'package:mobile_app/features/attendance/domain/entities/attendency_state.dart';
import 'package:mobile_app/features/attendance/domain/repos/user_attendence_repo.dart';

class GetAttendanceStatsUseCase {
  final UserAttendanceRepository repository;

  GetAttendanceStatsUseCase({required this.repository});

  Future<AttendanceStats> call() async {
    return await repository.getAttendanceStats();
  }

  Future<AttendanceStats?> callFromCache() async {
    return await repository.getCachedStatsOnly();
  }

  /// ⭐ أضف الـ method ده
  Future<void> saveToCache(AttendanceStats stats) async {
    return await repository.saveStatsToCache(stats);
  }
}