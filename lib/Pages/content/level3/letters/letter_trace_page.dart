// ignore_for_file: deprecated_member_use
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:kido/Models/level3/letter_step.dart';
import 'package:kido/Widgets/Animation/animated_hand_widget.dart';
import 'package:kido/Widgets/Dialogs/celebration_overlay.dart';
import 'package:kido/Widgets/stars_widget.dart';
import 'package:kido/data/level3/letters/letter_repository.dart';
import 'package:kido/utils/tracing_score.dart';
import '../../../../Widgets/Painter/letter_path_painter.dart';
import '../../../../Widgets/Painter/my_painter.dart';
import '../../../../Widgets/Painter/steps_painter.dart';
import '../../../../constants.dart';

class LetterTracePage extends StatefulWidget {
  final String letter;
  final VoidCallback? onComplete;
  const LetterTracePage({super.key, required this.letter, this.onComplete});

  @override
  State<LetterTracePage> createState() => _LetterTracePageState();
}

class _LetterTracePageState extends State<LetterTracePage>
    with TickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> _playSuccessSound() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('audio/yaay.mp3'));
    } catch (e) {
      debugPrint("Error playing sound: $e");
    }
  }

  List<List<Offset>> pointsList = [];
  List<Color> colorsList = [];
  Color selectedColor = Colors.redAccent;

  List<LetterStep> _steps = const [];
  int _currentStep = 0;

  int _stars = 0;
  List<Offset> _pathSamplePoints = [];

  bool _showHand = true;
  bool _lockedAfterSuccess = false;

  Path _letterPath = Path();
  Size? _lastCanvasSize;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
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

  void _showCelebration() {
    _playSuccessSound();
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder:
          (_) => CelebrationOverlay(
            stars: _stars,
            letter: widget.letter,
            onContinue: () {
              _audioPlayer.stop();
              Navigator.of(context).pop();
              if (widget.onComplete != null) {
                widget.onComplete!();
              } else {
                Navigator.of(context).pop(true);
              }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
                      Expanded(
                        flex: 5,
                        child: Container(
                          margin: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.92),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: const [
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
                                    CustomPaint(
                                      painter: LetterPathPainter(
                                        path: _letterPath,
                                        color: Colors.grey.withOpacity(0.12),
                                        strokeWidth: 30,
                                      ),
                                      size: Size.infinite,
                                    ),
                                    if (_lockedAfterSuccess)
                                      TweenAnimationBuilder<double>(
                                        tween: Tween(begin: 0.0, end: 1.0),
                                        duration: const Duration(
                                          milliseconds: 260,
                                        ),
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
                                    CustomPaint(
                                      painter: StepsPainter(
                                        steps: _steps,
                                        currentStep: _currentStep,
                                      ),
                                      size: Size.infinite,
                                    ),
                                    GestureDetector(
                                      onPanDown: (details) {
                                        if (_lockedAfterSuccess) return;
                                        if (_steps.isEmpty) return;
                                        if (_currentStep >= _steps.length) {
                                          return;
                                        }

                                        final start =
                                            _steps[_currentStep].startPoint;
                                        if ((details.localPosition - start)
                                                .distance <
                                            50) {
                                          setState(() {
                                            _showHand = false;
                                            pointsList.add([
                                              details.localPosition,
                                            ]);
                                            colorsList.add(selectedColor);
                                          });
                                        }
                                      },
                                      onPanUpdate: (details) {
                                        if (_lockedAfterSuccess) return;
                                        if (pointsList.isEmpty) return;
                                        setState(() {
                                          pointsList.last.add(
                                            details.localPosition,
                                          );
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
                                          if (_currentStep <
                                              _steps.length - 1) {
                                            _currentStep++;
                                            _showHand = true;
                                            return;
                                          }
                                          if (_stars >= 3) {
                                            _lockedAfterSuccess = true;
                                            _showCelebration();
                                            return;
                                          }
                                          _showHand = true;
                                        });
                                      },
                                      child: CustomPaint(
                                        painter: MyPainter(
                                          pointsList,
                                          colorsList,
                                        ),
                                        size: Size.infinite,
                                      ),
                                    ),
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

  Widget _buildKidoAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            child: CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: const Icon(Icons.arrow_back_ios_new, color: AppColors.kidoBlue),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 8),
                ],
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  children: [
                    Icon(Icons.rocket_launch, color: AppColors.kidoOrange),
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

  Widget _buildSideColors() {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _colorCircle(AppColors.kidoRed),
          _colorCircle(AppColors.kidoOrange),
          _colorCircle(AppColors.kidoGreen),
          _colorCircle(AppColors.kidoBlue),
          _colorCircle(AppColors.purpleMain),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _resetAll,
            child: Container(
              width: 54,
              height: 54,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
              ),
              child: const Icon(
                Icons.delete_outline,
                color: AppColors.kidoRed,
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
