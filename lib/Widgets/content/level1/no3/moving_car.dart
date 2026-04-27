// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';

class MovingCarWidget extends StatelessWidget {
  final List<int> placedCubes;
  final List<Color> lightColors;
  final Function(int) onAccept;

  const MovingCarWidget({
    super.key,
    required this.placedCubes,
    required this.lightColors,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF37474F),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [const BoxShadow(color: Colors.black45, blurRadius: 10, offset: Offset(5, 5))],
          ),
          child: Column(
            children: List.generate(3, (index) {
              bool isPlaced = placedCubes.contains(index);
              return DragTarget<int>(
                onWillAccept: (data) => data == index,
                onAccept: onAccept,
                builder: (context, candidate, rejected) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isPlaced ? lightColors[index] : Colors.black26,
                      boxShadow: isPlaced ? [
                        BoxShadow(color: lightColors[index].withOpacity(0.8), blurRadius: 20, spreadRadius: 5),
                        const BoxShadow(color: Colors.white, blurRadius: 2, offset: Offset(-2, -2)),
                      ] : [],
                      border: Border.all(color: Colors.black54, width: 4),
                    ),
                  );
                },
              );
            }),
          ),
        ),
        Container(width: 15, height: 100, color: Colors.grey[700]),
      ],
    );
  }
}