import 'package:mobile_app/features/home/presentation/user/domain/entities/nearby_session.dart';
import 'package:mobile_app/features/home/presentation/user/domain/repos/session_discovery_repo.dart';

class DiscoverSessionsUseCase {
  final SessionDiscoveryRepository _repository;

  DiscoverSessionsUseCase(this._repository);

  Stream<NearbySession> call() {
    return _repository.discoverSessions();
  }
}