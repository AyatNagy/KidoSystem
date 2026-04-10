import 'package:flutter/material.dart';

class StarsWidget extends StatelessWidget {
  final int stars; // 0 → 3
  const StarsWidget({super.key, required this.stars});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (i) {
          final earned = i < stars;
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: Icon(
              earned ? Icons.star_rounded : Icons.star_outline_rounded,
              key: ValueKey('$i-$earned'),
              size: 38,
              color: earned ? Colors.amber : Colors.grey.shade300,
            ),
          );
        }),
      ),
    );
  }
}
