import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitmaxx/components/my_roundbutton.dart';
import 'package:fitmaxx/components/nutrient_row.dart';
import 'package:fitmaxx/models/consumed_food_model.dart';
import 'package:fitmaxx/models/macro_totals.dart';
import 'package:fitmaxx/models/user_model.dart';
import 'package:fitmaxx/services/user_service.dart';
import 'package:fitmaxx/theme/dark_mode.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fitmaxx/components/line_chart.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? selectedPeriod = "Weekly"; // Default selection

  final Map<String, List<FlSpot>> weightData = {
    // Shows daily stats over a week
    'Weekly': const [FlSpot(1, 100), FlSpot(2, 120), FlSpot(3, 115), FlSpot(4, 130), FlSpot(5, 140), FlSpot(6, 135), FlSpot(7, 150)],
    // Shows weekly stats over a month
    'Monthly': const [FlSpot(1, 400), FlSpot(2, 450), FlSpot(3, 420), FlSpot(4, 500)],
    // Shows monthly stats over a year
    'Yearly': const [FlSpot(1, 1600), FlSpot(2, 1800), FlSpot(3, 1750), FlSpot(4, 2000), FlSpot(5, 2100), FlSpot(6, 2200)],
  };

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
          color: Theme.of(context).textTheme.titleMedium?.color,
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
              
              const SizedBox(height: 20),

              const SizedBox(height: 10),
              Text(
                "Weight Progress",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              _buildTimeButtons(),
              const SizedBox(height: 10),
              _buildWeightChart()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNutrientRow(String label, double value, Color color, IconData icon) {
    return NutrientRow(label: label, value: value, color: color, icon: icon);
  }

  Widget buildSummarySection(BuildContext context) {
    final userService = UserService();

    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return FutureBuilder<CustomUser?>(
      future: userService.getCurrentUser(),
      builder: (context, snapshot) {
        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   return const Center(child: CircularProgressIndicator());
        // }
        if (snapshot.hasError) {
          return Center(child: Text("Error loading user: ${snapshot.error}"));
        }
        final user = snapshot.data;
        if (user == null) return const SizedBox.shrink();

        final userId = user.id; 
        final targetCalories = user.targetCalories;

        return StreamBuilder<MacroTotals>(
          stream: userService.watchTodayMacro(userId),
          builder: (context, snap) {
            if (!snap.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final totals = snap.data!;
            final int consumed = totals.calories;
            final int remaining = (targetCalories - consumed).clamp(0, targetCalories);
            final double progress = (consumed / targetCalories).clamp(0.0, 1.0);

            return Card(
              color: cs.secondary,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Calories ring
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
                                      color: cs.onSurfaceVariant,
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

                    // macros on right side
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildNutrientRow("Carbs", totals.carbs, cs.inversePrimary,Icons.rice_bowl),
                          const SizedBox(height: 10),
                          _buildNutrientRow("Fats", totals.fat, cs.inversePrimary, Icons.water_drop),
                          const SizedBox(height: 10),
                          _buildNutrientRow("Protein", totals.protein, cs.inversePrimary, Icons.egg),
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

  Widget _buildTimeButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: ['Weekly', 'Monthly', 'Yearly'].map((period) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: ChoiceChip(
            label: Text(period),
            selected: selectedPeriod == period,
            onSelected: (bool selected) {
              setState(() {
                // Update the state when a button is pressed
                selectedPeriod = period; 
              });
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildWeightChart() {
    return Expanded(
      child: MyLineChart(
        dataPoints: weightData[selectedPeriod] ?? [], // Pass the selected data to the chart
        lineColor: Colors.blue, 
      ),
    );
  }
}
