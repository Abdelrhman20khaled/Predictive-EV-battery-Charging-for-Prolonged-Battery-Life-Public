import 'package:flutter/material.dart';

class TipList extends StatelessWidget {
  final List<String> tips;
  const TipList({Key? key, required this.tips}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      builder:
          (_, controller) => Container(
            // Opaque outer container for proper shadow rendering
            decoration: BoxDecoration(
              color: Colors.black, // solid color for shadow
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 8,
                  offset: Offset(0, -4),
                ),
              ],
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Container(
              // Inner container with desired background opacity
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              padding: EdgeInsets.all(16),
              child: ListView.builder(
                controller: controller,
                itemCount: tips.length,
                itemBuilder:
                    (_, index) => ListTile(
                      leading: Icon(
                        Icons.tips_and_updates_outlined,
                        color: const Color(0xFF01D5A2).withOpacity(0.4),
                      ),
                      title: Text(
                        tips[index],
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
              ),
            ),
          ),
    );
  }
}
