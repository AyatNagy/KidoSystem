import 'package:flutter/material.dart';
import 'package:kido/Widgets/responsive_provider.dart';

import '../../../../Widgets/content/drawing_page.dart';

class BallLesson extends StatefulWidget {
  const BallLesson({super.key});

  @override
  State<BallLesson> createState() => _BallLessonState();
}

class _BallLessonState extends State<BallLesson> {
  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFF),
      body: Stack(
        children: [
          Positioned(
            right: 0,
            top: config.localHeight * 0.65,
            child: TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(seconds: 1),
              onEnd: () => setState(() {}),
              builder: (context, double value, child) {
                return Transform.translate(
                  offset: Offset(0, 15 * (value - 0.5).abs()),
                  child: child,
                );
              },
              child: IgnorePointer(
                child: Image.asset(
                  'assets/images/ball.png',
                  width: config.localWidth * 0.4,
                  fit: BoxFit.contain,
                  alignment: Alignment.centerRight,
                ),
              ),
            ),
          ),

          Positioned(
            right: 0,
            top: config.localHeight * 0.45,
            child: IgnorePointer(
              child: Image.asset(
                'assets/images/char-move.png',
                width: config.localWidth * 1.5,
                fit: BoxFit.contain,
                alignment: Alignment.centerLeft,
              ),
            ),
          ),

          Drawing(
            guidePoints: const [
              Offset(0.35, 0.72),
              Offset(0.5, 0.72),
              Offset(0.65, 0.72),
            ],
          ),
        ],
      ),
    );
  }
}
