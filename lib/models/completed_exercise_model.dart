import 'package:cloud_firestore/cloud_firestore.dart';

class CompletedExercise {
  final String exerciseId;
  final String workoutId;
  final String exerciseName;
  final DateTime? completedAt;

  CompletedExercise({
    required this.exerciseId,
    required this.workoutId,
    required this.exerciseName,
    required this.completedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'workoutId': workoutId,
      'exerciseName': exerciseName,
      'completedAt': FieldValue.serverTimestamp(),
    };
  }
}
