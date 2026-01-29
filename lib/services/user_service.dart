import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitmaxx/models/food_model.dart';
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
}
