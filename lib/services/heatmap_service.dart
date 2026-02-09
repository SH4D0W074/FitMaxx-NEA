import 'package:cloud_firestore/cloud_firestore.dart';

class HeatmapService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> _dayRef(String uid, String dateKey) {
    return _db.collection('Users').doc(uid).collection('dailyWorkouts').doc(dateKey);
  }

  Future<void> markExerciseComplete({required String uid, required String dateKey, required String workoutId, required String exerciseId, required String exerciseName,}) async {
    // Get reference to the day's document and the specific exercise completion document
    final dayRef = _dayRef(uid, dateKey);
    final completionRef = dayRef.collection('completedExercises').doc(exerciseId);

    // Check if already marked complete
    final existing = await completionRef.get();
    if (existing.exists) return;

    await dayRef.set({
      'completedCount': FieldValue.increment(1),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await completionRef.set({
      'workoutId': workoutId,
      'exerciseName': exerciseName,
      'completedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> unmarkExerciseComplete({required String uid, required String dateKey, required String exerciseId,}) async {
    final dayRef = _dayRef(uid, dateKey);
    final completionRef = dayRef.collection('completedExercises').doc(exerciseId);

    final existing = await completionRef.get();
    if (!existing.exists) return;

    await completionRef.delete();

    await dayRef.set({
      'completedCount': FieldValue.increment(-1),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchWorkoutDays(String uid) {
    return _db.collection('Users').doc(uid).collection('dailyWorkouts').snapshots();
  }

  Stream<Set<String>> watchCompletedExerciseIdsForDay(String uid, String dateKey) {
    return _dayRef(uid, dateKey)
        .collection('completedExercises')
        .snapshots()
        .map((snap) => snap.docs.map((d) => d.id).toSet());
  }
}
