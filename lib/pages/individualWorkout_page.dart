import 'package:fitmaxx/components/exercise_tile.dart';
import 'package:fitmaxx/components/my_textfield.dart';
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

  // text controllers
  final exerciseNameController = TextEditingController();
  final exerciseWeightController = TextEditingController();
  final exerciseRepsController = TextEditingController();
  final exerciseSetsController = TextEditingController();


  // checkbox was tapped
  void onCheckBoxChanged(String workoutName, String exerciseName){
    Provider.of<WorkoutData>(context, listen: false).checkOffExercise(workoutName, exerciseName);
  }

    // save exercise
  void saveExercise() {
    // get exercise name from text controller
    String newExerciseName = exerciseNameController.text;
    String reps = (exerciseRepsController.text);
    String sets = (exerciseSetsController.text);
    String weight = exerciseWeightController.text;
    // add exercise to workout 
    Provider.of<WorkoutData>(context, listen: false).addExercise(
      widget.workoutName, 
      newExerciseName, 
      weight, 
      reps, 
      sets
    );
    // pop dialog
    Navigator.pop(context);
    clearControllers();
  }

  // cancel 
  void cancel() {
    Navigator.pop(context);
    clearControllers();
  }

  // clear controllers
  void clearControllers() {
    exerciseNameController.clear();
    exerciseWeightController.clear();
    exerciseRepsController.clear();
    exerciseSetsController.clear();
  }

  // create new exercise
  void createNewExercise() {
    showDialog(
      context: context, 
      builder: (context) =>  AlertDialog(
        title: Text("Add a new exercise"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // exercise name
            MyTextfield(hintText: "Exercise name", obscureText: false, controller: exerciseNameController),
            SizedBox(height: 5.0,),
            // weight
            MyTextfield(hintText: "Weight", obscureText: false, controller: exerciseWeightController),
            SizedBox(height: 5.0,),
            // reps
            MyTextfield(hintText: "Reps", obscureText: false, controller: exerciseRepsController),
            SizedBox(height: 5.0,),
            // sets
            MyTextfield(hintText: "Sets", obscureText: false, controller: exerciseSetsController),
          ],
        ),
        actions: [
          // cancel button
          MaterialButton(
            onPressed: cancel,
            child: Text("Cancel"),
          ),
          // save exercise button
          MaterialButton(
            onPressed: saveExercise,
            child: Text("Add"),
          ),
        ],
      ),
    );
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
          floatingActionButton: FloatingActionButton(
            elevation: 1,
            child: Icon(Icons.add),
            onPressed: createNewExercise,
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