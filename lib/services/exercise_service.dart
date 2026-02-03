import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitmaxx/models/exercise_model.dart';

class ExerciseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> exerciseLogRef(String userId, String workoutID) {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('workoutLog')
        .doc(workoutID)
        .collection('exercises');
  }

  // CREATE: add exercise
  Future<void> addExercise(String userID, String workoutID, Exercise newExercise) {
    final CollectionReference<Map<String, dynamic>> exercises = exerciseLogRef(userID, workoutID);
    
    return exercises.add(
      newExercise.toMap()
    );
  }



  //READ: get exercises from DB
  Stream<QuerySnapshot> getExercisesStream(String userID, String workoutID) {
    final CollectionReference<Map<String, dynamic>> exercises = exerciseLogRef(userID, workoutID);

    final exerciseStream = 
      exercises.orderBy('timestamp', descending: true).snapshots();

    return exerciseStream;
  }


  // UPDATE: UPDATE exercise GIVEN DOC id
  Future<void> updateExercise(String userID, String workoutID, String exerciseID, Exercise newExercise) {
    final CollectionReference<Map<String, dynamic>> exercises = exerciseLogRef(userID, workoutID);
    return exercises.doc(exerciseID).update(
      {
        newExercise.toMap()
      } as Map<Object, Object?>
    );
  }


  // DELETE Exercise GIVEN id
  Future<void> deleteExercise (String userID, String workoutID, String docID) {
    final CollectionReference<Map<String, dynamic>> exercises = exerciseLogRef(userID, workoutID);
    return exercises.doc(docID).delete();
  }

  // toggle checked status
  Future<void> toggleExerciseCompleted(String userID, String workoutID, String exerciseID, bool currentStatus) {
    final CollectionReference<Map<String, dynamic>> exercises = exerciseLogRef(userID, workoutID);
    return exercises.doc(exerciseID).update(
      {
        'isCompleted': !currentStatus,
      }
    );
  }
  
}