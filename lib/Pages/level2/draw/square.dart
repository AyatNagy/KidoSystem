// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:kido/Widgets/Buttons/next_button.dart';
import 'package:kido/Models/letter_step.dart';
import 'package:lottie/lottie.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:kido/constants.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import '../../../../Widgets/animated_hand_widget.dart';
import '../../../../Widgets/content/drawing_page.dart';

class SquareDrawingPage extends StatefulWidget {
  const SquareDrawingPage({super.key});

  @override
  State<SquareDrawingPage> createState() => _SquareDrawingPageState();
}

class _SquareDrawingPageState extends State<SquareDrawingPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isFinished = false;
  int _linesCompleted = 0;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  List<Offset> _getAllPoints() {
    return const [
      Offset(0.3, 0.3),
      Offset(0.7, 0.3),
      Offset(0.7, 0.55),
      Offset(0.3, 0.55),
      Offset(0.3, 0.3),
    ];
  }

  void _handleStepFinished() async {
    setState(() {
      _linesCompleted++;
    });

    if (_linesCompleted >= 5) {
      setState(() {
        _isFinished = true;
      });
      await _audioPlayer.play(AssetSource('audio/yaay.mp3'));
    }
  }

  List<LetterStep> _getSteps(double width, double height) {
    final p1 = Offset(0.3 * width, 0.3 * height);
    final p2 = Offset(0.7 * width, 0.3 * height);
    final p3 = Offset(0.7 * width, 0.55 * height);
    final p4 = Offset(0.3 * width, 0.55 * height);

    return [
      LetterStep(
          startPoint: p1,
          endPoint: p2,
          guidePoints: [p1, p2],
          number: 1
      ),
      LetterStep(
          startPoint: p2,
          endPoint: p3,
          guidePoints: [p2, p3],
          number: 2
      ),
      LetterStep(
          startPoint: p3,
          endPoint: p4,
          guidePoints: [p3, p4],
          number: 3
      ),
      LetterStep(
          startPoint: p4,
          endPoint: p1,
          guidePoints: [p4, p1],
          number: 4
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
            child: Container(color: AppColors.bgColor),  ),

          Drawing(
            guidePoints: _getAllPoints(),
            pointsPerStep: 1,
            validationThreshold: 60,
            onFinish: _handleStepFinished,
          ),

          AnimatedHandWidget(
            steps: _getSteps(config.localWidth, config.localHeight),
            currentStep: _linesCompleted.clamp(0, 3),
            visible: !_isFinished,
          ),

          if (_isFinished) ...[
            Positioned.fill(
              child: Container(
                color: AppColors.bgColor,
                child: Center(
                  child: Image.asset('assets/images/drawing/square.gif', height: 200),
                ),
              ),
            ),
            Center(
                child: Lottie.asset(
                    'assets/lottie/confetti.json',
                    fit: BoxFit.cover
                )
            ),
            Positioned(
              bottom: config.localHeight * 0.05,
              right: config.localWidth * 0.1,
              child: NextButton(
                color: AppColors.kidoGreen,
                shadowColor: AppColors.kidoColors[4],
                onPressed: () { },
              ),
            )
          ],
        ],
      ),
    );
  }
}