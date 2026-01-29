class Food {
  String? id;
  String foodName;
  int calories;
  double foodWeight;
  double protein;
  double carbs;
  double fats;


  Food({
      required this.id,
      required this.foodName,
      required this.calories,
      required this.foodWeight,
      required this.protein,
      required this.carbs,
      required this.fats,
    });

  // Create a Food object from a Firestore document
  factory Food.fromMap(Map<String, dynamic> data, String documentId) {
    return Food(
      id: documentId,
      foodName: data['foodName'],
      calories: data['calories'] ?? 0,
      foodWeight: data['foodWeight']?.toDouble() ?? 0.0,
      protein: data['protein']?.toDouble() ?? 0.0,
      carbs: data['carbs']?.toDouble() ?? 0.0,
      fats: data['fats']?.toDouble() ?? 0.0,
    );
  }

  // Convert Food object to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'documentId': id,
      'foodName': foodName,
      'calories': calories,
      'foodWeight': foodWeight,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
    };
  }
}