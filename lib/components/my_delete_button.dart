import 'package:flutter/material.dart';

class MyDeleteButton extends StatelessWidget {
  final Function() onPressed;

  const MyDeleteButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.delete),
      color: Theme.of(context).colorScheme.secondary,
      tooltip: "Delete",
    );
  }
}
