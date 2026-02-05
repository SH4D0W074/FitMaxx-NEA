import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitmaxx/components/exercise_tile.dart';
import 'package:fitmaxx/components/my_textfield.dart';
import 'package:fitmaxx/data/workout_data.dart';
import 'package:fitmaxx/models/exercise_model.dart';
import 'package:fitmaxx/models/user_model.dart';
import 'package:fitmaxx/models/workout_model.dart';
import 'package:fitmaxx/services/exercise_service.dart';
import 'package:fitmaxx/services/user_service.dart';
import 'package:fitmaxx/services/workout_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkoutPage extends StatefulWidget {
  final String workoutName;
  final String workoutID;
  const WorkoutPage({super.key, required this.workoutName, required this.workoutID});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {

  // text controllers
  final exerciseNameController = TextEditingController();
  final exerciseWeightController = TextEditingController();
  final exerciseRepsController = TextEditingController();
  final exerciseSetsController = TextEditingController();
  

    // save exercise
  void saveExercise() async {
    // get exercise name and fields from text controller
    String newExerciseName = exerciseNameController.text;
    String reps = (exerciseRepsController.text);
    String sets = (exerciseSetsController.text);
    String weight = exerciseWeightController.text;
    
    final userService = UserService();
    final CustomUser? user = await userService.getCurrentUser();
    final ExerciseService exerciseService = ExerciseService();

    if (user == null) return;

    // Create a new document reference in the subcollection
    final exerciseDocRef = exerciseService.exerciseLogRef(user.id, widget.workoutID).doc();

    // Build exercise with the Firestore document ID
    final Exercise newExercise = Exercise(
      id: exerciseDocRef.id,
      name: newExerciseName,
      sets: sets,
      reps: reps,
      weight: weight,
      timestamp: DateTime.now(),
    );

    // Save to Firestore subcollection
    await exerciseService.addExercise(user.id, widget.workoutID, newExercise);
    
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
          body: StreamBuilder(
            stream: ExerciseService().getExercisesStream(
              FirebaseAuth.instance.currentUser!.uid, 
              widget.workoutID
              ),
            builder: (context, snapshot) {

              // if we have data, get all docs
              if (snapshot.hasData) {
              List exerciseList = snapshot.data!.docs;


              return ListView.builder(
                itemCount: exerciseList.length,
                itemBuilder: (context, index) {

                  DocumentSnapshot document = exerciseList[index];
                  // get individual doc
                  String docID = document.id;
                  // get exercise from each doc
                  Map<String, dynamic> data = 
                    document.data() as Map<String, dynamic>;
                  String exerciseName = data['name'];
                  String weight = data['weight'];
                  String reps = data['reps'];
                  String sets = data['sets'];
                  bool isCompleted = data['isCompleted'];

                  return ExerciseTile(
                  exerciseName: exerciseName, 
                  weight: weight, 
                  reps: reps, 
                  sets: sets, 
                  isCompleted: isCompleted,
                  onCheckBoxChanged: (val) => ExerciseService().toggleExerciseCompleted(
                    FirebaseAuth.instance.currentUser!.uid, 
                    widget.workoutID, 
                    docID,
                    isCompleted
                    ),
                );
                },
              );
            }
              else {
              return const Text('No exercises..');
              }
            }
          )
        );
      },
    );
  }
}