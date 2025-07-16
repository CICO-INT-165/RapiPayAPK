import 'package:flutter/material.dart';
import 'rapi_colors.dart';

class GetStartedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  const GetStartedButton({super.key, required this.onPressed, this.text = "Get Started"});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.send, color: Colors.white),
      label: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: rapiDarkPurple,
        minimumSize: const Size(220, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      onPressed: onPressed,
    );
  }
}