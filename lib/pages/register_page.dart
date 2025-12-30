import 'package:fitmaxx/components/my_button.dart';
import 'package:fitmaxx/components/my_textfield.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  
  final void Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  // text controllers
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPwController = TextEditingController();

  // register method
  void registerUser() {

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
                  onTap: onTap,
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