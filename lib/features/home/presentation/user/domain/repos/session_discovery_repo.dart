import 'package:mobile_app/features/home/presentation/user/domain/entities/nearby_session.dart';

abstract class SessionDiscoveryRepository {
  Stream<NearbySession> discoverSessions();
  Future<void> startDiscovery();
  Future<void> stopDiscovery();
  Future<NearbySession?> getSessionDetails(String baseUrl);
}