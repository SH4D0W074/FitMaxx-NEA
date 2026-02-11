import 'package:geolocator/geolocator.dart';

class LocationServiceGeolocator {
  Future<void> ensureReady() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) {
      throw Exception('Location services are disabled.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw Exception('Location permission denied.');
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission denied forever. Enable in Settings.');
    }
  }

  Future<Position> getCurrentPosition() async {
    await ensureReady();
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
    ),
    );
  }

  // Live stream used by tracker.
  // distanceFilter reduces jitter + write spam (e.g. 5 meters).
  Stream<Position> positionStream({
    int distanceFilterMeters = 5,
    LocationAccuracy accuracy = LocationAccuracy.best,
  }) {
    final settings = LocationSettings(
      accuracy: accuracy,
      distanceFilter: distanceFilterMeters,
    );
    return Geolocator.getPositionStream(locationSettings: settings);
  }
}
