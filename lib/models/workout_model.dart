import 'package:fitmaxx/models/exercise_model.dart';

class Workout {
  final String id;
  final String name;
  final List<Exercise> exercises;
  final DateTime? timestamp;

  Workout({required this.id ,required this.name, required this.exercises, required this.timestamp});

  // Convert ConsumedFood object to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'exercises': exercises.map((e) => e.toMap()).toList(),
      'timestamp': timestamp?.toIso8601String() ?? DateTime.now().toIso8601String(),
      
    };
  }

  factory Workout.fromMap(Map<String, dynamic> data, String id) {
    return Workout(
      id: id,
      name: data['name'] ?? '',
      exercises: [],
      timestamp: DateTime.tryParse(data['timestamp'] ?? '') ?? DateTime.now(),
      // exercises not stored here if using subcollection
    );
  }

}