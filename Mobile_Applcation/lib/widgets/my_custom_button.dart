import 'package:flutter/material.dart';

class MyCustomButton extends StatelessWidget {
  const MyCustomButton({
    super.key,
    required this.text,
    this.onTap,
    this.isSelected = false, // New property to highlight selected button
  });

  final String text;
  final void Function()? onTap;
  final bool isSelected; // To indicate which tab is active

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? Colors.tealAccent.withOpacity(0.2)
                  : Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(25), // Pill shape
          border:
              isSelected
                  ? Border.all(
                    color: Colors.tealAccent,
                    width: 2,
                  ) // Highlight for active button
                  : null,
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color:
                isSelected
                    ? Colors.tealAccent
                    : Colors.white70, // Active button color
          ),
        ),
      ),
    );
  }
}
