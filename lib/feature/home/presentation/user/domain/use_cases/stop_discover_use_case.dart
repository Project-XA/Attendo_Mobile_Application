import 'package:mobile_app/feature/home/presentation/user/domain/repos/session_discovery_repo.dart';

class StopDiscoveryUseCase {
  final SessionDiscoveryRepository _repository;

  StopDiscoveryUseCase(this._repository);

  Future<void> call() async {
    await _repository.stopDiscovery();
  }
}