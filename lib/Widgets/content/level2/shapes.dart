import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:kido/constants.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import 'package:kido/Models/level3/letter_step.dart';
import 'package:kido/Widgets/Buttons/next_button.dart';
import 'package:kido/services/audio_service.dart';
import '../../Animation/animated_hand_widget.dart';
import '../../../Widgets/content/level2/drawing_shapes.dart';

class BaseDrawingPage extends StatefulWidget {
  final List<Offset> shapeData;
  final String successGif;
  final VoidCallback onNext;
  final int requiredPoints;
  final String shapeName;

  const BaseDrawingPage({
    super.key,
    required this.shapeData,
    required this.successGif,
    required this.onNext,
    required this.shapeName,
    this.requiredPoints = 0,
  });

  @override
  State<BaseDrawingPage> createState() => _BaseDrawingPageState();
}

class _BaseDrawingPageState extends State<BaseDrawingPage> {
  Timer? _instructionTimer;
  Timer? _successRepeatTimer;
  bool _isFinished = false;
  int _progressCount = 0;
  int _successCount = 0;

  @override
  void initState() {
    super.initState();
    _startInstructionTimer();
  }

  void _cleanup() {
    _instructionTimer?.cancel();
    _instructionTimer = null;
    _successRepeatTimer?.cancel();
    _successRepeatTimer = null;
    AudioService.stop();
  }

  @override
  void dispose() {
    _cleanup();
    super.dispose();
  }

  void _startInstructionTimer() {
    _cleanup();
    String fileName = "shapes/draw_${widget.shapeName}.mp3";
    AudioService.play(fileName: fileName);

    _instructionTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted && !_isFinished) {
        AudioService.play(fileName: fileName);
      } else {
        timer.cancel();
      }
    });
  }

  void _playSuccessSequence() {
    _cleanup();
    AudioService.play(fileName: "yaay.mp3");
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && _isFinished) {
        String fileName = "shapes/${widget.shapeName}.mp3";
        AudioService.play(fileName: fileName);
        _successCount = 1;

        _successRepeatTimer = Timer.periodic(const Duration(seconds: 2), (
          timer,
        ) {
          if (mounted && _isFinished && _successCount < 3) {
            AudioService.play(fileName: fileName);
            _successCount++;
          } else {
            timer.cancel();
          }
        });
      }
    });
  }

  void _handleProgress() {
    if (_isFinished) return;
    setState(() => _progressCount++);
    int target =
        widget.requiredPoints > 0
            ? widget.requiredPoints
            : widget.shapeData.length;
    if (_progressCount >= target) {
      setState(() => _isFinished = true);
      _playSuccessSequence();
    }
  }

  List<LetterStep> _getSteps(double width, double height) {
    return List.generate(widget.shapeData.length - 1, (index) {
      final pStart = widget.shapeData[index];
      final pEnd = widget.shapeData[index + 1];
      return LetterStep(
        startPoint: Offset(pStart.dx * width, pStart.dy * height),
        endPoint: Offset(pEnd.dx * width, pEnd.dy * height),
        guidePoints: [
          Offset(pStart.dx * width, pStart.dy * height),
          Offset(pEnd.dx * width, pEnd.dy * height),
        ],
        number: index + 1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: Container(color: AppColors.bgColor)),
          DrawingShapes(
            guidePoints: widget.shapeData,
            pointsPerStep: 1,
            onFinish: _handleProgress,
          ),
          AnimatedHandWidget(
            steps: _getSteps(config.localWidth, config.localHeight),
            currentStep: _progressCount.clamp(0, widget.shapeData.length - 2),
            visible: !_isFinished,
          ),
          if (_isFinished) ...[
            Positioned.fill(
              child: Container(
                color: AppColors.bgColor,
                child: Center(
                  child: Image.asset(widget.successGif, height: 200),
                ),
              ),
            ),
            Center(
              child: Lottie.asset(
                'assets/lottie/confetti.json',
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: config.localHeight * 0.05,
              right: config.localWidth * 0.1,
              child: NextButton(
                color: AppColors.kidoGreen,
                shadowColor: AppColors.kidoColors[4],
                onPressed: () {
                  _cleanup();
                  widget.onNext();
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
