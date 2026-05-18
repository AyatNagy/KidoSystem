import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kido/Widgets/Buttons/next_button.dart';
import 'package:kido/Models/level3/letter_step.dart';
import 'package:kido/services/audio_service.dart';
import 'package:lottie/lottie.dart';
import 'package:kido/constants.dart';
import 'package:kido/Widgets/responsive_provider.dart';

import '../../../../../Widgets/Animation/animated_hand_widget.dart';
import '../../../../../Widgets/content/drawing_page.dart';
import 'package:kido/utils/lesson_completion.dart';

class OctobusAndStar extends StatefulWidget {
  final VoidCallback? onNext;
  final int childId;
  final int lessonId;

  const OctobusAndStar({
    super.key,
    this.onNext,
    this.childId = 0,
    this.lessonId = 16,
  });

  @override
  State<OctobusAndStar> createState() => _OctobusAndStarState();
}

class _OctobusAndStarState extends State<OctobusAndStar>
    with TickerProviderStateMixin {
  bool _isFinished = false;
  int _linesCompleted = 0;
  Timer? _instructionTimer;

  @override
  void initState() {
    super.initState();
    _startInstructionTimer();
  }

  void _startInstructionTimer() {
    AudioService.play(fileName: 'shapes/lets_draw.mp3');
    _instructionTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
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
    if (_linesCompleted >= 1) {
      _instructionTimer?.cancel();
      setState(() {
        _isFinished = true;
      });
      await AudioService.play(fileName: 'yaay.mp3');
    }
  }

  List<Offset> _getAllPoints() {
    return const [Offset(0.25, 0.5), Offset(0.5, 0.5), Offset(0.75, 0.5)];
  }

  List<LetterStep> _getSteps(double width, double height) {
    List<Offset> points =
        _getAllPoints()
            .map((p) => Offset(p.dx * width, p.dy * height))
            .toList();
    return [
      LetterStep(
        startPoint: points.first,
        endPoint: points.last,
        guidePoints: points,
        number: 1,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/drawing/sea-bg.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: config.localHeight * 0.45,
            left: config.localWidth * 0.05,
            child: Image.asset(
              'assets/images/drawing/octobus.png',
              height: config.localHeight * 0.1,
            ),
          ),
          Positioned(
            top: config.localHeight * 0.45,
            right: config.localWidth * 0.01,
            child: Image.asset(
              'assets/images/drawing/sad-star.png',
              height: config.localHeight * 0.1,
            ),
          ),
          Drawing(
            guidePoints: _getAllPoints(),
            pointsPerStep: 3,
            onFinish: _handleStepFinished,
          ),
          AnimatedHandWidget(
            steps: _getSteps(config.localWidth, config.localHeight),
            currentStep: 0,
            visible: !_isFinished,
          ),
          if (_isFinished) ...[
            Positioned.fill(
              child: Container(
                color: AppColors.kidoBlue,
                child: Image.asset('assets/images/drawing/st.gif'),
              ),
            ),
            Center(child: Lottie.asset('assets/lottie/confetti.json')),
            Positioned(
              bottom: config.localHeight * 0.05,
              right: config.localWidth * 0.1,
              child: NextButton(
                color: AppColors.kidoPink,
                shadowColor: AppColors.kidoColors[1],
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
