import 'package:fitmaxx/models/consumed_food_model.dart';
import 'package:fitmaxx/models/food_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class CustomUser {
  // fields
  String id;
  String email;
  String username;
  String units;
  double height;
  double weight;
  int age;
  int targetCalories;
  double consumedCalories;
  double burnedCalories;
  List<Food>? foodLog;
  List<ConsumedFood>? consumedFoodLog = [];

  CustomUser({
    required this.id,
    required this.email, 
    required this.username,
    required this.units,
    required this.height,
    required this.weight,
    required this.age,
    required this.targetCalories,
    required this.consumedCalories,
    required this.burnedCalories,
    });

  // Create a CustomUser object from a Firestore document
  factory CustomUser.fromMap(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CustomUser(
      id: doc.id,
      email: data['email'],
      username: data['username'],
      units: data['units'],
      height: data['height']?.toDouble(),
      weight: data['weight']?.toDouble(),
      age: data['age'],
      targetCalories: data['targetCalories'],
      consumedCalories: data['consumedCalories']?.toDouble(),
      burnedCalories: data['burnedCalories']?.toDouble(),
    );
  }

  // Convert CustomUser object to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'units': units,
      'height': height,
      'weight': weight,
      'age': age,
      'targetCalories': targetCalories,
      'consumedCalories': consumedCalories,
      'burnedCalories': burnedCalories,
      'foodLog': foodLog?.map((food) => food.toMap()).toList() ?? [],
    };
  }
}