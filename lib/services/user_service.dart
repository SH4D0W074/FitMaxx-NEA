import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitmaxx/models/consumed_food_model.dart';
import 'package:fitmaxx/models/food_model.dart';
import 'package:fitmaxx/models/macro_totals.dart';
import 'package:fitmaxx/models/user_model.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CustomUser? _user;
  List<Food> _foodLog = [];
  String? _userId;
  CustomUser? _currentUser;

  // Fetch current user data
  Future<CustomUser?> getCurrentUser() async {
    final User? user = _auth.currentUser;
    if (user == null) return null;

    final DocumentSnapshot doc =
        await _firestore.collection('Users').doc(user.uid).get();

    return CustomUser.fromMap(doc);
  }

  Future<void> createUserDocument(
    UserCredential? userCredential,
    CustomUser user,
  ) async {
    if (userCredential?.user == null) return;

    await _firestore
        .collection("Users")
        .doc(userCredential!.user!.uid)
        .set(user.toMap());
  }

  // Delete consumed food document
  Future<void> deleteFood(String userId, String consumedFoodId) {
    return _firestore
        .collection('Users')
        .doc(userId)
        .collection('consumedFoodLog')
        .doc(consumedFoodId)
        .delete();
  }

  // Stream consumed foods for the current user
  Stream<QuerySnapshot<Map<String, dynamic>>> watchConsumedFoods(String userId) {
    return _firestore
        .collection('Users')
        .doc(userId)
        .collection('consumedFoodLog')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Stream macros consumed today for the current user
  Stream<MacroTotals> watchTodayMacro(String userId) {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('consumedFoodLog')
        .snapshots()
        .map((snapshot) {
          final foods = snapshot.docs
              .map((doc) => ConsumedFood.fromDoc(doc.id, doc.data()))
              .where((food) => _isSameDay(food.timestamp, DateTime.now()))
              .toList();

          double totalProtein = foods.fold(0, (sum, food) => sum + food.protein);
          double totalCarbs = foods.fold(0, (sum, food) => sum + food.carbs);
          double totalFats = foods.fold(0, (sum, food) => sum + food.fat);
          double totalCalories = foods.fold(0, (sum, food) => sum + food.calories);
          
          return MacroTotals(
            protein: totalProtein,
            carbs: totalCarbs,
            fat: totalFats,
            calories: totalCalories.toInt(),
          );
      });
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year &&
          a.month == b.month &&
          a.day == b.day;
  }

  Future<void> updateUserProfile({
    required String userId,
    String? username,
    int? height,
    int? age,
    double? weight,
  }) async {
      final data = <String, dynamic>{};

      if (username != null) data['username'] = username;
      if (height != null) data['height'] = height;
      if (age != null) data['age'] = age;
      if (weight != null) data['weight'] = weight;

      data['updatedAt'] = FieldValue.serverTimestamp();

      await _firestore.collection('Users').doc(userId).update(data);
  }

  Future<void> updateTargetCalories(String userId,int newTargetCalories) async {
    await _firestore.collection('Users').doc(userId).update({
      'targetCalories': newTargetCalories,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
