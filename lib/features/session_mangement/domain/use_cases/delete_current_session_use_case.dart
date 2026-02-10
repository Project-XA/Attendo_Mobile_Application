import 'package:mobile_app/features/session_mangement/domain/repos/session_repository.dart';

class DeleteCurrentSessionUseCase {
  final SessionRepository repository;

  DeleteCurrentSessionUseCase(this.repository);

  Future<void> call() async {
    return await repository.deleteCurrentSession();
  }
}
