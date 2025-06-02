import 'package:flutter/material.dart';

class TitledCard extends StatelessWidget {
  final double cardWidth;
  final double cardHeight;
  final String name;
  final IconData? preIcon;
  final IconData? postIcon;
  final VoidCallback? onPostIconPressed;

  const TitledCard({
    super.key,
    required this.cardWidth,
    required this.cardHeight,
    required this.name,
    this.preIcon,
    this.postIcon,
    this.onPostIconPressed,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final textScale = MediaQuery.of(context).textScaleFactor;
    final titleFontSize = screenWidth * 0.045 * textScale.clamp(0.9, 1.1);
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
          child: Row(
            children: [
              if (preIcon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(
                    preIcon,
                    color: const Color(0xFF01D5A2).withOpacity(0.4),
                    size: iconSize,
                  ),
                ),
              Expanded(
                child: Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: const Color(0xffFAFFFE),
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (postIcon != null)
                Container(
                  width: screenWidth * 0.1,
                  height: screenWidth * 0.1,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF01D5A2).withOpacity(0.2),
                        blurRadius: 6,
                        offset: Offset(3, 3),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(
                      postIcon,
                      color: const Color(0xFF01D5A2).withOpacity(0.6),
                      size: screenWidth * 0.075,
                    ),
                    tooltip: 'tips',
                    onPressed: onPostIconPressed,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
