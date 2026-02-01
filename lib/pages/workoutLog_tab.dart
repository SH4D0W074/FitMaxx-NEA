
import 'package:fitmaxx/data/workout_data.dart';
import 'package:fitmaxx/pages/individualWorkout_page.dart';
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
        content: TextField(
          controller: newWorkoutNameController,
          decoration: InputDecoration(
            hintText: "Enter workout name",
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
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
  void saveWorkout() {
    // get new workout name from text controller
    String newWorkoutName = newWorkoutNameController.text;
    // add workout to workout data list
    Provider.of<WorkoutData>(context, listen: false).addWorkout(newWorkoutName);
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
