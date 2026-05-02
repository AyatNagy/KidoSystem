import 'package:flutter/material.dart';
import 'package:kido/services/audio_service.dart';

class SadEffect extends StatefulWidget {
  final Widget child;
  const SadEffect({super.key, required this.child});

  @override
  State<SadEffect> createState() => _SadEffectState();
}

class _SadEffectState extends State<SadEffect> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool hasPlayedAudio=false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _controller.addListener((){
      if(_controller.value<0.1){
        if(!hasPlayedAudio){
        AudioService.play(fileName: 'sad.wav');
        hasPlayedAudio=true;
        }
      }else{
        hasPlayedAudio=false;
      }
    });

    _animation = Tween<double>(begin: 0, end: 30).animate(_controller);

    _controller.repeat();

    AudioService.play(fileName: 'sad.wav');
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value), // Moves down
          child: Opacity(
            opacity: 1.0 - _controller.value, // Fades out
            child: widget.child,
          ),
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