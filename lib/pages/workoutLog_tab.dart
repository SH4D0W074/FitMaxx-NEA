
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitmaxx/components/my_textfield.dart';
import 'package:fitmaxx/data/workout_data.dart';
import 'package:fitmaxx/models/user_model.dart';
import 'package:fitmaxx/models/workout_model.dart';
import 'package:fitmaxx/pages/individualWorkout_page.dart';
import 'package:fitmaxx/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkoutlogTab extends StatefulWidget {
  const WorkoutlogTab({super.key});

  @override
  State<WorkoutlogTab> createState() => _WorkoutlogTabState();
}

class _WorkoutlogTabState extends State<WorkoutlogTab> {

  // text controllers
  final newWorkoutNameController = TextEditingController();

  // create a new workout
  void createNewWorkout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Create new workout"),
        content: MyTextfield(hintText: "Emter workout name", obscureText: false, controller: newWorkoutNameController),
        actions: [
          // cancel button
          MaterialButton(
            onPressed: cancel,
            child: Text("Cancel"),
          ),
          // save new workout button
          MaterialButton(
            onPressed: saveWorkout,
            child: Text("Save"),
          ),
        ],
      )
    );
  }

  // go to workout page
  void goToWorkoutPage(String workoutName) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => WorkoutPage(workoutName: workoutName,)));
  }

  // save workout
  void saveWorkout() async {

    final userService = UserService();
    final CustomUser? user = await userService.getCurrentUser();

    if (user == null) return;
      // get new workout name from text controller
      String newWorkoutName = newWorkoutNameController.text;

    // Create a new document reference in the subcollection
    final workoutDocRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(user.id)
        .collection('workoutLog')
        .doc(); // auto-generated ID

    // Build ConsumedFood with the Firestore document ID
    final Workout newWorkout = Workout(
      id: workoutDocRef.id,
      name: newWorkoutName,
      exercises: [],
    );

    // Save to Firestore subcollection
    await workoutDocRef.set(newWorkout.toMap());

    // add workout to workout data list
    Provider.of<WorkoutData>(context, listen: false).addWorkout(workoutDocRef.id, newWorkoutName);
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
    newWorkoutNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: const Text(
            "w o r k o u t s", 
            ),
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          centerTitle: true,
        ),

        floatingActionButton: FloatingActionButton(
          elevation: 0,
          onPressed: createNewWorkout,
          child: const Icon(Icons.add, ),
        ),

        body: Center(
          child: ListView.builder(
            itemCount: value.getWorkoutList().length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Card(
                  elevation: 1,
                  child: ListTile(
                    title: Text(value.getWorkoutList()[index].name,),
                    trailing: IconButton(
                      icon: Icon(Icons.edit), 
                      onPressed: () => goToWorkoutPage(value.getWorkoutList()[index].name),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      )
    );
  }
}
