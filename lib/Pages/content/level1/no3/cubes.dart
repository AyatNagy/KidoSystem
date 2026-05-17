// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:kido/Widgets/Buttons/next_button.dart';
import 'package:kido/Widgets/Buttons/replay_button.dart';
import 'package:kido/constants.dart';
import 'package:lottie/lottie.dart';
import '../../../../Widgets/Animation/animated_hand_widget.dart';
import '../../../../Widgets/content/draganddrop.dart';
import '../../../../Widgets/responsive_provider.dart';
import '../../../../config/responsive_config.dart';
import '../../../../data/content/level1/cubes.dart';
import '../../../../services/audio_service.dart';
import 'moving_car.dart';

class CubesLesson extends StatefulWidget {
  final VoidCallback? onNext;
  final String childName;
  final int childId;
  const CubesLesson({
    super.key,
    this.onNext,
    required this.childName,
    required this.childId,
  });

  @override
  State<CubesLesson> createState() => _CubesLessonState();
}

class _CubesLessonState extends State<CubesLesson> {
  bool _isFinished = false;
  bool _showTutorial = true;
  int _currentStep = 0;
  Key _dragDropKey = UniqueKey();
  final stackingQuestion = StackingLessonsData.cubes;

  @override
  void initState() {
    super.initState();
    _playWelcomeAudio();
  }
  void _playWelcomeAudio() async {
    await AudioService.play(fileName: 'level1/put_boxs.mp3');
  }

  void _handleSuccess(Map<String, String?> answers) async {
    setState(() {
      _currentStep = answers.length;
      _showTutorial = false;
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted && !_isFinished) setState(() => _showTutorial = true);
      });
    });

    if (answers.length == 3) {
      setState(() {
        _isFinished = true;
        _showTutorial = false;
      });
      await AudioService.play(fileName: 'yaay.mp3');
    }
  }

  void _replayLesson() {
    setState(() {
      _isFinished = false;
      _currentStep = 0;
      _showTutorial = true;
      _dragDropKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ResponsiveConfig responsive = ResponsiveProvider.of(context);
    final sw = responsive.localWidth;
    final sh = responsive.localHeight;
    final tutorialSteps = StackingLessonsData.getStackingSteps(sw, sh);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [Color(0xFFFFFDE7), Color(0xFFFFF9C4)],
            center: Alignment.center,
            radius: 1.2,
          ),
        ),
        child: Stack(
          children: [
            DragDropWidget(
              key: _dragDropKey,
              question: stackingQuestion,
              onDragStart: () {
                AudioService.play(fileName: 'pop.mp3');
                setState(() => _showTutorial = false);
              },
              onWrongDrop: () {
                setState(() => _showTutorial = true);
              },
              onAnswered: _handleSuccess,
            ),
            AnimatedHandWidget(
              visible:
                  _showTutorial &&
                  !_isFinished &&
                  _currentStep < tutorialSteps.length,
              currentStep: _currentStep,
              steps: tutorialSteps,
            ),
            if (_isFinished) ...[
              Positioned.fill(
                child: Lottie.asset(
                  'assets/lottie/confetti.json',
                  fit: BoxFit.cover,
                  repeat: false,
                ),
              ),
              Positioned(
                bottom: sh * 0.05,
                right: sw * 0.05,
                child: NextButton(
                  color: AppColors.kidoOrange,
                  onPressed: () {
                    if (widget.onNext != null) {
                      widget.onNext!();
                    } else {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder:
                              (context) => MovingCarPage(
                                childName: widget.childName,
                                childId: widget.childId,
                              ),
                        ),
                      );
                    }
                  },
                ),
              ),
              Positioned(
                bottom: sh * 0.05,
                left: sw * 0.05,
                child: ReplayButton(
                  color: AppColors.kidoOrange,
                  onPressed: _replayLesson,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}