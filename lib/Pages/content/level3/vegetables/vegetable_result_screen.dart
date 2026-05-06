// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'dart:math';

class VegetableResultScreen extends StatefulWidget {
  final int score;
  final int total;

  const VegetableResultScreen({
    super.key,
    required this.score,
    required this.total,
  });

  @override
  State<VegetableResultScreen> createState() => _VegetableResultScreenState();
}

class _VegetableResultScreenState extends State<VegetableResultScreen>
    with TickerProviderStateMixin {
  late AnimationController _scoreController;
  late AnimationController _bounceController;
  late Animation<double> _scoreAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();

    _scoreController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scoreAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _scoreController, curve: Curves.easeOut));
    _bounceAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );

    _scoreController.forward();
    _bounceController.forward();
  }

  @override
  void dispose() {
    _scoreController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  String get _emoji {
    final percent = widget.score / widget.total;
    if (percent == 1.0) return '🏆';
    if (percent >= 0.7) return '⭐';
    if (percent >= 0.5) return '👍';
    return '💪';
  }

  String get _message {
    final percent = widget.score / widget.total;
    if (percent == 1.0) return 'Perfect Score!';
    if (percent >= 0.7) return 'Great Job!';
    if (percent >= 0.5) return 'Good Effort!';
    return 'Keep Practicing!';
  }

  String get _messageAr {
    final percent = widget.score / widget.total;
    if (percent == 1.0) return 'ممتاز! أجبت على كل الأسئلة!';
    if (percent >= 0.7) return 'عمل رائع! استمر هكذا!';
    if (percent >= 0.5) return 'جيد! يمكنك التحسن أكثر!';
    return 'لا تستسلم! حاول مجدداً!';
  }

  Color get _primaryColor {
    final percent = widget.score / widget.total;
    if (percent == 1.0) return const Color(0xFFFFB300);
    if (percent >= 0.7) return const Color(0xFF3A7D44);
    if (percent >= 0.5) return const Color(0xFF1976D2);
    return const Color(0xFFE64A19);
  }

  @override
  Widget build(BuildContext context) {
    final percent = widget.score / widget.total;
    final color = _primaryColor;

    return Scaffold(
      backgroundColor: const Color(0xFFF6FBF4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6FBF4),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Result',
          style: TextStyle(
            color: Colors.black,
            fontFamily: "arlrdbd",
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Emoji + bounce animation
              ScaleTransition(
                scale: _bounceAnimation,
                child: Text(_emoji, style: const TextStyle(fontSize: 80)),
              ),

              const SizedBox(height: 16),

              // Message
              Text(
                _message,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontFamily: "arlrdbd",
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _messageAr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                  fontFamily: "arlrdbd",
                ),
              ),

              const SizedBox(height: 36),

              // Circular progress
              AnimatedBuilder(
                animation: _scoreAnimation,
                builder: (context, child) {
                  final animatedScore =
                      (widget.score * _scoreAnimation.value).round();
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 160,
                        height: 160,
                        child: CustomPaint(
                          painter: _CircleProgressPainter(
                            progress: percent * _scoreAnimation.value,
                            color: color,
                            backgroundColor: color.withOpacity(0.12),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$animatedScore',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: color,
                              fontFamily: "arlrdbd",
                            ),
                          ),
                          Text(
                            'out of ${widget.total}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black45,
                              fontFamily: "arlrdbd",
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 36),

              // Stars row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.total, (i) {
                  final filled = i < widget.score;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Icon(
                      filled ? Icons.star_rounded : Icons.star_outline_rounded,
                      color: filled ? const Color(0xFFFFB300) : Colors.black12,
                      size: 32,
                    ),
                  );
                }),
              ),

              const SizedBox(height: 48),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new, size: 16),
                      label: const Text(
                        'Back',
                        style: TextStyle(fontFamily: "arlrdbd", fontSize: 15),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black54,
                        side: const BorderSide(color: Colors.black26),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Pop back to the quiz start (pop twice)
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.refresh_rounded, size: 18),
                      label: const Text(
                        'Try Again',
                        style: TextStyle(fontFamily: "arlrdbd", fontSize: 15),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom painter for circular progress
class _CircleProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;

  _CircleProgressPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    const strokeWidth = 12.0;

    // Background circle
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = backgroundColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    // Progress arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_CircleProgressPainter old) =>
      old.progress != progress || old.color != color;
}
