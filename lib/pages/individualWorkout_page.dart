import 'package:fitmaxx/components/exercise_tile.dart';
import 'package:fitmaxx/data/workout_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkoutPage extends StatefulWidget {
  final String workoutName;
  const WorkoutPage({super.key, required this.workoutName});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {

  // checkbox was tapped
  void onCheckBoxChanged(String workoutName, String exerciseName){
    Provider.of<WorkoutData>(context, listen: false).checkOffExercise(workoutName, exerciseName);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, workoutData, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.workoutName),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          body: ListView.builder(
            itemCount: workoutData.numberOfExercisesInWorkout(widget.workoutName),
            itemBuilder: (context, index) => ExerciseTile(
              exerciseName: workoutData.getRelevantWorkout(widget.workoutName).exercises[index].name, 
              weight: workoutData.getRelevantWorkout(widget.workoutName).exercises[index].weight, 
              reps: workoutData.getRelevantWorkout(widget.workoutName).exercises[index].reps, 
              sets: workoutData.getRelevantWorkout(widget.workoutName).exercises[index].sets, 
              isCompleted: workoutData.getRelevantWorkout(widget.workoutName).exercises[index].isCompleted,
              onCheckBoxChanged: (val) => onCheckBoxChanged(widget.workoutName, workoutData.getRelevantWorkout(widget.workoutName).exercises[index].name),
            ),
          )
        );
      },
    );
  }
}