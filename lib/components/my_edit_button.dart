import 'package:flutter/material.dart';

class MyEditButton extends StatelessWidget {
  final Function() onPressed;
  final Color? color;

  const MyEditButton({
    super.key,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.edit),
      color: color ?? Theme.of(context).colorScheme.secondary,
      tooltip: "Delete",
    );
  }
}
