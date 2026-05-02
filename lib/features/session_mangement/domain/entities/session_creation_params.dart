
class SessionCreationParams {
  final String name;
  final String location;
  final String connectionMethod;
  final DateTime startAt;
  final DateTime endAt;
  final double allowedRadius;
  final String networkSSID;
  final String networkBSSID;
  final double latitude;
  final double longitude;

  const SessionCreationParams({
    required this.name,
    required this.location,
    required this.connectionMethod,
    required this.startAt,
    required this.endAt,
    required this.allowedRadius,
    required this.networkSSID,
    required this.networkBSSID,
    required this.latitude,
    required this.longitude,
  });
}