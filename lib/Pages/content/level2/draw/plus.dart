import 'package:flutter/material.dart';
import 'package:kido/Widgets/Buttons/next_button.dart';
import 'package:kido/Models/level3/letter_step.dart';
import 'package:lottie/lottie.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:kido/constants.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import '../../../../Widgets/Animation/animated_hand_widget.dart';
import '../../../../Widgets/content/drawing_page.dart';

class PlusDrawingPage extends StatefulWidget {
  final VoidCallback? onNext;
  const PlusDrawingPage({super.key, this.onNext});

  @override
  State<PlusDrawingPage> createState() => _PlusDrawingPageState();
}

class _PlusDrawingPageState extends State<PlusDrawingPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isFinished = false;
  int _linesCompleted = 0;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _handleStepFinished() async {
    setState(() {
      _linesCompleted++;
    });
    if (_linesCompleted >= 2) {
      setState(() {
        _isFinished = true;
      });
      await _audioPlayer.play(AssetSource('audio/yaay.mp3'));
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
                      height: 200
                  ),
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
                onPressed: widget.onNext!,
              ),
            )
          ],
        ],
      ),
    );
  }
}