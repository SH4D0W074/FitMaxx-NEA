import 'package:flutter/material.dart';

class MyDeleteButton extends StatelessWidget {
  final Function() onPressed;
  final Color? color;

  const MyDeleteButton({
    super.key,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.delete),
      color: color ?? Theme.of(context).colorScheme.secondary,
      tooltip: "Delete",
    );
  }
}
