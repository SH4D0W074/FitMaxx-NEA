import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function() onPressed;
  const SettingsButton({super.key, required this.text, required this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Theme.of(context).colorScheme.secondary,
        child: ListTile(
          title: Text(text),
          trailing: Icon(icon),
          onTap: onPressed,
        ),
      ),
    );
  }
}