import 'package:mobile_app/features/attendance/domain/entities/nearby_session.dart';

sealed class DiscoveryState {
  const DiscoveryState();
}

final class DiscoveryIdle extends DiscoveryState {
  const DiscoveryIdle();
}

final class DiscoverySearching extends DiscoveryState {
  const DiscoverySearching();
}

final class DiscoverySessionFound extends DiscoveryState {
  final NearbySession activeSession;
  final List<NearbySession> allSessions;

  const DiscoverySessionFound({
    required this.activeSession,
    required this.allSessions,
  });

  DiscoverySessionFound copyWith({
    NearbySession? activeSession,
    List<NearbySession>? allSessions,
  }) {
    return DiscoverySessionFound(
      activeSession: activeSession ?? this.activeSession,
      allSessions: allSessions ?? this.allSessions,
    );
  }
}

final class DiscoveryTimeout extends DiscoveryState {
  const DiscoveryTimeout();
}

final class DiscoveryStopped extends DiscoveryState {
  const DiscoveryStopped();
}
