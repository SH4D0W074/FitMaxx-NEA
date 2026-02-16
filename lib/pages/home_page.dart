import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitmaxx/components/calories_card_component';
import 'package:fitmaxx/components/my_roundbutton.dart';
import 'package:fitmaxx/models/user_model.dart';
import 'package:fitmaxx/services/user_service.dart';
import 'package:fitmaxx/theme/dark_mode.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  // logout the user
  void logout() {
    FirebaseAuth.instance.signOut();
  }

  Future<int> getUserGoalCalories() async {
    UserService userService = UserService();
    CustomUser? currentUser = await userService.getCurrentUser();
    if (currentUser != null) {
      // Fetch user data from Firestore
      return currentUser.targetCalories; 
    } else {
      return 0; // Default value if user is not logged in
    }
  }
  Future<int> getUserConsumedCalories() async {
    UserService userService = UserService();
    CustomUser? currentUser = await userService.getCurrentUser();
    if (currentUser != null) {
      // Fetch user data from Firestore
      return 76; // Placeholder value, replace with actual data fetching logic
    } else {
      return 0; // Default value if user is not logged in
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
        'H O M E',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        centerTitle: true,
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           
          ],
        ),
      ),
      

      
    );
  }
}