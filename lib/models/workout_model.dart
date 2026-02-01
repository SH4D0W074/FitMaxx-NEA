import 'package:fitmaxx/models/exercise_model.dart';

class Workout {
  final String name;
  final List<Exercise> exercises;

  Workout({required this.name, required this.exercises});
}