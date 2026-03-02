import 'dart:math';

class LocationValidator {
  final double sessionLatitude;
  final double sessionLongitude;
  final double allowedRadius;

  LocationValidator({
    required this.sessionLatitude,
    required this.sessionLongitude,
    required this.allowedRadius,
  });

  bool validate(String locationString) {
    try {
      final coords = locationString.split(',');
      if (coords.length != 2) return false;

      final userLat = double.parse(coords[0].trim());
      final userLng = double.parse(coords[1].trim());

      final distance = _calculateDistance(userLat, userLng);
      return distance <= allowedRadius;
    } catch (_) {
      return false;
    }
  }

  double _calculateDistance(double userLat, double userLng) {
    const earthRadius = 6371000;
    final dLat = _toRadians(sessionLatitude - userLat);
    final dLon = _toRadians(sessionLongitude - userLng);

    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(userLat)) *
            cos(_toRadians(sessionLatitude)) *
            (sin(dLon / 2) * sin(dLon / 2));

    return earthRadius * 2 * atan2(sqrt(a), sqrt(1 - a));
  }

  double _toRadians(double deg) => deg * pi / 180;
}