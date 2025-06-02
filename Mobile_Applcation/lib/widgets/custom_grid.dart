import 'package:flutter/material.dart';

class CustomGrid extends StatefulWidget {
  const CustomGrid({
    super.key,
    required this.gridName,
    required this.gridData,
    required this.numOfGrids,
  });

  final List<String> gridName;
  final List<String> gridData;
  final int numOfGrids;

  @override
  State<CustomGrid> createState() => _CustomGridState();
}

class _CustomGridState extends State<CustomGrid> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C1515),
      body: Column(
        children: [
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GridView.extent(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              maxCrossAxisExtent: 150,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              children: List.generate(widget.numOfGrids, (index) {
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF182624).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.gridName[index],
                        style: const TextStyle(
                          color: Colors.white,

                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.gridData[index],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
