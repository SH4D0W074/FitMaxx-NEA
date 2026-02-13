import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/map/activity_type.dart';
import '../../models/map/route_point_model.dart';
import '../../models/map/tracked_activity_model.dart';

class ActivityTrackerService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> _activityRef(String uid, String activityId) {
    return _db.collection('Users').doc(uid).collection('activities').doc(activityId);
  }

  CollectionReference<Map<String, dynamic>> _pointsCol(String uid, String activityId) {
    return _activityRef(uid, activityId).collection('routePoints');
  }

  // Create activity summary doc when user presses start
  Future<void> startActivity({
    required String uid,
    required String activityId,
    required TrackerActivityType type,
    required double startLat,
    required double startLng,
  }) async {
    final activity = TrackedActivity(
      id: activityId,
      type: type,
      activityName: 'Unnamed Activity',
      durationSeconds: 0,
      distanceMeters: 0.0,
      startLat: startLat,
      startLng: startLng,
      endLat: null,
      endLng: null,
      pointCount: 0,
      startedAt: null,
      endedAt: null,
    );

    await _activityRef(uid, activityId).set(
      activity.toMap(),
      SetOptions(merge: true),
    );
  }

  // Add route point and update summary stats while tracking
  Future<void> addRoutePoint({
    required String uid,
    required String activityId,
    required RoutePoint point,
  }) async {
    await _pointsCol(uid, activityId).add(point.toMap());

    await _activityRef(uid, activityId).set({
      'pointCount': FieldValue.increment(1),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // update activity name 
  Future<void> updateActivityName({
    required String uid,
    required String activityId,
    required String activityName,
    }) async {
      await _activityRef(uid, activityId).set({
        'activityName': activityName.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

  
  // Update distance/duration stats while tracking
  Future<void> updateLiveStats({
    required String uid,
    required String activityId,
    required double distanceMeters,
    required int durationSeconds,
  }) async {
    await _activityRef(uid, activityId).set({
      'distanceMeters': distanceMeters,
      'durationSeconds': durationSeconds,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // Mark activity finished on Stop
  Future<void> finishActivity({
    required String uid,
    required String activityId,
    required double endLat,
    required double endLng,
    required double distanceMeters,
    required int durationSeconds,
  }) async {
    await _activityRef(uid, activityId).set({
      'endedAt': FieldValue.serverTimestamp(),
      'endLat': endLat,
      'endLng': endLng,
      'distanceMeters': distanceMeters,
      'durationSeconds': durationSeconds,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // History list (latest first)
  Stream<List<TrackedActivity>> watchActivities(String uid) {
    return _db
        .collection('Users')
        .doc(uid)
        .collection('activities')
        .orderBy('startedAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => TrackedActivity.fromDoc(d)).toList());
  }

  // Route points for drawing polyline in details page
  Stream<List<RoutePoint>> watchRoutePoints(String uid, String activityId) {
    return _pointsCol(uid, activityId)
        .orderBy('t')
        .snapshots()
        .map((snap) => snap.docs.map((d) => RoutePoint.fromDoc(d)).toList());
  }
}
