import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../Models/level3/bubbleModel.dart';

class BubblePopGame extends StatefulWidget {
  const BubblePopGame({super.key});

  @override
  State<BubblePopGame> createState() => _BubblePopGameState();
}

class _BubblePopGameState extends State<BubblePopGame> {
  final List<BubbleModel> _bubbles = [];
  final Random _random = Random();
  late Timer _timer;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      _addNewBubble();
    });
  }

  void _addNewBubble() {
    setState(() {
      _bubbles.add(BubbleModel(
        id: DateTime.now().millisecondsSinceEpoch,
        xPosition: _random.nextDouble() * 0.8,
        color: Colors.primaries[_random.nextInt(Colors.primaries.length)].withOpacity(0.7),
        size: 80.0 + _random.nextDouble() * 40.0,
      ));
    });
  }

  void _popBubble(int id) {
    HapticFeedback.lightImpact();
    setState(() {
      _bubbles.removeWhere((b) => b.id == id);
      _score++;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB3E5FC),
      body: Stack(
        children: [
          ..._bubbles.map((bubble) => BubbleWidget(
            key: ValueKey(bubble.id),
            bubble: bubble,
            onPop: () => _popBubble(bubble.id),
          )),

          Positioned(
            top: 60,
            left: 20,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "🌟 $_score",
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          Positioned(
            top: 60,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.close_rounded, size: 40, color: Colors.redAccent),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}

class BubbleWidget extends StatefulWidget {
  final BubbleModel bubble;
  final VoidCallback onPop;

  const BubbleWidget({super.key, required this.bubble, required this.onPop});

  @override
  State<BubbleWidget> createState() => _BubbleWidgetState();
}

class _BubbleWidgetState extends State<BubbleWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _alignmentAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );

    _alignmentAnimation = Tween<double>(begin: 1.2, end: -1.2).animate(_controller);

    _controller.forward().then((_) {
      if (mounted) widget.onPop();
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
      animation: _alignmentAnimation,
      builder: (context, child) {
        return Align(
          alignment: Alignment(
            widget.bubble.xPosition * 2 - 1,
            _alignmentAnimation.value,
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
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
          ),
          child: const Center(
            child: Text(
              "أ",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}