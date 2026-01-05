import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitmaxx/components/my_button.dart';
import 'package:fitmaxx/components/my_textfield.dart';
import 'package:fitmaxx/helper/helper_functions.dart';
import 'package:fitmaxx/services/auth_service.dart';
import 'package:flutter/material.dart';


class RegisterPage extends StatefulWidget {
  
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _authService = AuthService();

  // text controllers
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPwController = TextEditingController();

  // register method
  void registerUser() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          ),
        ),
      );
    // make sure passwords match
    if (passwordController.text != confirmPwController.text) {
      // pop loading circle
      Navigator.pop(context);

      // show error message to user
      displayMessageToUser("Passwords do not match.", context);
    } 

    // if passwords do match
    else{
      // try creating the user
      try {
        // create the user
        UserCredential? userCredential = 
          await _authService.registerWithEmailPassword(
            email: emailController.text,
            password: passwordController.text,
          );

        // create a user document and add to firestore
        createUserDocument(userCredential);
        
        // pop loading cirlce
        if (mounted) Navigator.of(context, rootNavigator: true).pop();
      } 
      
      // display error message to user
      catch (e) {
        // pop loading circle
        Navigator.of(context, rootNavigator: true).pop();
        displayMessageToUser(e.toString(), context);
      }
    }
  }
  // create a user document and collect them in firestore
    Future<void> createUserDocument(UserCredential? userCredential) async{
      if (userCredential!= null && userCredential.user != null) {
        await FirebaseFirestore.instance
        .collection("Users")
        .doc(userCredential.user!.uid)
        .set({
          'uid': userCredential.user!.uid,
          'email': userCredential.user!.email,
          'username': usernameController.text,
        });
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // logo
            Icon(
              Icons.person,
              size: 80,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          
            const SizedBox(height: 25),
          
            // app name
            const Text(
              "F I T M A X X",
              style: TextStyle(fontSize: 20),
          
            ),
          
            const SizedBox(height: 50),
            
            // username textfield
            MyTextfield(
              hintText: 'Username', 
              obscureText: false, 
              controller: usernameController,
            ),

            SizedBox(height: 10),

            // email textfield
            MyTextfield(
              hintText: 'Email', 
              obscureText: false, 
              controller: emailController,
            ),

            SizedBox(height: 10),
          
            // password textfield
            MyTextfield(
              hintText: 'Password', 
              obscureText: true, 
              controller: passwordController,
            ),

            SizedBox(height: 10),

            // Confirm password textfield
            MyTextfield(
              hintText: 'Confirm Password', 
              obscureText: true, 
              controller: confirmPwController,
            ),

            SizedBox(height: 10),

            // forgot password
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Forgot Password?',
                  style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary)
                ),
              ],
            ),

            SizedBox(height: 25),

            // Register button
            MyButton(
              text: 'Register', 
              onTap: registerUser,
            ),

            SizedBox(height: 10,),
            // already have account? login here
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account?",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  )
                ),
                
                GestureDetector(
                  onTap: widget.onTap,
                  child: const Text(
                    " Login here",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            ],
          ),
        )
      )
    );
  }
}