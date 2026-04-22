// ignore_for_file: deprecated_member_use

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:kido/Widgets/responsive_provider.dart';

class Drawing extends StatefulWidget {
  final String? instructionText;
  final List<Offset>? guidePoints;

  const Drawing({super.key, this.instructionText, this.guidePoints});

  @override
  State<Drawing> createState() => _DrawingState();
}

class _DrawingState extends State<Drawing> {
  List<Offset?> points = [];
  Color selectedColor = Colors.blue;
  final AudioPlayer _player = AudioPlayer();
  bool _isSounding = false;

  @override
  void initState() {
    super.initState();
    _player.setReleaseMode(ReleaseMode.loop);
    _player.setSource(AssetSource('audio/scratch.mp3'));
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _toggleSound(bool play) {
    if (play && !_isSounding) {
      _player.resume();
      _isSounding = true;
    } else if (!play && _isSounding) {
      _player.pause();
      _isSounding = false;
    }
  }

  void _handlePanUpdate(
    DragUpdateDetails details,
    List<Offset>? actualGuidePoints,
    RenderBox renderBox,
  ) {
    Offset touchPosition = renderBox.globalToLocal(details.globalPosition);
    Offset positionToDraw = touchPosition;

    if (actualGuidePoints != null) {
      for (var guidePoint in actualGuidePoints) {
        double distance = (touchPosition - guidePoint).distance;
        if (distance < 35) {
          positionToDraw = guidePoint;
          break;
        }
      }
    }

    setState(() {
      points.add(positionToDraw);
    });
  }

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);

    List<Offset>? actualGuidePoints;
    if (widget.guidePoints != null) {
      actualGuidePoints =
          widget.guidePoints!.map((p) {
            return Offset(p.dx * config.localWidth, p.dy * config.localHeight);
          }).toList();
    }

    return Stack(
      children: [
        GestureDetector(
          onPanStart: (_) => _toggleSound(true),
          onPanUpdate: (details) {
            RenderBox renderBox = context.findRenderObject() as RenderBox;
            _handlePanUpdate(details, actualGuidePoints, renderBox);
          },
          onPanEnd: (_) {
            _toggleSound(false);
            setState(() => points.add(null));
          },
          child: CustomPaint(
            painter: SimplePainter(
              points,
              selectedColor,
              config.isTablet ? 18 : 14,
              actualGuidePoints,
            ),
            size: Size.infinite,
          ),
        ),
        Positioned(
          top: config.localHeight * 0.15,
          left: config.localWidth * 0.1,
          right: config.localWidth * 0.1,
          child: Container(
            height: config.localHeight * 0.09,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(40),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 10),
              ],
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ...[Colors.red, Colors.green, Colors.blue].map((color) {
                    bool isSelected = selectedColor == color;
                    double btnSize = config.isTablet ? 55 : 40;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: GestureDetector(
                        onTap: () => setState(() => selectedColor = color),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: isSelected ? btnSize : btnSize * 0.75,
                          height: isSelected ? btnSize : btnSize * 0.75,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow:
                                isSelected
                                    ? [
                                      BoxShadow(
                                        color: color.withOpacity(0.5),
                                        blurRadius: 12,
                                        spreadRadius: 4,
                                      ),
                                    ]
                                    : [],
                          ),
                        ),
                      ),
                    );
                  }),
                  const VerticalDivider(
                    indent: 15,
                    endIndent: 15,
                    color: Colors.black12,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: config.localHeight * 0.04,
                    ),
                    onPressed: () => setState(() => points.clear()),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (widget.instructionText != null)
          Positioned(
            top: config.localHeight * 0.05,
            left: config.localWidth * 0.1,
            right: config.localWidth * 0.1,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: selectedColor.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Text(
                  widget.instructionText!,
                  style: TextStyle(
                    fontSize: config.title,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class SimplePainter extends CustomPainter {
  final List<Offset?> points;
  final Color color;
  final double width;
  final List<Offset>? guidePoints;

  SimplePainter(this.points, this.color, this.width, this.guidePoints);

  @override
  void paint(Canvas canvas, Size size) {
    if (guidePoints != null) {
      Paint guidePaint =
          Paint()
            ..color = Colors.black12
            ..style = PaintingStyle.fill;

      for (var dot in guidePoints!) {
        canvas.drawCircle(dot, width * 0.6, guidePaint);
      }
    }

    Paint paint =
        Paint()
          ..color = color
          ..strokeCap = StrokeCap.round
          ..strokeWidth = width;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
