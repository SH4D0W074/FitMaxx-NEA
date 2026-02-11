import 'package:geolocator/geolocator.dart';

class TrackerWritePolicy {
  final double minMetersBetweenSavedPoints;
  TrackerWritePolicy({this.minMetersBetweenSavedPoints = 5});

  bool shouldSavePoint({
    required double lastSavedLat,
    required double lastSavedLng,
    required double newLat,
    required double newLng,
  }) {
    final d = Geolocator.distanceBetween(
      lastSavedLat,
      lastSavedLng,
      newLat,
      newLng,
    );
    return d >= minMetersBetweenSavedPoints;
  }
}
