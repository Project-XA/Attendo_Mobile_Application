import 'package:geolocator/geolocator.dart';

enum LocationStatus {
  allowed,
  serviceDisabled,
  deniedForever,
}

class LocationHelper {
  static Future<LocationStatus> check() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return LocationStatus.serviceDisabled;
    }

    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return LocationStatus.deniedForever;
    }

    return LocationStatus.allowed;
  }
}
