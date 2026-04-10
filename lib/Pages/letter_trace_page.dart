import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:kido/Models/letter_step.dart';
import 'package:kido/Pages/Painter/letter_path_painter.dart';
import 'package:kido/Pages/Painter/my_painter.dart';
import 'package:kido/Pages/Painter/steps_painter.dart';
import 'package:kido/Widgets/animated_hand_widget.dart';
import 'package:kido/Widgets/celebration_overlay.dart';
import 'package:kido/Widgets/stars_widget.dart';
import 'package:kido/tracing/letter_repository.dart';
import 'package:kido/utils/tracing_score.dart';

class LetterTracePage extends StatefulWidget {
  final String letter;
  const LetterTracePage({super.key, required this.letter});

  @override
  State<LetterTracePage> createState() => _LetterTracePageState();
}

class _LetterTracePageState extends State<LetterTracePage>
    with TickerProviderStateMixin {
  // ── رسم ──────────────────────────────────────────
  List<List<Offset>> pointsList = [];
  List<Color> colorsList = [];
  Color selectedColor = Colors.redAccent;

  // ── خطوات الحرف ──────────────────────────────────
  List<LetterStep> _steps = const [];
  int _currentStep = 0;

  // ── تقييم ─────────────────────────────────────────
  int _stars = 0;
  List<Offset> _pathSamplePoints = [];

  // ── يد متحركة ─────────────────────────────────────
  bool _showHand = true;

  bool _lockedAfterSuccess = false;

  // ── مسار الحرف (للتقييم) ──────────────────────────
  Path _letterPath = Path();

  Size? _lastCanvasSize;

  @override
  void initState() {
    super.initState();
  }

  void _ensureLetterDataForCanvas(Size canvasSize) {
    if (_lastCanvasSize == canvasSize && _steps.isNotEmpty) return;
    _lastCanvasSize = canvasSize;

    final data = LetterRepository.build(widget.letter, canvasSize: canvasSize);
    _steps = data.steps;
    _letterPath = data.path;
    _pathSamplePoints = _samplePath(_letterPath, steps: 80);
    _currentStep = 0;
    _stars = 0;
    _showHand = true;
    _lockedAfterSuccess = false;
    pointsList.clear();
    colorsList.clear();
  }

  List<Offset> _samplePath(Path path, {int steps = 80}) {
    final List<Offset> pts = [];
    for (final metric in path.computeMetrics()) {
      for (int i = 0; i <= steps; i++) {
        final t = metric.getTangentForOffset(i / steps * metric.length);
        if (t != null) pts.add(t.position);
      }
    }
    return pts;
  }

  // ── احتفال ─────────────────────────────────────────
  void _showCelebration() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder:
          (_) => CelebrationOverlay(
            stars: _stars,
            letter: widget.letter,
            onContinue: () {
              Navigator.of(context).pop();
              _resetAll();
              // هنا تقدر تروح للحرف الجاي
              // Navigator.pushReplacement(context, MaterialPageRoute(
              //   builder: (_) => LetterTracePage(letter: nextLetter),
              // ));
            },
          ),
    );
  }

  void _resetAll() {
    setState(() {
      pointsList.clear();
      colorsList.clear();
      _currentStep = 0;
      _stars = 0;
      _showHand = true;
      _lockedAfterSuccess = false;
    });
  }

  // ── UI ────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // خلفية
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFFF9E6), Color(0xFFFFECB3)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildKidoAppBar(),
                Expanded(
                  child: Row(
                    children: [
                      // لوحة الرسم
                      Expanded(
                        flex: 5,
                        child: Container(
                          margin: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.92),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 12),
                            ],
                          ),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final canvasSize = Size(
                                constraints.maxWidth,
                                constraints.maxHeight,
                              );
                              _ensureLetterDataForCanvas(canvasSize);

                              return ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Stack(
                                  children: [
                                    // الحرف كـ Stroke (نفس مسار التتبع) عشان يبقى مظبوط 100%
                                    CustomPaint(
                                      painter: LetterPathPainter(
                                        path: _letterPath,
                                        color: Colors.grey.withOpacity(0.12),
                                        strokeWidth: 30,
                                      ),
                                      size: Size.infinite,
                                    ),

                                    // عند النجاح: إظهار نسخة نظيفة من نفس المسار + قفل الرسم
                                    if (_lockedAfterSuccess)
                                      TweenAnimationBuilder<double>(
                                        tween: Tween(begin: 0.0, end: 1.0),
                                        duration:
                                            const Duration(milliseconds: 260),
                                        curve: Curves.easeOut,
                                        builder: (context, t, _) {
                                          return CustomPaint(
                                            painter: LetterPathPainter(
                                              path: _letterPath,
                                              color: Colors.green.withOpacity(
                                                0.22 + (0.10 * t),
                                              ),
                                              strokeWidth: 32,
                                            ),
                                            size: Size.infinite,
                                          );
                                        },
                                      ),

                              // الخطوات (أرقام + أسهم + خطوط متقطعة)
                              CustomPaint(
                                painter: StepsPainter(
                                  steps: _steps,
                                  currentStep: _currentStep,
                                ),
                                size: Size.infinite,
                              ),

                              // منطقة الرسم
                              GestureDetector(
                                onPanDown: (details) {
                                  if (_lockedAfterSuccess) return;
                                  if (_steps.isEmpty) return;
                                  if (_currentStep >= _steps.length) return;

                                  final start = _steps[_currentStep].startPoint;
                                  if ((details.localPosition - start).distance <
                                      50) {
                                    setState(() {
                                      _showHand = false;
                                      pointsList.add([details.localPosition]);
                                      colorsList.add(selectedColor);
                                    });
                                  }
                                },
                                onPanUpdate: (details) {
                                  if (_lockedAfterSuccess) return;
                                  if (pointsList.isEmpty) return;
                                  setState(() {
                                    pointsList.last.add(details.localPosition);

                                    // حساب النجوم لحظياً
                                    final coverage =
                                        TracingScore.calculateCoverage(
                                          pathPoints: _pathSamplePoints,
                                          drawn: pointsList,
                                        );
                                    _stars = TracingScore.calculateStars(
                                      coverage,
                                    );
                                  });
                                },
                                onPanEnd: (details) {
                                  setState(() {
                                    if (_currentStep < _steps.length - 1) {
                                      _currentStep++;
                                      _showHand = true;
                                      return;
                                    }

                                    // آخر خطوة: لو نجح (3 نجوم) اقفل الرسم واظهر الشكل النضيف
                                    if (_stars >= 3) {
                                      _lockedAfterSuccess = true;
                                      _showCelebration();
                                      return;
                                    }

                                    // لو لسه مش 3 نجوم: سيبه يحاول تاني بدون ما يقفل الرسم
                                    _showHand = true;
                                  });
                                },
                                child: CustomPaint(
                                  painter: MyPainter(pointsList, colorsList),
                                  size: Size.infinite,
                                ),
                              ),

                              // اليد المتحركة
                              AnimatedHandWidget(
                                steps: _steps,
                                currentStep: _currentStep,
                                visible: _showHand,
                              ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      // عمود الألوان
                      SizedBox(width: 76, child: _buildSideColors()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── AppBar ─────────────────────────────────────────
  Widget _buildKidoAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            child: CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: const Icon(Icons.arrow_back_ios_new, color: Colors.blue),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
              ),
              child: const FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Icon(Icons.rocket_launch, color: Colors.orange),
                    SizedBox(width: 10),
                    Text(
                      'KIDO TRACE',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          StarsWidget(stars: _stars),
        ],
      ),
    );
  }

  // ── ألوان جانبية ───────────────────────────────────
  Widget _buildSideColors() {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _colorCircle(Colors.redAccent),
          _colorCircle(Colors.orange),
          _colorCircle(Colors.green),
          _colorCircle(Colors.blue),
          _colorCircle(Colors.purple),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _resetAll,
            child: Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
              ),
              child: const Icon(
                Icons.delete_outline,
                color: Colors.red,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _colorCircle(Color color) {
    final isSelected = selectedColor == color;
    return GestureDetector(
      onTap: () => setState(() => selectedColor = color),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.all(8),
        width: isSelected ? 54 : 46,
        height: isSelected ? 54 : 46,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white70,
            width: isSelected ? 4 : 2,
          ),
          boxShadow:
              isSelected
                  ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 10)]
                  : [],
        ),
      ),
    );
  }
}
