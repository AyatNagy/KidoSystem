import 'dart:async';
import 'package:flutter/material.dart';
import '../../Models/level2/drawStory.dart';
import '../../Widgets/ResponsiveProvider.dart';

class DrawingStoryPage extends StatefulWidget {
  const DrawingStoryPage({super.key});

  @override
  State<DrawingStoryPage> createState() => _DrawingStoryPageState();
}

class _DrawingStoryPageState extends State<DrawingStoryPage> {
  int _currentindex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _resetTimer();
  }

  void _resetTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      _nextFrame();
    });
  }

  void _nextFrame() {
    if (mounted) {
      if (_currentindex < drawingStory.length - 1) {
        setState(() => _currentindex++);
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
    return Scaffold(
      backgroundColor: const Color(0xFFE4E5DF),
      body: GestureDetector(
        onTap: _nextFrame,
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 1200),
                switchInCurve: Curves.easeInOutCubic,
                switchOutCurve: Curves.easeInOutCubic,
                layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      ...previousChildren,
                      if (currentChild != null) currentChild,
                    ],
                  );
                },
                child: Image.asset(
                  drawingStory[_currentindex].imagePath,
                  key: ValueKey<int>(_currentindex),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.2,
                    colors: [
                      Colors.transparent,
                      const Color(0xFFE4E5DF).withOpacity(0.4),
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 20),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.close_rounded, size: 28, color: Color(0xFF455A64)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}