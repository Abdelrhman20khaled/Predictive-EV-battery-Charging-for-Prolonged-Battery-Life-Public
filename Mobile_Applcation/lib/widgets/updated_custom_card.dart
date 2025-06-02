import 'package:flutter/material.dart';

class FilledPercentageCard extends StatelessWidget {
  final double cardWidth;
  final double cardHeight;
  final String title;
  final double percentage; 

  const FilledPercentageCard({
    super.key,
    required this.cardWidth,
    required this.cardHeight,
    required this.title,
    required this.percentage,
  });
  
  Color getBackgroundColor(double value) {
    if (value < 0.33) {
      return const Color(0xFF01D5A2).withOpacity(0.3);
    } else if (value < 0.66) {
      return const Color(0xFF01D5A2).withOpacity(0.6);
    } else {
      return const Color(0xFF01D5A2).withOpacity(0.7);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: cardWidth,
        height: cardHeight,
        decoration: BoxDecoration(
          color: getBackgroundColor(percentage),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xffFAFFFE),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
