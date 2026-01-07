import 'package:fitmaxx/models/food_model.dart';
import 'package:fitmaxx/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CustomUser? _user;
  List<Food> _foodLog = [];
  String? _userId;
  CustomUser? _currentUser; // Stores the current user's data

  // Fetch current user data
  Future<CustomUser?> getCurrentUser() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc =
          await _firestore.collection('Users').doc(user.uid).get();
      return CustomUser.fromMap(doc);
    }
    return null;
  }

  Future<void> createUserDocument(UserCredential? userCredential, CustomUser user,) async{
      if (userCredential!= null && userCredential.user != null) {
        await FirebaseFirestore.instance
        .collection("Users")
        .doc(userCredential.user!.uid)
        .set(
          user.toMap(),
        );
      }
    }
}