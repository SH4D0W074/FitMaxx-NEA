import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitmaxx/components/my_roundbutton.dart';
import 'package:fitmaxx/pages/activities_page.dart';
import 'package:fitmaxx/pages/activityRecorder_page.dart';
import 'package:fitmaxx/pages/mealDiary_page.dart';
import 'package:fitmaxx/pages/settings_page.dart';
import 'package:fitmaxx/theme/dark_mode.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

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
      

      
    );
  }
}