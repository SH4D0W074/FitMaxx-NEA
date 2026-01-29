import 'package:flutter/material.dart';
import 'package:fitmaxx/models/consumed_food_model.dart';
import 'package:fitmaxx/models/user_model.dart';
import 'package:fitmaxx/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MealdiaryPage extends StatefulWidget {
  
  const MealdiaryPage({super.key});

  @override
  State<MealdiaryPage> createState() => _MealdiaryPageState();
}

class _MealdiaryPageState extends State<MealdiaryPage> {

  bool _showForm = false;

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _calController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();
  final _weightController = TextEditingController();

  String _selectedMealType = 'Breakfast';

  int _refreshKey = 0;

@override
void dispose() {
  _nameController.dispose();
  _calController.dispose();
  _proteinController.dispose();
  _carbsController.dispose();
  _fatController.dispose();
  _weightController.dispose();
  super.dispose();
}

void _saveFood() async {
  if (!_formKey.currentState!.validate()) return;

  final userService = UserService();
  final CustomUser? user = await userService.getCurrentUser();

  if (user == null) return;

  // Create a new document reference in the subcollection
  final foodDocRef = FirebaseFirestore.instance
      .collection('Users')
      .doc(user.id)
      .collection('consumedFoodLog')
      .doc(); // auto-generated ID

  // Build ConsumedFood with the Firestore document ID
  final ConsumedFood newConsumedFood = ConsumedFood(
    id: foodDocRef.id,
    foodName: _nameController.text.trim(),
    calories: double.parse(_calController.text).round(), 
    protein: double.parse(_proteinController.text),
    carbs: double.parse(_carbsController.text),
    fat: double.parse(_fatController.text),
    foodWeight: double.parse(_weightController.text),
    mealType: _selectedMealType,
    timestamp: DateTime.now(),
  );

  // Save to Firestore subcollection
  await foodDocRef.set(newConsumedFood.toMap());

  // Update UI
  setState(() {
    _showForm = false;
    _refreshKey++; // forces FutureBuilder / StreamBuilder refresh
  });

  // Clear form fields
  _nameController.clear();
  _calController.clear();
  _proteinController.clear();
  _carbsController.clear();
  _fatController.clear();
  _weightController.clear();
  _selectedMealType = 'Breakfast';
}

Widget _buildFoodForm() {
  return Center(
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Food name"),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? "Enter a name" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _calController,
                decoration: const InputDecoration(labelText: "Calories"),
                keyboardType: TextInputType.number,
                validator: (v) {
                  final n = double.tryParse(v ?? "");
                  if (n == null) return "Enter a number";
                  if (n <= 0) return "Must be > 0";
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _proteinController,
                decoration: const InputDecoration(labelText: "Protein (g)"),
                keyboardType: TextInputType.number,
                validator: (v) {
                  final n = double.tryParse(v ?? "");
                  if (n == null) return "Enter a number";
                  if (n < 0) return "Must be ≥ 0";
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _carbsController,
                decoration: const InputDecoration(labelText: "Carbs (g)"),
                keyboardType: TextInputType.number,
                validator: (v) {
                  final n = double.tryParse(v ?? "");
                  if (n == null) return "Enter a number";
                  if (n < 0) return "Must be ≥ 0";
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _fatController,
                decoration: const InputDecoration(labelText: "Fat (g)"),
                keyboardType: TextInputType.number,
                validator: (v) {
                  final n = double.tryParse(v ?? "");
                  if (n == null) return "Enter a number";
                  if (n < 0) return "Must be ≥ 0";
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(labelText: "Weight (g)"),
                keyboardType: TextInputType.number,
                validator: (v) {
                  final n = double.tryParse(v ?? "");
                  if (n == null) return "Enter a number";
                  if (n <= 0) return "Must be > 0";
                  return null;
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                initialValue: _selectedMealType,
                decoration: const InputDecoration(labelText: "Meal Type"),
                items: ['Breakfast', 'Lunch', 'Dinner', 'Snacks'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedMealType = newValue!;
                  });
                },
                validator: (v) => v == null ? "Select a meal type" : null,
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() => _showForm = false);
                      },
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveFood,
                      child: const Text("Save"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
        'M E A L S',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        centerTitle: true,
      ),

      body: Stack(
        children: [
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState:
                _showForm ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            firstChild: _buildFoodForm(),
            secondChild: _buildFoodList(),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: IconButton(
                icon: Icon(_showForm ? Icons.close : Icons.add),
                onPressed: () {
                  setState(() {
                    _showForm = !_showForm;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodList() {
    return FutureBuilder<CustomUser?>(
      key: ValueKey(_refreshKey),
      future: UserService().getCurrentUser(),
      builder: (context, userSnap) {
        if (userSnap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (userSnap.hasError) {
          return Center(child: Text('Error: ${userSnap.error}'));
        }

        final user = userSnap.data;
        if (user == null) {
          return const Center(child: Text('User not found.'));
        }

        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: UserService().watchConsumedFoods(user.id), // assumes you added this
          builder: (context, foodSnap) {
            if (foodSnap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (foodSnap.hasError) {
              return Center(child: Text('Error: ${foodSnap.error}'));
            }

            final docs = foodSnap.data?.docs ?? [];
            final foods = docs.map((d) => ConsumedFood.fromDoc(d.id, d.data())).toList();

            if (foods.isEmpty) {
              return const Center(child: Text('No foods logged yet.'));
            }

            // Group foods by meal type
            final Map<String, List<ConsumedFood>> grouped = {};
            for (final food in foods) {
              grouped.putIfAbsent(food.mealType, () => []).add(food);
            }

            // Totals for progress bar
            final int consumedCalories = foods.fold<int>(0, (sum, f) => sum + f.calories);

            final int target = user.targetCalories;
            final double progress =
                target <= 0 ? 0 : (consumedCalories / target).clamp(0.0, 1.0);

            Icon getMealIcon(String mealType) {
              switch (mealType) {
                case 'Breakfast':
                  return Icon(Icons.free_breakfast, color: Theme.of(context).colorScheme.primary);
                case 'Lunch':
                  return Icon(Icons.restaurant, color: Theme.of(context).colorScheme.primary);
                case 'Dinner':
                  return Icon(Icons.dinner_dining, color: Theme.of(context).colorScheme.primary);
                case 'Snacks':
                  return Icon(Icons.cookie, color: Theme.of(context).colorScheme.primary);
                default:
                  return Icon(Icons.restaurant, color: Theme.of(context).colorScheme.primary);
              }
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    margin: const EdgeInsets.all(16),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            'Daily Calories Progress',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.inversePrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$consumedCalories / $target cal',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),

                  ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: ['Breakfast', 'Lunch', 'Dinner', 'Snacks'].map((mealType) {
                      final mealFoods = grouped[mealType] ?? [];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                            child: Row(
                              children: [
                                getMealIcon(mealType),
                                const SizedBox(width: 8),
                                Text(
                                  mealType,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                ),
                              ],
                            ),
                          ),

                          if (mealFoods.isEmpty)
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                'No foods logged for $mealType yet.',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                              ),
                            )
                          else
                            ...mealFoods.map((food) => Card(
                                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                  elevation: 2,
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.fastfood,
                                      color: Theme.of(context).colorScheme.secondary,
                                    ),
                                    title: Text(
                                      food.foodName,
                                      style: Theme.of(context).textTheme.titleMedium,
                                    ),
                                    subtitle: Text(
                                      '${food.calories} cal • ${food.protein}g P • ${food.carbs}g C • ${food.fat}g F',
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '${food.foodWeight}g',
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                              ),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            await UserService().deleteFood(user.id, food.id);
                                            setState(() => _refreshKey++);
                                          },
                                          icon: const Icon(Icons.delete),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

}