import 'package:mobile_app/feature/home/presentation/user/domain/repos/user_attendence_repo.dart';

class CheckInUseCase {
  final UserAttendanceRepository _repository;

  CheckInUseCase(this._repository);

  Future<bool> call({
    required String sessionId,
    required String baseUrl,
    required String userId,
    required String userName,
    String? location,
  }) async {
    // Validate inputs
    if (sessionId.isEmpty) {
      throw Exception('Session ID is required');
    }
    if (userId.isEmpty || userName.isEmpty) {
      throw Exception('User information is required');
    }

    return await _repository.checkIn(
      sessionId: sessionId,
      baseUrl: baseUrl,
      userId: userId,
      userName: userName,
      location: location,
    );
  }
}