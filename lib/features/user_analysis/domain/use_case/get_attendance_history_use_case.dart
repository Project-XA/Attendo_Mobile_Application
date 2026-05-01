import 'package:mobile_app/features/attendance/domain/entities/attendance_history.dart';
import 'package:mobile_app/features/attendance/domain/repos/user_attendence_repo.dart';

/// Returns the full list of [AttendanceHistory] entities from the repository.
/// Pagination is handled at the Cubit layer — the use-case stays pure.
class GetAttendanceHistoryUseCase {
  final UserAttendanceRepository repository;

  GetAttendanceHistoryUseCase({required this.repository});

  Future<List<AttendanceHistory>> call() async {
    return repository.getAttendanceHistory();
  }
}