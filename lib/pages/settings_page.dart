import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitmaxx/components/my_roundbutton.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  void logout() {
    FirebaseAuth.instance.signOut();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              child: RoundButton(
                title: "L O G O U T",
                type: RoundButtonType.primaryBG,
                onPressed: logout,
              ),
               
            ),
          ],
        ),
      ),
    );
  }
}