import 'package:flutter/material.dart';

class CustomIndicator extends StatelessWidget {
  final bool active;
  final Color color;

  const CustomIndicator({super.key, required this.active, required this.color});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: active ? 16 : 12,
      width: active ? 16 : 12,
      decoration: BoxDecoration(
        color: active ? color : Colors.grey.shade400,
        shape: BoxShape.circle,
      ),
    );
  }
}
