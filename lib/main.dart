import 'package:firebase_core/firebase_core.dart';
import 'package:fitmaxx/auth/auth_page.dart';
import 'package:fitmaxx/data/workout_data.dart';
import 'package:fitmaxx/firebase_options.dart';
import 'package:fitmaxx/theme/dark_mode.dart';
import 'package:fitmaxx/theme/light_mode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // add providers 
        ChangeNotifierProvider(create: (context) => WorkoutData()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const AuthPage(),
        theme: lightMode,
        darkTheme: darkMode,
        
      ),
    );
  }
}



