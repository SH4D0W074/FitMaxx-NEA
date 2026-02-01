class Exercise {
  final String name;
  final String sets;
  final String reps;
  final String weight;
  bool isCompleted;

  Exercise({
    required this.name,
    required this.sets,
    required this.reps,
    required this.weight,
    this.isCompleted = false,

  });


  // Convert Exercise object to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'sets': sets,
      'reps': reps,
      'weight': weight,
      'isCompleted': isCompleted,
    };
  }
}