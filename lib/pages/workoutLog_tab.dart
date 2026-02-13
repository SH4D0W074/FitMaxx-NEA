
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitmaxx/components/my_delete_button.dart';
import 'package:fitmaxx/components/my_edit_button.dart';
import 'package:fitmaxx/components/my_textfield.dart';
import 'package:fitmaxx/data/workout_data.dart';
import 'package:fitmaxx/models/user_model.dart';
import 'package:fitmaxx/models/workout_model.dart';
import 'package:fitmaxx/pages/individualWorkout_page.dart';
import 'package:fitmaxx/services/user_service.dart';
import 'package:fitmaxx/services/workout_service.dart';
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
        content: MyTextfield(hintText: "Enter workout name", obscureText: false, controller: newWorkoutNameController),
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
          )
        ],
      )
    );
  }

  void updateDialog(String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit workout"),
        content: MyTextfield(hintText: "Enter workout name", obscureText: false, controller: newWorkoutNameController),
        actions: [
          // cancel button
          MaterialButton(
            onPressed: cancel,
            child: Text("Cancel"),
          ),
          // save updated workout button
          MaterialButton(
            onPressed: () => updateWorkout(docId),
            child: Text("Update"),
          ),
        ],
      )
    );
  }

  // go to workout page
  void goToWorkoutPage(String workoutName, String workoutID) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => WorkoutPage(workoutName: workoutName, workoutID: workoutID,),),);
  }

  // save workout
  void saveWorkout() async {

    final userService = UserService();
    final CustomUser? user = await userService.getCurrentUser();
    final WorkoutService workoutService = WorkoutService();

    if (user == null) return;
      // get new workout name from text controller
      String newWorkoutName = newWorkoutNameController.text;

    // Create a new document reference in the subcollection
    final workoutDocRef = workoutService.workoutLogRef(user.id).doc();

    // Build workout with the Firestore document ID
    final Workout newWorkout = Workout(
      id: workoutDocRef.id,
      name: newWorkoutName,
      timestamp: DateTime.now(),
      date: workoutService.createDateTimeObject(workoutService.dayKey(DateTime.now())),
    );

    // Save to Firestore subcollection
    await workoutService.addWorkout(user.id, newWorkout);

    // pop dialog
    Navigator.pop(context);
    clearControllers();
  }
   // update workout
  void updateWorkout(String docId) async {

    final userService = UserService();
    final CustomUser? user = await userService.getCurrentUser();
    final WorkoutService workoutService = WorkoutService();

    if (user == null) return;
      // get new workout name from text controller
      String newWorkoutName = newWorkoutNameController.text;
    
    // Save to Firestore subcollection
    await workoutService.updateWorkout(user.id, docId,newWorkoutName);
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
          child: StreamBuilder(
            stream: WorkoutService().getWorkoutStream(FirebaseAuth.instance.currentUser!.uid),
            builder: (context, snapshot) {

              // if we have data, get all docs
              if (snapshot.hasData) {
              List workoutList = snapshot.data!.docs;



              return ListView.builder(
                itemCount: workoutList.length,
                itemBuilder: (context, index) {

                  DocumentSnapshot document = workoutList[index];
                  // get individual doc
                  String docID = document.id;
                  // get workout from each doc
                  Map<String, dynamic> data = 
                    document.data() as Map<String, dynamic>;
                  String workoutName = data['name'];

                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Card(
                      elevation: 1,
                      child: ListTile(
                        title: Text(workoutName),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: _buildDeleteButton(docID),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: _buildEditButton(docID),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: IconButton(
                                icon: Icon(Icons.arrow_forward_ios), 
                                onPressed: () => goToWorkoutPage(workoutName, docID),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }

            // if there is no data return nothing
          else {
            return const Text('');
          }
            }
          ),
        ),
      )
    );
  }
   Widget _buildDeleteButton(String workoutId) {
    return MyDeleteButton(
      onPressed: () async {
        await WorkoutService().deleteWorkout(FirebaseAuth.instance.currentUser!.uid, workoutId);
        setState(() {}); // Refresh the list after deletion
      },
      color: Theme.of(context).colorScheme.inversePrimary,
    );
  }

  Widget _buildEditButton(String workoutId) {
    return MyEditButton(
      onPressed: () => updateDialog(workoutId),
      color: Theme.of(context).colorScheme.inversePrimary,
     );
  }
}
