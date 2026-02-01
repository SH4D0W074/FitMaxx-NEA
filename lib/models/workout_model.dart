import 'package:fitmaxx/models/exercise_model.dart';

class Workout {
  final String id;
  final String name;
  final List<Exercise> exercises;

  Workout({required this.id ,required this.name, required this.exercises});

  // Convert ConsumedFood object to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'exercises': exercises.map((e) => e.toMap()).toList(),
      
    };
  }

}