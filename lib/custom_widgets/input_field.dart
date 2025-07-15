import 'package:flutter/material.dart';
import 'rapi_colors.dart';

class MobileInputField extends StatelessWidget {
  final TextEditingController controller;
  const MobileInputField({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.phone,
        maxLength: 10,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: "Type Mobile No",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: rapiDarkPurple, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: rapiDarkPurple, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: rapiDarkPurple, width: 2),
          ),
          counterText: "",
        ),
      ),
    );
  }
}