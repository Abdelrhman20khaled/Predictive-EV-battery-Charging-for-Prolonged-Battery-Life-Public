import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final double cardWidth;
  final double cardHeight;
  final String cardContent;
  final String name;
  final IconData? preIcon;
  final IconData? postIcon;

  const CustomCard({
    super.key,
    required this.cardWidth,
    required this.cardHeight,
    required this.cardContent,
    required this.name,
    this.preIcon,
    this.postIcon,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final textScale = MediaQuery.of(context).textScaleFactor;

    final titleFontSize = screenWidth * 0.042 * textScale.clamp(0.9, 1.1);
    final contentFontSize = screenWidth * 0.045 * textScale.clamp(0.9, 1.2);
    final iconSize = screenWidth * 0.05;

    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.5),
      color: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: cardWidth,
        height: cardHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: const Color(0xffFAFFFE),
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (preIcon != null) ...[
                    Icon(
                      preIcon,
                      color: const Color(0xFF01D5A2).withOpacity(0.4),
                      size: iconSize,
                    ),
                    const SizedBox(width: 6),
                  ],
                  Expanded(
                    child: Text(
                      cardContent,
                      style: TextStyle(
                        color: const Color(0xffFAFFFE),
                        fontSize: contentFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
