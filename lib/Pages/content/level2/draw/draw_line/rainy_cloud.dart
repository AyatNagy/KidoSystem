import 'package:flutter/material.dart';
import 'package:kido/Widgets/Buttons/next_button.dart';
import 'package:kido/Models/level3/letter_step.dart';
import 'package:lottie/lottie.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:kido/constants.dart';
import 'package:kido/Widgets/responsive_provider.dart';

import '../../../../../Widgets/Animation/animated_hand_widget.dart';
import '../../../../../Widgets/content/drawing_page.dart';

class RainyCloud extends StatefulWidget {
  final VoidCallback? onNext;
  const RainyCloud({super.key, this.onNext});

  @override
  State<RainyCloud> createState() => _RainyCloudState();
}

class _RainyCloudState extends State<RainyCloud> with TickerProviderStateMixin {
  late AnimationController _cloudController;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isFinished = false;
  int _linesCompleted = 0;

  @override
  void initState() {
    super.initState();
    _cloudController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _cloudController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _handleStepFinished() async {
    setState(() {
      _linesCompleted++;
    });

    if (_linesCompleted >= 3) {
      setState(() {
        _isFinished = true;
      });
      await _audioPlayer.play(AssetSource('audio/yaay.mp3'));
    }
  }

  List<Offset> _getAllPoints() {
    List<Offset> points = [];
    List<double> xPositions = [0.25, 0.5, 0.75];
    for (double x in xPositions) {
      for (double y = 0.5; y <= 0.8; y += 0.1) {
        points.add(Offset(x, y));
      }
    }
    return points;
  }

  List<LetterStep> _getSteps(double width, double height) {
    List<double> xPositions = [0.25, 0.5, 0.75];
    return xPositions.asMap().entries.map((entry) {
      int i = entry.key;
      double x = entry.value;
      List<Offset> points = [];
      for (double y = 0.5; y <= 0.81; y += 0.1) {
        points.add(Offset(x * width, y * height));
      }
      return LetterStep(
        startPoint: points.first,
        endPoint: points.last,
        guidePoints: points,
        number: i + 1,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);

    return Scaffold(
        backgroundColor: AppColors.kidoColors[1],
        body: Stack(
            children: [
              AnimatedBuilder(
                animation: _cloudController,
                builder: (context, child) {
                  return Positioned(
                      top: config.localHeight * 0.2,
                      left: config.localWidth * 0.1 + (_cloudController.value * 20),
                      child: Image.asset(
                        'assets/images/cloud.png',
                        height: config.localHeight * 0.25,
                        width: config.localWidth * 0.7,
                      )
                  );
                },
              ),

              Drawing(
                guidePoints: _getAllPoints(),
                pointsPerStep: 4,
                onFinish: _handleStepFinished,
              ),

              AnimatedHandWidget(
                steps: _getSteps(config.localWidth, config.localHeight),
                currentStep: _linesCompleted.clamp(0, 2),
                visible: !_isFinished,
              ),

              if (_isFinished) ...[
                Positioned.fill(
                  child: Container(
                    color: AppColors.kidoColors[1],
                    child: Image.asset('assets/gif/rainy-cloud.gif'),
                  ),
                ),
                Center(child: Lottie.asset('assets/lottie/confetti.json')),
                Positioned(
                  bottom: config.localHeight * 0.05,
                  right: config.localWidth * 0.1,
                  child: NextButton(
                    color: AppColors.kidoBlue,
                    shadowColor: AppColors.kidoColors[1],
                    onPressed: widget.onNext!,
                  ),
                )
              ],
            ]
        )
    );
  }
}