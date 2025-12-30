import 'package:fitmaxx/auth/login_or_register.dart';
import 'package:fitmaxx/pages/login_page.dart';
import 'package:fitmaxx/pages/register_page.dart';
import 'package:fitmaxx/theme/dark_mode.dart';
import 'package:fitmaxx/theme/light_mode.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginOrRegister(),
      theme: lightMode,
      darkTheme: darkMode,
      
    );
  }
}



