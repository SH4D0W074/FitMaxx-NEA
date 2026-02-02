import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitmaxx/models/user_model.dart';
import 'package:fitmaxx/models/workout_model.dart';
import 'package:fitmaxx/services/user_service.dart';

class WorkoutService {
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> workoutLogRef(String userId) {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('workoutLog');
  }

  // CREATE: add workout
  Future<void> addWorkout(String userID, Workout workout) {
    final CollectionReference<Map<String, dynamic>> workouts = workoutLogRef(userID);
    
    return workouts.add(
      workout.toMap()
    );
  }



  //READ: get workouts from DB
  Stream<QuerySnapshot> getWorkoutStream(String userID) {
    final CollectionReference<Map<String, dynamic>> workouts = workoutLogRef(userID);

    final workoutStream = 
      workouts.orderBy('timestamp', descending: true).snapshots();

    return workoutStream;
  }


  // UPDATE: UPDATE workout GIVEN DOC id
  Future<void> updateWorkout(String userID, String workoutID, String newWorkout) {
    final CollectionReference<Map<String, dynamic>> workouts = workoutLogRef(userID);
    return workouts.doc(workoutID).update(
      {
        'name': newWorkout,
        'timestamp': Timestamp.now(),
      }
    );
  }


  // DELETE WORKOUT GIVEN DOC id
  Future<void> deleteWorkout (String userID,String docID) {
    final CollectionReference<Map<String, dynamic>> workouts = workoutLogRef(userID);
    return workouts.doc(docID).delete();
  }

}