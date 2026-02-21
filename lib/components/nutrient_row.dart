import 'package:flutter/material.dart';

class NutrientRow extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final IconData icon;

  const NutrientRow({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            
            Icon(
              icon,
              size: 20,
              color: color,
            ),

            SizedBox(width: 10),

            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        Text(
          "${value.toInt()} g",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    );
  }
}

 