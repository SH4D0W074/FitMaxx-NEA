import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitmaxx/components/my_roundbutton.dart';
import 'package:fitmaxx/components/nutrient_row.dart';
import 'package:fitmaxx/models/consumed_food_model.dart';
import 'package:fitmaxx/models/macro_totals.dart';
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildSummarySection(context),
              
            ],
          ),
        ),
      ),
    );
  }

  _buildNutrientRow(String label, double value, Color color, IconData icon) {
    return NutrientRow(label: label, value: value, color: color, icon: icon);
  }

  Widget buildSummarySection(BuildContext context) {
  final userService = UserService();

  final cs = Theme.of(context).colorScheme;
  final textTheme = Theme.of(context).textTheme;

  return FutureBuilder<CustomUser?>(
    future: userService.getCurrentUser(),
    builder: (context, userSnap) {
      if (userSnap.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      if (userSnap.hasError) {
        return Center(child: Text("Error loading user: ${userSnap.error}"));
      }
      final user = userSnap.data;
      if (user == null) return const SizedBox.shrink();

      final userId = user.id; 
      final targetCalories = user.targetCalories ?? 2000;

      return StreamBuilder<MacroTotals>(
        stream: userService.watchTodayMacro(userId),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final totals = snap.data!;
          final consumed = totals.calories;
          final remaining = (targetCalories - consumed).clamp(0, targetCalories);
          final progress = (consumed / targetCalories).clamp(0.0, 1.0);

          return Card(
            color: cs.inversePrimary,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // LEFT: Calories ring
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: 130,
                              width: 130,
                              child: CircularProgressIndicator(
                                value: progress,
                                strokeWidth: 12,
                                backgroundColor: cs.surfaceContainerHighest,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.green.withValues(alpha: 0.9),
                                ),
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "$remaining",
                                  style: textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: cs.primary,
                                  ),
                                ),
                                Text(
                                  "Remaining",
                                  style: textTheme.bodySmall?.copyWith(
                                    color: cs.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Calories",
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "$consumed / $targetCalories",
                          style: textTheme.bodySmall?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 24),

                  // RIGHT: macros
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildNutrientRow("Carbs", totals.carbs, cs.secondary,Icons.rice_bowl),
                        const SizedBox(height: 10),
                        _buildNutrientRow("Fats", totals.fat, cs.secondary, Icons.water_drop),
                        const SizedBox(height: 10),
                        _buildNutrientRow("Protein", totals.protein, cs.secondary, Icons.egg),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
}