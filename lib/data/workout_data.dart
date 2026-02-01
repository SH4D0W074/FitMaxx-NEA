import 'package:fitmaxx/models/exercise_model.dart';
import 'package:fitmaxx/models/workout_model.dart';
import 'package:flutter/material.dart';

class WorkoutData extends ChangeNotifier{

  /* 
    WORKOUT DATA STRUCTURE

    - This overall list contains the different workouts
    - Each workout contains a name and a list of exercises

  */

  List<Workout> workoutList = [
    // default workout
    Workout(
      name: "Upper Body", 
      exercises: [
        Exercise(
          name: "Bicep Curls", 
          sets: 3, 
          reps: 12, 
          weight: "15"
          ),
        ]
      ),
    ];

  // get the list of workouts
  List<Workout> getWorkoutList() {
    return workoutList;
  }

  // get length of a given workout
  int numberOfExercisesInWorkout(String workoutName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    return relevantWorkout.exercises.length;
  }

  // add a workout
  void addWorkout(String workoutName) {
    // create a new workout with empty exercise list
    workoutList.add(
      Workout(name: workoutName, exercises: [])
    );

    notifyListeners();
  }

  // add an exercise to a workout
  void addExercise(String workoutName, Exercise exercise, String weight, String reps, String sets)  {
    // find the relevant workout
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    relevantWorkout.exercises.add(
      Exercise(
        name: exercise.name, 
        sets: int.parse(sets), 
        reps: int.parse(reps), 
        weight: weight
        )
      );

    notifyListeners();
  }

  // check off an exercise as completed
  void checkOffExercise(String workoutName, String exerciseName) {

    // find the relevant exercise
    Exercise relevantExercise = getRelevantExercise(workoutName, exerciseName);

    // mark as completed
    relevantExercise.isCompleted = !relevantExercise.isCompleted;

    notifyListeners();
  }

  // return relevant workout object, given a workout name
  Workout getRelevantWorkout(String workoutName) {
    Workout relevantWorkout = 
        workoutList.firstWhere((workout) => workout.name == workoutName);

    return relevantWorkout;
  }

  // return relevant exercise object, given an exercise name
  Exercise getRelevantExercise(String workoutName, String exerciseName) {
    // find the relevant workout
    Workout relevantWorkout = 
        getRelevantWorkout(workoutName);

    // find the relevant exercise
    Exercise relevantExercise = 
        relevantWorkout.exercises.firstWhere((exercise) => exercise.name == exerciseName);

    return relevantExercise;
  }

}