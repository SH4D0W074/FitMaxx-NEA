import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutDay {
  final String dateKey;
  final int completedCount;
  final DateTime? updatedAt;

  WorkoutDay({
    required this.dateKey,
    required this.completedCount,
    required this.updatedAt,
  });

  factory WorkoutDay.fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return WorkoutDay(
      dateKey: doc.id,
      completedCount: (data['completedCount'] ?? 0) as int,
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'completedCount': completedCount,
      'updatedAt': updatedAt,
    };
  }
}
