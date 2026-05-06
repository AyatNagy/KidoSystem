import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:kido/constants.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import 'package:kido/Models/letter_step.dart';
import 'package:kido/Widgets/Buttons/next_button.dart';
import '../../../../Widgets/animated_hand_widget.dart';
import '../../../Widgets/content/level2/drawing_shapes.dart';

class BaseDrawingPage extends StatefulWidget {
  final List<Offset> shapeData;
  final String successGif;
  final VoidCallback onNext;
  final int requiredPoints;

  const BaseDrawingPage({
    super.key,
    required this.shapeData,
    required this.successGif,
    required this.onNext,
    this.requiredPoints = 0,
  });

  @override
  State<BaseDrawingPage> createState() => _BaseDrawingPageState();
}

class _BaseDrawingPageState extends State<BaseDrawingPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isFinished = false;
  int _progressCount = 0;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _handleProgress() async {
    if (_isFinished) return;
    setState(() => _progressCount++);

    int target = widget.requiredPoints > 0
        ? widget.requiredPoints
        : widget.shapeData.length;

    if (_progressCount >= target) {
      setState(() => _isFinished = true);
      await _audioPlayer.play(AssetSource('audio/yaay.mp3'));
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
            Center(child: Lottie.asset('assets/lottie/confetti.json', fit: BoxFit.cover)),
            Positioned(
              bottom: config.localHeight * 0.05,
              right: config.localWidth * 0.1,
              child: NextButton(
                color: AppColors.kidoGreen,
                shadowColor: AppColors.kidoColors[4],
                onPressed: widget.onNext,
              ),
            )
          ],
        ],
      ),
    );
  }
}