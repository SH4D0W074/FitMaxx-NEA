import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitmaxx/components/my_roundbutton.dart';
import 'package:fitmaxx/components/my_textfield.dart';
import 'package:fitmaxx/components/settings_button.dart';
import 'package:fitmaxx/models/user_model.dart';
import 'package:fitmaxx/services/auth_service.dart';
import 'package:fitmaxx/services/user_service.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {


  const SettingsPage({super.key });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  final usernameController = TextEditingController();
  final heightController = TextEditingController();
  final ageController = TextEditingController();
  final weightController = TextEditingController();
  final targetCaloriesController = TextEditingController();

  void logout() {
    FirebaseAuth.instance.signOut();
  }

  Future<CustomUser?> getCurrentUser() {
    final UserService userService = UserService();
    final user = userService.getCurrentUser();
    return user;
  }

  void editProfileDialog(CustomUser? currentUser) {
    if (currentUser != null) {
      usernameController.text = currentUser.username;
      heightController.text = currentUser.height.toString();
      ageController.text = currentUser.age.toString();
      weightController.text = currentUser.weight.toString();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit profile"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MyTextfield(
                hintText: "Username",
                obscureText: false,
                controller: usernameController,
              ),
              const SizedBox(height: 8),

              MyTextfield(
                hintText: "Height (cm)",
                obscureText: false,
                controller: heightController,
              ),
              const SizedBox(height: 8),

              MyTextfield(
                hintText: "Age",
                obscureText: false,
                controller: ageController,
              ),
              const SizedBox(height: 8),

              MyTextfield(
                hintText: "Weight (kg)",
                obscureText: false,
                controller: weightController,
              ),
            ],
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              clearProfileControllers();
            },
            child: const Text("Cancel"),
          ),
          MaterialButton(
            onPressed: updateProfile,
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void editGoalsDialog(CustomUser? currentUser) {
    if (currentUser != null) {
      targetCaloriesController.text = currentUser.targetCalories.toString();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit goals"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MyTextfield(
                hintText: "Calories",
                obscureText: false,
                controller: targetCaloriesController,
              ),
            ],
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              clearProfileControllers();
            },
            child: const Text("Cancel"),
          ),
          MaterialButton(
            onPressed: () {
              final calories = int.tryParse(targetCaloriesController.text.trim());
              if (calories != null) {
                updateCalories(calories);
              }
              Navigator.pop(context);
              clearProfileControllers();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void updateProfile() async {
    final userService = UserService();
    final CustomUser? user = await userService.getCurrentUser();
    if (user == null) return;

    final newUsername = usernameController.text.trim();
    final newHeight = int.tryParse(heightController.text.trim());
    final newAge = int.tryParse(ageController.text.trim());
    final newWeight = double.tryParse(weightController.text.trim());

    await userService.updateUserProfile(
      userId: user.id,
      username: newUsername,
      height: newHeight,
      age: newAge,
      weight: newWeight,
    );

    Navigator.pop(context);
    clearProfileControllers();
  }

  void updateCalories(int targetCalories) async {
    final userService = UserService();
    final CustomUser? user = await userService.getCurrentUser();
    if (user == null) return;
    userService.updateTargetCalories(user.id, targetCalories);
  }

  void goToEditGoalsPage() {}

  void deleteAccount(){
    final AuthService authService = AuthService();
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text("Are you sure you want to delete your account?"),

        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("NO"),
          ),
          MaterialButton(
            onPressed: () => authService.deleteAccount(),
            child: const Text("YES"),
          ),
        ],
      )
    );
    
  }

  void clearProfileControllers() {
    usernameController.clear();
    heightController.clear();
    ageController.clear();
    weightController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(
        'S E T T I N G S',
        style: TextStyle(
          color: Theme.of(context).textTheme.titleMedium?.color,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SettingsButton(text: "Edit Profile", onPressed: () async => editProfileDialog(await getCurrentUser()), icon: Icons.arrow_forward_ios,),
            SettingsButton(text: "Edit Goals", onPressed: () async => editGoalsDialog(await getCurrentUser()), icon: Icons.arrow_forward_ios,),
            SettingsButton(text: "Delete Account", onPressed: deleteAccount, icon: Icons.delete,),
            SettingsButton(text: "Logout", onPressed: logout, icon: Icons.logout,),
          ],
        ),
      ),
    );
  }
}