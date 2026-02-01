class Exercise {
  final String name;
  final int sets;
  final int reps;
  final String weight;
  bool isCompleted;

  Exercise({
    required this.name,
    required this.sets,
    required this.reps,
    required this.weight,
    this.isCompleted = false,
    
  });
}