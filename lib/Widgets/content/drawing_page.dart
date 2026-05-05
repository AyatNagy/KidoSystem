// ignore_for_file: deprecated_member_use
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import 'package:kido/constants.dart';

class Drawing extends StatefulWidget {
  final String? instructionText;
  final List<Offset>? guidePoints;
  final VoidCallback? onFinish;
  final int pointsPerStep;
  final double validationThreshold;

  const Drawing({
    super.key,
    this.instructionText,
    this.guidePoints,
    this.onFinish,
    this.pointsPerStep = 1,
    this.validationThreshold = 40.0,
  });

  @override
  State<Drawing> createState() => _DrawingState();
}

class _DrawingState extends State<Drawing> {
  List<Offset?> points = [];
  Color selectedColor = Colors.blue;
  final AudioPlayer _player = AudioPlayer();
  bool _isSounding = false;

  final Set<int> _hitPoints = {};
  int _completedSteps = 0;

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

  void _handlePanUpdate(DragUpdateDetails details, List<Offset>? actualPoints, RenderBox box) {
    Offset touchPos = box.globalToLocal(details.globalPosition);
    Offset positionToDraw = touchPos;

    if (actualPoints != null) {
      for (int i = 0; i < actualPoints.length; i++) {
        double distance = (touchPos - actualPoints[i]).distance;
        if (distance < widget.validationThreshold) {
          positionToDraw = actualPoints[i];
          _hitPoints.add(i);
          break;
        }
        if (distance < widget.validationThreshold) {
          positionToDraw = actualPoints[i];
          _hitPoints.add(i);
          break;
        }
      }
    }

    setState(() {
      points.add(positionToDraw);
    });
  }

  void _checkCompletion() {
    if (widget.guidePoints == null) return;

    int currentlyFinishedSteps = _hitPoints.length ~/ widget.pointsPerStep;

    if (currentlyFinishedSteps > _completedSteps) {
      _completedSteps = currentlyFinishedSteps;
      widget.onFinish?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);
    final List<Offset>? scaledPoints = widget.guidePoints?.map((p) =>
        Offset(p.dx * config.localWidth, p.dy * config.localHeight)
    ).toList();

    return Stack(
      children: [
        GestureDetector(
          onPanStart: (_) => _toggleSound(true),
          onPanUpdate: (details) => _handlePanUpdate(
              details, scaledPoints, context.findRenderObject() as RenderBox
          ),
          onPanEnd: (_) {
            _toggleSound(false);
            _checkCompletion();
            setState(() => points.add(null));
          },
          child: CustomPaint(
            painter: SimplePainter(
              points,
              selectedColor,
              config.isTablet ? 18 : 14,
              scaledPoints,
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
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ...[Colors.red, Colors.green, Colors.blue].map((color) {
                    bool isSelected = selectedColor == color;
                    double btnSize = config.isTablet ? 55 : 40;
                    return GestureDetector(
                      onTap: () => setState(() => selectedColor = color),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: isSelected ? btnSize : btnSize * 0.75,
                        height: isSelected ? btnSize : btnSize * 0.75,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: isSelected
                              ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 12, spreadRadius: 4)]
                              : [],
                        ),
                      ),
                    );
                  }),
                  const VerticalDivider(indent: 15, endIndent: 15, color: Colors.black12),
                  IconButton(
                    icon: Icon(Icons.delete, color: AppColors.kidoRed, size: config.localHeight * 0.04),
                    onPressed: () {
                      setState(() {
                        points.clear();
                        _hitPoints.clear();
                        _completedSteps = 0;
                      });
                    },
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.bgColor,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: selectedColor.withOpacity(0.3), width: 2),
                ),
                child: Text(
                  widget.instructionText!,
                  style: TextStyle(fontSize: config.title, fontWeight: FontWeight.bold, color: AppColors.textDark),
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
      Paint guidePaint = Paint()
        ..color = Colors.black12
        ..style = PaintingStyle.fill;
      for (var dot in guidePoints!) {
        canvas.drawCircle(dot, width * 0.6, guidePaint);
      }
    }

    Paint paint = Paint()
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