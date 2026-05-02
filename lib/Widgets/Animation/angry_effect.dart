import'package:flutter/material.dart';
import 'package:kido/services/audio_service.dart';
class AngryEffect extends StatefulWidget {
  final Widget boy;
  final Widget leftEyebrow;
  final Widget rightEyebrow;

  const AngryEffect({
    super.key,
    required this.boy,
    required this.leftEyebrow,
    required this.rightEyebrow,
  });

  @override
  State<AngryEffect> createState() => _AngryEffectState();
}

class _AngryEffectState extends State<AngryEffect> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _tiltAnimation;
  late Animation<Color?> _redPulse;
  bool hasPlayedAudio=false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..repeat(reverse: true); // Pulse back and forth

    
    _tiltAnimation = Tween<double>(begin: 0.0, end: 0.2).animate(_controller);

    
    _redPulse = ColorTween(
      begin: Colors.transparent,
      end: Colors.red.withOpacity(0.3),
    ).animate(_controller);
     

     _controller.addListener((){
      if(_controller.value<0.1){
        if(!hasPlayedAudio){
        AudioService.play(fileName: 'angry.mp3');
        hasPlayedAudio=true;
        }
      }else{
        hasPlayedAudio=false;
      }
    });
    
    AudioService.play(fileName: 'angry.mp3');
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
           
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                _redPulse.value ?? Colors.transparent,
                BlendMode.srcATop,
              ),
              child: widget.boy,
            ),

            //Left eyebrow
            Positioned(
              top: 147,
              left: 173,
              child: Transform.rotate(
                angle: _tiltAnimation.value,
                child: widget.leftEyebrow,
              ),
            ),

            //Right eyebrow
            Positioned(
              top: 147,
              right: 173,
              child: Transform.rotate(
                angle: -_tiltAnimation.value,
                child: widget.rightEyebrow,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    AudioService.stop();
    _controller.dispose();
    super.dispose();
  }
} 