import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitmaxx/auth/login_or_register.dart';
import 'package:fitmaxx/pages/navbars/dashboard_screen.dart';
import 'package:fitmaxx/pages/home_page.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user is logged in
          if (snapshot.hasData) {
            return DashboardScreen();
          }
          // user is NOT logged in
          else{
            return const LoginOrRegister();
          }
        }
      )
    );
  }
}