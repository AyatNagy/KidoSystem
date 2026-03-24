import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For HapticFeedback
import 'dart:math' as math;
import '../Models/mapModel.dart';
import 'ResponsiveProvider.dart';

class MapNode extends StatefulWidget {
  final int index;
  final int totalItems;
  final Lesson lesson;
  final VoidCallback onTap;
  final Color buttonColor;

  const MapNode({
    super.key,
    required this.index,
    required this.totalItems,
    required this.lesson,
    required this.onTap,
    required this.buttonColor,
  });

  @override
  State<MapNode> createState() => _MapNodeState();
}

class _MapNodeState extends State<MapNode> with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);
    final double screenWidth = config.localWidth;

    const double nodeSize = 100.0;
    const double vPadding = 50.0;

    const Color pathColor = Color(0xFFFFF4D1);
    const Color lockedColor = Color(0xFFD4B483);

    double calcX(int i) {
      double wave = math.sin(i * 0.7);
      return (screenWidth / 2) + (wave * (screenWidth / 5)) - (nodeSize / 2);
    }

    double xOffset = calcX(widget.index);
    double nextX = calcX(widget.index + 1);

    return SizedBox(
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (widget.index < widget.totalItems - 1)
            Positioned(
              top: vPadding + (nodeSize / 2),
              left: 0,
              right: 0,
              child: CustomPaint(
                painter: _CurvePainter(
                  startX: xOffset + (nodeSize / 2),
                  endX: nextX + (nodeSize / 2),
                  height: nodeSize + (vPadding * 2),
                  color: pathColor,
                ),
              ),
            ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: vPadding),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: xOffset),
                child: ScaleTransition(
                  scale: widget.lesson.isLocked
                      ? const AlwaysStoppedAnimation(1.0)
                      : Tween(begin: 1.0, end: 1.05).animate(_pulseController),
                  child: GestureDetector(
                    onTapDown: (_) {
                      HapticFeedback.mediumImpact();
                      setState(() => _isPressed = true);
                    },
                    onTapUp: (_) => setState(() => _isPressed = false),
                    onTapCancel: () => setState(() => _isPressed = false),
                    onTap: widget.lesson.isLocked ? null : widget.onTap,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      height: nodeSize,
                      width: nodeSize,
                      transform: Matrix4.translationValues(0, _isPressed ? 6 : 0, 0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.lesson.isLocked ? lockedColor : widget.buttonColor,
                        border: Border.all(
                          color: _isPressed ? Colors.white : Colors.black.withOpacity(0.2),
                          width: 8,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: widget.lesson.isLocked
                                ? Colors.grey.shade600
                                : widget.buttonColor.withAlpha(150),
                            offset: Offset(0, _isPressed ? 2 : 12),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: Center(
                        child: widget.lesson.isLocked
                            ? const Icon(Icons.lock, color: Colors.white, size: 45)
                            : Image.asset(widget.lesson.image, width: 60),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CurvePainter extends CustomPainter {
  final double startX, endX, height;
  final Color color;

  _CurvePainter({required this.startX, required this.endX, required this.height, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 50
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(startX, 0);
    path.cubicTo(startX, height * 0.4, endX, height * 0.6, endX, height);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}