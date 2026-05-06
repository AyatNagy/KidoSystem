import 'dart:async';
import 'package:flutter/material.dart';

import '../../../../data/level2/no33.dart';


class DrawingplusStoryPage extends StatefulWidget {
  const DrawingplusStoryPage({super.key});

  @override
  State<DrawingplusStoryPage> createState() => _DrawingplusStoryPageState();
}

class _DrawingplusStoryPageState extends State<DrawingplusStoryPage> {
  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) => _next());
  }

  void _next() {
    if (mounted) {
      if (_index < drawingPlus.length - 1) {
        setState(() => _index++);
      } else {
        _timer?.cancel();
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentFrame = drawingPlus[_index];

    return Scaffold(
      backgroundColor: currentFrame.bgColor,
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeInOut,
        color: currentFrame.bgColor,
        child: GestureDetector(
          onTap: () {
            _next();
            _startTimer();
          },
          child: Stack(
            children: [
              Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 800),
                  switchInCurve: Curves.easeInOutCubic,
                  switchOutCurve: Curves.easeInOutCubic,
                  child: Image.asset(
                    currentFrame.imagePath,
                    key: ValueKey(_index),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Positioned(
                top: 50,
                left: 20,
                child: IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    size: 32,
                    color: Colors.black54,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
