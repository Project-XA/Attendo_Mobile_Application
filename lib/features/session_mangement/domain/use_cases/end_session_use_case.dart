import 'package:mobile_app/features/session_mangement/domain/repos/session_repository.dart';

class EndSessionUseCase {
  final SessionRepository _repository;

  EndSessionUseCase(this._repository);

  Future<void> call(String sessionId) async {
    return await _repository.endSession(sessionId);
  }
}