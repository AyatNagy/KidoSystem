import 'package:flutter/material.dart';
import 'package:kido/Widgets/Buttons/next_button.dart';
import 'package:kido/Models/letter_step.dart';
import 'package:lottie/lottie.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:kido/constants.dart';
import 'package:kido/Widgets/responsive_provider.dart';

import '../../../../../Widgets/animated_hand_widget.dart';
import '../../../../../Widgets/content/drawing_page.dart';

class OctobusAndStar extends StatefulWidget {
  const OctobusAndStar({super.key});

   @override
   State<OctobusAndStar> createState() => _OctobusAndStarState();
}

class _OctobusAndStarState extends State<OctobusAndStar> with TickerProviderStateMixin {
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
     if (_linesCompleted >= 1) {
       setState(() {
         _isFinished = true;
       });
       await _audioPlayer.play(AssetSource('audio/yaay.mp3'));
     }
   }
   List<Offset> _getAllPoints() {
     return const [
       Offset(0.25, 0.5),
       Offset(0.5, 0.5),
       Offset(0.75, 0.5),
     ];
   }
   List<LetterStep> _getSteps(double width, double height) {
     List<Offset> points = _getAllPoints().map((p) => Offset(p.dx * width, p.dy * height)).toList();
     return [
       LetterStep(
         startPoint: points.first,
         endPoint: points.last,
         guidePoints: points,
         number: 1,
       )
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
                 child: Image.asset(
                   'assets/images/drawing/st.gif',
                 ),
               )
             ),
             Center(
                 child: Lottie.asset('assets/lottie/confetti.json')
             ),
             Positioned(
               bottom: config.localHeight * 0.05,
               right: config.localWidth * 0.1,
               child: NextButton(
                 color: AppColors.kidoPink,
                 shadowColor: AppColors.kidoColors[1],
                 onPressed: () {},
               ),
             )
           ],
         ]
         )
     );
  }
}