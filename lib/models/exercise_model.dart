import 'package:cloud_firestore/cloud_firestore.dart';

class Exercise {
  final String id;
  final String name;
  final String sets;
  final String reps;
  final String weight;
  final DateTime? timestamp;
  bool isCompleted;

  Exercise({
    required this.id,
    required this.name,
    required this.sets,
    required this.reps,
    required this.weight,
    this.timestamp,
    this.isCompleted = false,

  });


  // Convert Exercise object to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'sets': sets,
      'reps': reps,
      'weight': weight,
      'timestamp': timestamp?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'isCompleted': isCompleted,
    };
    
  }
}