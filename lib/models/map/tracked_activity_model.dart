import 'package:cloud_firestore/cloud_firestore.dart';
import 'activity_type.dart';

class TrackedActivity {
  final String id;
  final TrackerActivityType type;
  final String activityName;

  final DateTime? startedAt; 
  final DateTime? endedAt;

  final int durationSeconds;
  final double distanceMeters;

  final double startLat;
  final double startLng;
  final double? endLat;
  final double? endLng;

  final int pointCount;

  TrackedActivity({
    required this.id,
    required this.type,
    required this.activityName,
    required this.durationSeconds,
    required this.distanceMeters,
    required this.startLat,
    required this.startLng,
    required this.pointCount,
    this.startedAt,
    this.endedAt,
    this.endLat,
    this.endLng,
  });

  Map<String, dynamic> toMap() {
    return {
      'activityName': activityName,
      'type': activityTypeToString(type),
      'startedAt': FieldValue.serverTimestamp(),
      'endedAt': null,
      'durationSeconds': durationSeconds,
      'distanceMeters': distanceMeters,
      'startLat': startLat,
      'startLng': startLng,
      'endLat': endLat,
      'endLng': endLng,
      'pointCount': pointCount,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  static TrackedActivity fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return TrackedActivity(
      id: doc.id,
      type: activityTypeFromString((data['type'] ?? 'running') as String),
      activityName: (data['activityName'] ?? 'Unnamed Activity') as String,
      startedAt: (data['startedAt'] as Timestamp?)?.toDate(),
      endedAt: (data['endedAt'] as Timestamp?)?.toDate(),
      durationSeconds: (data['durationSeconds'] ?? 0) as int,
      distanceMeters: (data['distanceMeters'] as num?)?.toDouble() ?? 0.0,
      startLat: (data['startLat'] as num).toDouble(),
      startLng: (data['startLng'] as num).toDouble(),
      endLat: (data['endLat'] as num?)?.toDouble(),
      endLng: (data['endLng'] as num?)?.toDouble(),
      pointCount: (data['pointCount'] ?? 0) as int,
    );
  }
}
