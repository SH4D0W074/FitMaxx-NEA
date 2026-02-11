import 'package:cloud_firestore/cloud_firestore.dart';

enum ActivityType { running, walking, cycling }

String activityTypeToString(ActivityType t) => t.name;
ActivityType activityTypeFromString(String s) =>
    ActivityType.values.firstWhere((e) => e.name == s, orElse: () => ActivityType.running);

class PlannedActivitySession {
  final String id;
  final String uid;
  final ActivityType type;

  final DateTime createdAt;
  final DateTime startedAt;
  final DateTime endedAt;

  final int durationSeconds;
  final double distanceMeters;

  final double startLat;
  final double startLng;
  final double endLat;
  final double endLng;

  // Encoded polyline from Google Directions
  final String plannedPolylineEncoded;

  final int? plannedDurationSeconds;
  final double? plannedDistanceMeters;

  PlannedActivitySession({
    required this.id,
    required this.uid,
    required this.type,
    required this.createdAt,
    required this.startedAt,
    required this.endedAt,
    required this.durationSeconds,
    required this.distanceMeters,
    required this.startLat,
    required this.startLng,
    required this.endLat,
    required this.endLng,
    required this.plannedPolylineEncoded,
    this.plannedDurationSeconds,
    this.plannedDistanceMeters,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'type': activityTypeToString(type),
      'createdAt': Timestamp.fromDate(createdAt),
      'startedAt': Timestamp.fromDate(startedAt),
      'endedAt': Timestamp.fromDate(endedAt),
      'durationSeconds': durationSeconds,
      'distanceMeters': distanceMeters,
      'startLat': startLat,
      'startLng': startLng,
      'endLat': endLat,
      'endLng': endLng,
      'plannedPolylineEncoded': plannedPolylineEncoded,
      'plannedDurationSeconds': plannedDurationSeconds,
      'plannedDistanceMeters': plannedDistanceMeters,
    };
  }

  static PlannedActivitySession fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PlannedActivitySession(
      id: doc.id,
      uid: (data['uid'] ?? '') as String,
      type: activityTypeFromString((data['type'] ?? 'running') as String),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      startedAt: (data['startedAt'] as Timestamp).toDate(),
      endedAt: (data['endedAt'] as Timestamp).toDate(),
      durationSeconds: (data['durationSeconds'] ?? 0) as int,
      distanceMeters: (data['distanceMeters'] ?? 0).toDouble(),
      startLat: (data['startLat'] ?? 0).toDouble(),
      startLng: (data['startLng'] ?? 0).toDouble(),
      endLat: (data['endLat'] ?? 0).toDouble(),
      endLng: (data['endLng'] ?? 0).toDouble(),
      plannedPolylineEncoded: (data['plannedPolylineEncoded'] ?? '') as String,
      plannedDurationSeconds: data['plannedDurationSeconds'] as int?,
      plannedDistanceMeters: (data['plannedDistanceMeters'] as num?)?.toDouble(),
    );
  }
}
