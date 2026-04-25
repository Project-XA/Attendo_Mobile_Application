class DiscoveredSession {
  final String sessionId;
  final String ipAddress;
  final int port;
  final DateTime timestamp;
  final String? name;
  final String? location;
  final int? organizationId;

  DiscoveredSession({
    required this.sessionId,
    required this.ipAddress,
    required this.port,
    required this.timestamp,
    this.name,
    this.organizationId,
    this.location,
  });

  String get baseUrl => 'http://$ipAddress:$port';
}
