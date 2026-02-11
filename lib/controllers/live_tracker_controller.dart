import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

import '../models/map/activity_type.dart'; // TrackerActivityType
import '../models/map/route_point_model.dart';
import '../services/map_services/activity_tracker_service.dart';
import '../services/map_services/location_service_geolocator.dart';


/// - Start / Pause / Resume / Stop
/// - Live marker + polyline points
/// - Distance + time
/// - Auto-pause when still for N seconds
/// - Writes route points every ~minMetersBetweenSavedPoints to Firestore
class LiveTrackerController extends ChangeNotifier {
  LiveTrackerController({
    required this.locationService,
    required this.trackerService,
    this.distanceFilterMeters = 5,
    this.minMetersBetweenSavedPoints = 5.0,
    this.ignoreAccuracyAboveMeters = 40.0,
    this.autoPauseAfterStillSeconds = 8,
    this.stillSpeedThresholdMps = 0.5,
  });

  final LocationServiceGeolocator locationService;
  final ActivityTrackerService trackerService;

  final int distanceFilterMeters;
  final double minMetersBetweenSavedPoints;
  final double ignoreAccuracyAboveMeters;
  final int autoPauseAfterStillSeconds;
  final double stillSpeedThresholdMps;

  // ---- Public state ----
  TrackerActivityType activityType = TrackerActivityType.running;

  LatLng? currentLatLng;
  final List<LatLng> routePoints = [];

  bool isRecording = false;
  bool isPaused = false;
  bool isAutoPaused = false;

  double distanceMeters = 0.0;
  Duration elapsed = Duration.zero;

  String? activityId;

  // ---- Internals ----
  StreamSubscription<Position>? _sub;
  final Stopwatch _sw = Stopwatch();
  Timer? _timer;

  LatLng? _lastPoint;
  LatLng? _lastSavedPoint;
  double _lastSpeed = 0.0;
  int _stillSeconds = 0;

  // ---- Simple UI helpers ----
  void setActivityType(TrackerActivityType t) {
    activityType = t;
    notifyListeners();
  }

  String get distanceKmText => (distanceMeters / 1000).toStringAsFixed(2);

  String get elapsedText {
    final s = elapsed.inSeconds;
    final h = (s ~/ 3600).toString().padLeft(2, '0');
    final m = ((s % 3600) ~/ 60).toString().padLeft(2, '0');
    final sec = (s % 60).toString().padLeft(2, '0');
    return '$h:$m:$sec';
  }

  String get paceText {
    final km = distanceMeters / 1000;
    if (km <= 0) return '--:-- /km';
    final paceSec = elapsed.inSeconds / km;
    final min = (paceSec ~/ 60).toString().padLeft(2, '0');
    final sec = (paceSec.round() % 60).toString().padLeft(2, '0');
    return '$min:$sec /km';
  }

  @override
  void dispose() {
    _stopStreams();
    super.dispose();
  }

  Future<void> initCurrentLocation() async {
    final pos = await locationService.getCurrentPosition();
    currentLatLng = LatLng(pos.latitude, pos.longitude);
    notifyListeners();
  }

