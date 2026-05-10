// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import 'package:kido/constants.dart';
import 'package:kido/services/audio_service.dart';
import '../drawing_page.dart';

class DrawingShapes extends StatefulWidget {
  final String? instructionText;
  final List<Offset>? guidePoints;
  final VoidCallback? onFinish;
  final int pointsPerStep;
  final double validationThreshold;

  const DrawingShapes({
    super.key,
    this.instructionText,
    this.guidePoints,
    this.onFinish,
    this.pointsPerStep = 1,
    this.validationThreshold = 40.0,
  });

  @override
  State<DrawingShapes> createState() => _DrawingState();
}

class _DrawingState extends State<DrawingShapes> {
  List<Offset?> points = [];
  Color selectedColor = Colors.blue;
  bool _isSounding = false;
  final Set<int> _hitPoints = {};
  int _completedSteps = 0;

  @override
  void dispose() {
    _toggleSound(false);
    super.dispose();
  }

  void _toggleSound(bool play) {
    if (play && !_isSounding) {
      AudioService.play(fileName: 'audio/scratch.mp3');
      _isSounding = true;
    } else if (!play && _isSounding) {
      AudioService.stop();
      _isSounding = false;
    }
  }

  void _handlePanUpdate(
    DragUpdateDetails details,
    List<Offset>? actualPoints,
    RenderBox box,
  ) {
    if (_completedSteps >= (widget.guidePoints?.length ?? 0)) {
      _toggleSound(false);
      return;
    }

    Offset touchPos = box.globalToLocal(details.globalPosition);
    Offset positionToDraw = touchPos;

    if (actualPoints != null) {
      int nextPointIndex = _hitPoints.length;
      if (nextPointIndex < actualPoints.length) {
        double distance = (touchPos - actualPoints[nextPointIndex]).distance;
        if (distance < widget.validationThreshold) {
          positionToDraw = actualPoints[nextPointIndex];
          _hitPoints.add(nextPointIndex);
          _checkCompletion();
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
      if (_completedSteps >= widget.guidePoints!.length) {
        _toggleSound(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);
    final List<Offset>? scaledPoints =
        widget.guidePoints
            ?.map(
              (p) =>
                  Offset(p.dx * config.localWidth, p.dy * config.localHeight),
            )
            .toList();

    return Stack(
      children: [
        GestureDetector(
          onPanStart: (_) => _toggleSound(true),
          onPanUpdate:
              (details) => _handlePanUpdate(
                details,
                scaledPoints,
                context.findRenderObject() as RenderBox,
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
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 10),
              ],
            ),
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
                    color: AppColors.kidoRed,
                    size: config.localHeight * 0.04,
                  ),
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
      ],
    );
  }
}
