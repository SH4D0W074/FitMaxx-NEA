import 'package:cloud_firestore/cloud_firestore.dart';

class CustomUser {
  // fields (stored in Users/{uid})
  String id;
  String email;
  String username;
  String units;
  double height;
  double weight;
  int age;
  int targetCalories;
  double burnedCalories;

  // NOTE:
  // consumedFoodLog is NOT stored in the user document anymore.
  // It is stored in a subcollection:
  // Users/{uid}/consumedFoodLog/{foodId}

  CustomUser({
    required this.id,
    required this.email,
    required this.username,
    required this.units,
    required this.height,
    required this.weight,
    required this.age,
    required this.targetCalories,
    required this.burnedCalories,
  });

  // Create a CustomUser object from a Firestore document (Users/{uid})
  factory CustomUser.fromMap(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    // Defensive default (prevents crash if doc is empty or missing)
    if (data == null) {
      return CustomUser(
        id: doc.id,
        email: "",
        username: "",
        units: "metric",
        height: 0,
        weight: 0,
        age: 0,
        targetCalories: 2000,
        burnedCalories: 0,
      );
    }

    return CustomUser(
      id: doc.id,
      email: (data['email'] as String?) ?? "",
      username: (data['username'] as String?) ?? "",
      units: (data['units'] as String?) ?? "metric",
      height: (data['height'] as num?)?.toDouble() ?? 0,
      weight: (data['weight'] as num?)?.toDouble() ?? 0,
      age: (data['age'] as num?)?.toInt() ?? 0,
      targetCalories: (data['targetCalories'] as num?)?.toInt() ?? 2000,
      burnedCalories: (data['burnedCalories'] as num?)?.toDouble() ?? 0,
    );
  }

  // Convert CustomUser object to a map for Firestore (Users/{uid})
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'username': username,
      'units': units,
      'height': height,
      'weight': weight,
      'age': age,
      'targetCalories': targetCalories,
      'burnedCalories': burnedCalories,
    };
  }
}