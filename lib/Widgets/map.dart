import 'package:flutter/material.dart';
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

class _MapNodeState extends State<MapNode> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);
    final double screenWidth = config.localWidth;

    const double nodeSize = 90.0;
    const double vPadding = 45.0;
    const Color pathColor = Color(0xFFFFF4D1);
    const Color activeColor = Color(0xFF58CC02);
    const Color lockedColor = Color(0xFFD4B483);

    double calcX(int i) {
      double wave = math.sin(i * 0.8);
      return (screenWidth / 2) + (wave * (screenWidth / 4)) - (nodeSize / 2);
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
                child: GestureDetector(
                  onTapDown: (_) => setState(() => _isPressed = true),
                  onTapUp: (_) => setState(() => _isPressed = false),
                  onTapCancel: () => setState(() => _isPressed = false),
                  onTap: widget.lesson.isLocked ? null : widget.onTap,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    height: nodeSize,
                    width: nodeSize,
                    transform: Matrix4.translationValues(0, _isPressed ? 8 : 0, 0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.lesson.isLocked ? lockedColor : widget.buttonColor,
                      border: Border.all(
                        color: _isPressed ? Colors.yellowAccent : Colors.white.withOpacity(0.8),
                        width: 6,
                      ),
                      boxShadow: [
                        if (!_isPressed)
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            offset: const Offset(0, 10),
                            blurRadius: 0,
                          ),
                      ],
                    ),
                    child: Center(
                      child: widget.lesson.isLocked
                          ? const Icon(Icons.lock_outline, color: Colors.white70, size: 35)
                          : Image.asset(widget.lesson.image, width: 50),
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