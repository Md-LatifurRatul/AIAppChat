import 'package:flutter/material.dart';

class PromptElevatedButton extends StatelessWidget {
  const PromptElevatedButton({super.key, required this.label, this.onPressed});

  final String label;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(Icons.send),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        side: BorderSide(color: Colors.redAccent),
      ),
      label: Text(label),
      onPressed: onPressed,
    );
  }
}
