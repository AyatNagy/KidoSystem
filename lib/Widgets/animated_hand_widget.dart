// ignore_for_file: deprecated_member_use
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:kido/Models/letter_step.dart';
import 'package:kido/constants.dart';

class AnimatedHandWidget extends StatefulWidget {
  final List<LetterStep> steps;
  final int currentStep;
  final bool visible;

  const AnimatedHandWidget({
    super.key,
    required this.steps,
    required this.currentStep,
    required this.visible,
  });

  @override
  State<AnimatedHandWidget> createState() => _AnimatedHandWidgetState();
}

class _AnimatedHandWidgetState extends State<AnimatedHandWidget>
    with TickerProviderStateMixin {
  late AnimationController _traceController;
  late Animation<double> _traceAnim;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();

    _traceController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _traceAnim = CurvedAnimation(
      parent: _traceController,
      curve: Curves.easeInOut,
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 0.8, end: 1.3).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(AnimatedHandWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentStep != widget.currentStep) {
      _traceController.reset();
      _traceController.repeat();
    }
  }

  ({Offset position, double angle}) _getHandState(double t) {
    final steps = widget.steps;
    if (steps.isEmpty || widget.currentStep >= steps.length) {
      return (position: const Offset(180, 100), angle: 0);
    }

    final step = steps[widget.currentStep];
    final pts = step.guidePoints;
    if (pts.length < 2) {
      return (position: step.startPoint, angle: 0);
    }

    final index = (t * (pts.length - 1)).clamp(0.0, pts.length - 1.001);
    final i = index.floor();
    final frac = index - i;

    final pos = Offset.lerp(pts[i], pts[i + 1], frac)!;
    final next = pts[(i + 1).clamp(0, pts.length - 1)];
    final angle = math.atan2(next.dy - pts[i].dy, next.dx - pts[i].dx);

    return (position: pos, angle: angle);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.visible || widget.steps.isEmpty) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: Listenable.merge([_traceAnim, _pulseAnim]),
      builder: (context, _) {
        final state = _getHandState(_traceAnim.value);
        final pos = state.position;
        final angle = state.angle;
        final isAtStart = _traceAnim.value < 0.12;

        return Stack(
          children: [
            if (isAtStart)
              Positioned(
                left:
                    widget.steps[widget.currentStep].startPoint.dx -
                    20 * _pulseAnim.value,
                top:
                    widget.steps[widget.currentStep].startPoint.dy -
                    20 * _pulseAnim.value,
                child: Container(
                  width: 40 * _pulseAnim.value,
                  height: 40 * _pulseAnim.value,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.redAccent.withOpacity(0.25),
                    border: Border.all(
                      color: Colors.redAccent.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                ),
              ),

            Positioned(
              left: pos.dx - 20,
              top: pos.dy - 10,
              child: Transform.rotate(
                angle: angle,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.bgColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.textDark,
                        blurRadius: 8,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Image.asset('assets/images/animated_hand-Photoroom.png')),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _traceController.dispose();
    _pulseController.dispose();
    super.dispose();
  }
}