  Future<void> start({required String uid}) async {
    await locationService.ensureReady();

    final pos = await locationService.getCurrentPosition();
    final startLatLng = LatLng(pos.latitude, pos.longitude);

    // reset
    routePoints.clear();
    distanceMeters = 0.0;
    elapsed = Duration.zero;

    _lastPoint = null;
    _lastSavedPoint = null;
    _stillSeconds = 0;

    // create session
    activityId = const Uuid().v4();
    await trackerService.startActivity(
      uid: uid,
      activityId: activityId!,
      type: activityType,
      startLat: startLatLng.latitude,
      startLng: startLatLng.longitude,
    );

    isRecording = true;
    isPaused = false;
    isAutoPaused = false;

    _sw
      ..reset()
      ..start();

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      elapsed = _sw.elapsed;

      // auto-pause check (once per second)
      if (isRecording) {
        if (_lastSpeed < stillSpeedThresholdMps) {
          _stillSeconds++;
        } else {
          _stillSeconds = 0;
        }
        if (_stillSeconds >= autoPauseAfterStillSeconds) {
          pause(auto: true);
        }
      }

      notifyListeners();
    });

    _startStream(uid);

    // seed first point
    _acceptPoint(uid, startLatLng, pos.speed, pos.accuracy, forceSave: true);
    currentLatLng = startLatLng;
    notifyListeners();
  }

  Future<void> pause({bool auto = false}) async {
    if (!isRecording) return;

    isRecording = false;
    isPaused = true;
    isAutoPaused = auto;

    _sw.stop();
    await _sub?.cancel();
    _sub = null;

    notifyListeners();
  }

  Future<void> resume({required String uid}) async {
    if (!isPaused) return;

    await locationService.ensureReady();

    isPaused = false;
    isAutoPaused = false;
    isRecording = true;

    _stillSeconds = 0;

    // avoid distance jump
    final pos = await locationService.getCurrentPosition();
    currentLatLng = LatLng(pos.latitude, pos.longitude);
    _lastPoint = currentLatLng;

    _sw.start();
    _startStream(uid);

    notifyListeners();
  }

  Future<void> stopAndSave({required String uid}) async {
    if (activityId == null) return;

    await _sub?.cancel();
    _sub = null;

    isRecording = false;
    isPaused = false;
    isAutoPaused = false;

    _sw.stop();
    elapsed = _sw.elapsed;

    final end = currentLatLng;

    await trackerService.finishActivity(
      uid: uid,
      activityId: activityId!,
      endLat: end?.latitude ?? 0.0,
      endLng: end?.longitude ?? 0.0,
      distanceMeters: distanceMeters,
      durationSeconds: elapsed.inSeconds,
    );

    _timer?.cancel();
    _timer = null;

    notifyListeners();
  }

  Future<void> resetLocal() async {
    _stopStreams();
    routePoints.clear();
    distanceMeters = 0.0;
    elapsed = Duration.zero;
    activityId = null;

    isRecording = false;
    isPaused = false;
    isAutoPaused = false;

    _lastPoint = null;
    _lastSavedPoint = null;
    _stillSeconds = 0;

    notifyListeners();
  }

  // ---- Internal ----

  void _startStream(String uid) {
    _sub?.cancel();

    _sub = locationService
        .positionStream(
          distanceFilterMeters: distanceFilterMeters,
          accuracy: LocationAccuracy.best,
        )
        .listen((pos) {
      currentLatLng = LatLng(pos.latitude, pos.longitude);
      _lastSpeed = (pos.speed.isFinite && pos.speed >= 0) ? pos.speed : 0.0;

      if (!isRecording) {
        notifyListeners();
        return;
      }

      // accuracy filter
      if (pos.accuracy.isFinite && pos.accuracy > ignoreAccuracyAboveMeters) {
        notifyListeners();
        return;
      }

      _acceptPoint(uid, currentLatLng!, pos.speed, pos.accuracy);
      notifyListeners();
    });
  }

  void _acceptPoint(
    String uid,
    LatLng p,
    double? speed,
    double? accuracy, {
    bool forceSave = false,
  }) {
    // distance
    if (_lastPoint != null) {
      distanceMeters += Geolocator.distanceBetween(
        _lastPoint!.latitude,
        _lastPoint!.longitude,
        p.latitude,
        p.longitude,
      );
    }
    _lastPoint = p;

    // polyline (downsample slightly)
    if (routePoints.isEmpty ||
        Geolocator.distanceBetween(
              routePoints.last.latitude,
              routePoints.last.longitude,
              p.latitude,
              p.longitude,
            ) >=
            2.0) {
      routePoints.add(p);
    }

    // save route point occasionally
    if (forceSave || _shouldSave(p)) {
      _lastSavedPoint = p;
      if (activityId != null) {
        trackerService.addRoutePoint(
          uid: uid,
          activityId: activityId!,
          point: RoutePoint(
            lat: p.latitude,
            lng: p.longitude,
            speed: speed,
            accuracy: accuracy,
          ),
        );
      }
    }
  }

  bool _shouldSave(LatLng p) {
    if (_lastSavedPoint == null) return true;
    final d = Geolocator.distanceBetween(
      _lastSavedPoint!.latitude,
      _lastSavedPoint!.longitude,
      p.latitude,
      p.longitude,
    );
    return d >= minMetersBetweenSavedPoints;
  }

  void _stopStreams() {
    _sub?.cancel();
    _sub = null;

    _timer?.cancel();
    _timer = null;

    _sw.stop();
    _sw.reset();
  }
}
