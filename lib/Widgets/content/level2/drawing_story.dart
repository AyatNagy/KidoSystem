import 'dart:async';

import 'package:flutter/material.dart';

class DrawingStoryPage extends StatefulWidget {
  final List<dynamic> storyData;
  final VoidCallback? onComplete;

  const DrawingStoryPage({
    super.key,
    required this.storyData,
    this.onComplete,
  });

  @override
  State<DrawingStoryPage> createState() => _DrawingStoryPageState();
}

class _DrawingStoryPageState extends State<DrawingStoryPage> {
  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    if (widget.storyData.length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 4), (_) => _next());
    }
  }

  void _next() {
    if (!mounted) return;

    if (_index < widget.storyData.length - 1) {
      setState(() => _index++);
    } else {
      _timer?.cancel();
      widget.onComplete?.call();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentFrame = widget.storyData[_index];

    return Scaffold(
      backgroundColor: currentFrame.bgColor,
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 1000),
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
                  child: Image.asset(
                    currentFrame.imagePath,
                    key: ValueKey(_index),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}