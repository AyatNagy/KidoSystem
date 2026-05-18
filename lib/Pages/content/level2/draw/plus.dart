import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kido/Widgets/Buttons/next_button.dart';
import 'package:kido/Models/level3/letter_step.dart';
import 'package:kido/services/audio_service.dart';
import 'package:lottie/lottie.dart';
import 'package:kido/constants.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import '../../../../Widgets/Animation/animated_hand_widget.dart';
import '../../../../Widgets/content/drawing_page.dart';
import 'package:kido/utils/lesson_completion.dart';

class PlusDrawingPage extends StatefulWidget {
  final VoidCallback? onNext;
  final int childId;
  final int lessonId;

  const PlusDrawingPage({
    super.key,
    this.onNext,
    this.childId = 0,
    this.lessonId = 19,
  });

  @override
  State<PlusDrawingPage> createState() => _PlusDrawingPageState();
}

class _PlusDrawingPageState extends State<PlusDrawingPage> {
  Timer? _instructionTimer;
  bool _isFinished = false;
  int _linesCompleted = 0;

  @override
  void initState() {
    super.initState();
    _startInstructionTimer();
  }

  void _startInstructionTimer() {
    AudioService.play(fileName: 'shapes/lets_draw.mp3');
    _instructionTimer = Timer.periodic(const Duration(seconds: 5), (
      Timer timer,
    ) {
      if (!_isFinished) {
        AudioService.play(fileName: 'shapes/lets_draw.mp3');
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _instructionTimer?.cancel();
    AudioService.stop();
    super.dispose();
  }

  void _handleStepFinished() async {
    setState(() {
      _linesCompleted++;
    });

    if (_linesCompleted >= 2) {
      _instructionTimer?.cancel();
      AudioService.stop();

      setState(() {
        _isFinished = true;
      });
      await AudioService.play(fileName: 'yaay.mp3');
    }
  }

  List<Offset> _getAllPoints() {
    return const [
      Offset(0.5, 0.3),
      Offset(0.5, 0.5),
      Offset(0.5, 0.7),
      Offset(0.2, 0.5),
      Offset(0.8, 0.5),
    ];
  }

  List<LetterStep> _getSteps(double width, double height) {
    return [
      LetterStep(
        startPoint: Offset(0.5 * width, 0.3 * height),
        endPoint: Offset(0.5 * width, 0.7 * height),
        guidePoints: [
          Offset(0.5 * width, 0.3 * height),
          Offset(0.5 * width, 0.5 * height),
          Offset(0.5 * width, 0.7 * height),
        ],
        number: 1,
      ),
      LetterStep(
        startPoint: Offset(0.2 * width, 0.5 * height),
        endPoint: Offset(0.8 * width, 0.5 * height),
        guidePoints: [
          Offset(0.2 * width, 0.5 * height),
          Offset(0.5 * width, 0.5 * height),
          Offset(0.8 * width, 0.5 * height),
        ],
        number: 2,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);

    return Scaffold(
      body: Stack(
        children: [
          /*Positioned.fill(
            child: Image.asset(
              'assets/images/drawing/rocket-bg.jpg',
              fit: BoxShape.circle == BoxShape.circle ? BoxFit.contain : BoxFit.cover,
            ),
          ),*/
          Drawing(
            guidePoints: _getAllPoints(),
            pointsPerStep: 2,
            onFinish: _handleStepFinished,
          ),
          AnimatedHandWidget(
            steps: _getSteps(config.localWidth, config.localHeight),
            currentStep: _linesCompleted.clamp(0, 1),
            visible: !_isFinished,
          ),

          if (_isFinished) ...[
            Positioned.fill(
              child: Container(
                color: AppColors.kidoColors[5],
                child: Center(
                  child: Image.asset(
                    'assets/images/drawing/plus.gif',
                    height: 200,
                  ),
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
                onPressed: () async {
                  if (widget.childId > 0) {
                    await completeLessonForChild(
                      childId: widget.childId,
                      lessonId: widget.lessonId,
                    );
                  }
                  widget.onNext?.call();
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
