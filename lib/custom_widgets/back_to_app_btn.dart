import 'package:flutter/material.dart';
import 'rapi_colors.dart';

class BackToAppBtn extends StatelessWidget {
  final VoidCallback? onTap;
  const BackToAppBtn({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0, left: 16.0),
        child: GestureDetector(
          onTap: onTap ?? () => Navigator.of(context).maybePop(),
          child: Container(
            decoration: BoxDecoration(
              color: rapiDarkPurple,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.arrow_back, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  "Back to App",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}