import 'package:flutter/material.dart';

class ExerciseTile extends StatelessWidget {
  final String exerciseName;
  final String weight;
  final String reps;
  final String sets;
  final bool isCompleted;
  final void Function(bool?)? onCheckBoxChanged;
  final Widget? widget;

  const ExerciseTile({super.key, 
    required this.exerciseName,
    required this.weight,
    required this.reps,
    required this.sets,
    required this.isCompleted,
    required this.onCheckBoxChanged,
    required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Theme.of(context).colorScheme.secondary,
        child: ListTile(
          title: Text(
            exerciseName
            ),
            subtitle: Row(
              children: [
                // weight
                Chip(
                  label: Text(
                    "${weight}kg"
                  )
                ),
        
                // reps
                Chip(
                  label: Text(
                    "${reps.toString()} reps"
                  )
                ),
                
                // sets
                Chip(
                  label: Text(
                    "${sets.toString()} sets"
                  )
                ),
              ],
            ),
            trailing:Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                widget!,
                Checkbox(
                  value: isCompleted,
                  onChanged: (value) => onCheckBoxChanged!(value),
                ),
              ],
            ),
        )
      ),
    );
  }
}