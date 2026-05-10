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

class RocketLesson extends StatefulWidget {
  final VoidCallback? onNext;
  const RocketLesson({super.key, this.onNext});

  @override
  State<RocketLesson> createState() => _RocketLessonState();
}

class _RocketLessonState extends State<RocketLesson>
    with TickerProviderStateMixin {
  late AnimationController _rocketController;
  late Animation<Offset> _rocketAnimation;
  late AnimationController _glowController;
  bool _isLaunched = false;
  double _traceProgress = 0.0;
  Timer? _instructionTimer;

  @override
  void initState() {
    super.initState();
    _rocketController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _rocketAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(2.0, -2.0),
    ).animate(
      CurvedAnimation(parent: _rocketController, curve: Curves.easeInOutExpo),
    );

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _startInstructionTimer();
  }

  void _startInstructionTimer() {
    AudioService.play(fileName: 'shapes/lets_draw.mp3');
    _instructionTimer = Timer.periodic(const Duration(seconds: 5), (
      Timer timer,
    ) {
      if (!_isLaunched) {
        AudioService.play(fileName: 'shapes/lets_draw.mp3');
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _instructionTimer?.cancel();
    _rocketController.dispose();
    _glowController.dispose();
    AudioService.stop();
    super.dispose();
  }

  void _onLessonComplete() async {
    if (_isLaunched) return;
    _instructionTimer?.cancel();

    setState(() {
      _isLaunched = true;
      _traceProgress = 1.0;
    });

    await AudioService.play(fileName: 'yaay.mp3');
    _rocketController.forward();
  }

  List<LetterStep> _getSteps(double width, double height) {
    List<Offset> points = [
      Offset(width * 0.35, height * 0.65),
      Offset(width * 0.45, height * 0.55),
      Offset(width * 0.55, height * 0.45),
      Offset(width * 0.65, height * 0.35),
    ];
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
    final steps = _getSteps(config.localWidth, config.localHeight);

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Stack(
        children: [
          Positioned(
            left: 20,
            top: config.localHeight * 0.3,
            child: Column(
              children: [
                Icon(Icons.local_gas_station, color: AppColors.kidoYellow),
                const SizedBox(height: 8),
                Container(
                  height: config.localHeight * 0.3,
                  width: 15,
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.textGray),
                  ),
                  alignment: Alignment.bottomCenter,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: (config.localHeight * 0.3) * _traceProgress,
                    width: 15,
                    decoration: BoxDecoration(
                      color: AppColors.kidoOrange,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        if (_traceProgress > 0)
                          BoxShadow(
                            color: AppColors.kidoOrange,
                            blurRadius: 10,
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Drawing(
            guidePoints: const [
              Offset(0.35, 0.65),
              Offset(0.45, 0.55),
              Offset(0.55, 0.45),
              Offset(0.65, 0.35),
            ],
            onFinish: _onLessonComplete,
          ),
          AnimatedHandWidget(
            steps: steps,
            currentStep: 0,
            visible: !_isLaunched,
          ),
          Positioned(
            bottom: config.localHeight * 0.2,
            left: config.localWidth * 0.25,
            child: SlideTransition(
              position: _rocketAnimation,
              child: Transform.rotate(
                angle: -0.78,
                child: Image.asset('assets/images/rocket.png', width: 100),
              ),
            ),
          ),
          if (_isLaunched) ...[
            Center(
              child: Lottie.asset('assets/lottie/confetti.json', repeat: false),
            ),
            Positioned(
              bottom: config.localHeight * 0.05,
              right: config.localWidth * 0.1,
              child: NextButton(
                color: AppColors.kidoBlue,
                shadowColor: AppColors.kidoColors[1],
                onPressed: widget.onNext!,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
