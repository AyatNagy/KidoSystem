// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../../Models/level3/bubble_model.dart';

class BubbleWidget extends StatefulWidget {
  final BubbleModel bubble;
  final VoidCallback onPop;
  final VoidCallback onExpired;
  final String letter;

  const BubbleWidget({
    super.key,
    required this.bubble,
    required this.onPop,
    required this.onExpired,
    required this.letter,
  });

  @override
  State<BubbleWidget> createState() => _BubbleWidgetState();
}

class _BubbleWidgetState extends State<BubbleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _movement;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );
    _movement = Tween<double>(begin: 1.3, end: -1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
    _controller.forward().then((_) {
      if (mounted) widget.onExpired();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _movement,
      builder: (context, child) {
        return Align(
          alignment: Alignment(
            widget.bubble.xPosition * 2 - 1,
            _movement.value,
          ),
          child: child,
        );
      },
      child: GestureDetector(
        onTap: widget.onPop,
        child: Container(
          width: widget.bubble.size,
          height: widget.bubble.size,
          decoration: BoxDecoration(
            color: widget.bubble.color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.8), width: 4),
            boxShadow: [
              BoxShadow(
                color: widget.bubble.color.withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Text(
              widget.letter,
              style: TextStyle(
                fontSize: widget.bubble.size * 0.45,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(color: Colors.black.withOpacity(0.1), blurRadius: 5),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
